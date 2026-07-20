"""
Autenticación de clientes de la tienda.

- Registro / login con email + contraseña (bcrypt), sesión en cookie HttpOnly.
- Google OAuth (flujo de código de autorización).
- Recuperación de contraseña por token (en dev devuelve el link; en prod se envía por email).
- Al loguearse fusiona el carrito anónimo con el del usuario.
"""
from __future__ import annotations

import secrets
from datetime import datetime, timezone

import requests
from email_validator import EmailNotValidError, validate_email
from fastapi import APIRouter, Cookie, Depends, HTTPException, Request, Response
from fastapi.responses import RedirectResponse
from sqlalchemy.orm import Session

from cart import COOKIE_NAME as CART_COOKIE
from cart import merge_anonymous_cart_into_user
from core.config import settings
from core.db import get_db
from core.models import Address, AuditLog, Order, PasswordReset, User
from core.security import (
    create_access_token, decode_token, generate_opaque_token, hash_password,
    hash_token, password_needs_rehash, refresh_expiry, verify_password,
)
from core.web_security import clear_failures, is_locked, record_failure

SESSION_COOKIE = "mi_session"
SESSION_MINUTES = 60 * 24 * 14  # 14 días

account_router = APIRouter(prefix="/api/account", tags=["account"])
oauth_router = APIRouter(tags=["oauth"])


# --------------------------------------------------------------------------- #
# Sesión
# --------------------------------------------------------------------------- #
def _set_session(response: Response, user: User) -> None:
    token = create_access_token(user.id, {"cust": True}, minutes=SESSION_MINUTES)
    response.set_cookie(
        SESSION_COOKIE, token, httponly=True, samesite="lax",
        secure=settings.COOKIE_SECURE, max_age=SESSION_MINUTES * 60,
        domain=settings.COOKIE_DOMAIN, path="/",
    )


def current_user(db: Session = Depends(get_db),
                 mi_session: str | None = Cookie(default=None)) -> User | None:
    payload = decode_token(mi_session) if mi_session else None
    if not payload or payload.get("type") != "access":
        return None
    user = db.get(User, int(payload["sub"])) if payload.get("sub") else None
    return user if (user and user.is_active) else None


def require_user(user: User | None = Depends(current_user)) -> User:
    if not user:
        raise HTTPException(401, "Iniciá sesión para continuar")
    return user


# --------------------------------------------------------------------------- #
# Registro / login / logout
# --------------------------------------------------------------------------- #
@account_router.post("/register")
def register(body: dict, response: Response, request: Request,
             db: Session = Depends(get_db), mi_cart: str | None = Cookie(default=None)):
    try:
        email = validate_email(body.get("email", ""), check_deliverability=False).normalized.lower()
    except EmailNotValidError:
        raise HTTPException(400, "Email inválido")
    password = body.get("password") or ""
    if len(password) < 8:
        raise HTTPException(400, "La contraseña debe tener al menos 8 caracteres")
    if db.query(User).filter(User.email == email).first():
        raise HTTPException(409, "Ya existe una cuenta con ese email")

    user = User(email=email, password_hash=hash_password(password),
                full_name=(body.get("full_name") or "").strip() or None,
                phone=(body.get("phone") or "").strip() or None)
    db.add(user)
    db.commit()
    db.refresh(user)
    merge_anonymous_cart_into_user(db, user.id, mi_cart)
    _set_session(response, user)
    db.add(AuditLog(user_id=user.id, action="register", entity="user", entity_id=str(user.id),
                    ip=request.client.host if request.client else None))
    db.commit()
    return {"ok": True, "email": user.email, "name": user.full_name}


@account_router.post("/login")
def login(body: dict, response: Response, request: Request,
          db: Session = Depends(get_db), mi_cart: str | None = Cookie(default=None)):
    email = (body.get("email") or "").strip().lower()
    password = body.get("password") or ""
    ip = request.client.host if request.client else "?"
    lock_key = f"cust:{email}:{ip}"
    rem = is_locked(lock_key)
    if rem:
        raise HTTPException(429, f"Demasiados intentos. Reintentá en {rem // 60 + 1} min.")
    user = db.query(User).filter(User.email == email).one_or_none()
    if not user or not verify_password(password, user.password_hash):
        record_failure(lock_key)
        db.add(AuditLog(action="login_failed", entity="user", entity_id=email, ip=ip))
        db.commit()
        raise HTTPException(401, "Email o contraseña incorrectos")
    if not user.is_active:
        raise HTTPException(403, "Cuenta inactiva")
    clear_failures(lock_key)
    if password_needs_rehash(user.password_hash):
        user.password_hash = hash_password(password)
        db.commit()
    merge_anonymous_cart_into_user(db, user.id, mi_cart)
    _set_session(response, user)
    db.add(AuditLog(user_id=user.id, action="login", entity="user", entity_id=str(user.id),
                    ip=request.client.host if request.client else None))
    db.commit()
    return {"ok": True, "email": user.email, "name": user.full_name}


@account_router.post("/logout")
def logout(response: Response):
    response.delete_cookie(SESSION_COOKIE, path="/", domain=settings.COOKIE_DOMAIN)
    return {"ok": True}


@account_router.get("/me")
def me(user: User = Depends(require_user)):
    return {"id": user.id, "email": user.email, "name": user.full_name,
            "phone": user.phone, "google": bool(user.google_id)}


@account_router.put("/profile")
def update_profile(body: dict, user: User = Depends(require_user), db: Session = Depends(get_db)):
    if "full_name" in body:
        user.full_name = (body["full_name"] or "").strip() or None
    if "phone" in body:
        user.phone = (body["phone"] or "").strip() or None
    db.commit()
    return {"ok": True}


_ADDR_FIELDS = ("label", "full_name", "phone", "street", "number", "floor",
                "city", "province", "zipcode", "country")


def _addr_json(a: Address) -> dict:
    d = {f: getattr(a, f) for f in _ADDR_FIELDS}
    d.update({"id": a.id, "is_default": a.is_default})
    return d


@account_router.get("/addresses")
def list_addresses(user: User = Depends(require_user), db: Session = Depends(get_db)):
    return [_addr_json(a) for a in user.addresses]


@account_router.post("/addresses")
def create_address(body: dict, user: User = Depends(require_user), db: Session = Depends(get_db)):
    a = Address(user_id=user.id)
    for f in _ADDR_FIELDS:
        if f in body:
            setattr(a, f, (body[f] or "").strip() or None)
    a.country = a.country or "AR"
    if body.get("is_default") or not user.addresses:
        for other in user.addresses:
            other.is_default = False
        a.is_default = True
    db.add(a)
    db.commit()
    db.refresh(a)
    return _addr_json(a)


@account_router.put("/addresses/{aid}")
def update_address(aid: int, body: dict, user: User = Depends(require_user), db: Session = Depends(get_db)):
    a = db.get(Address, aid)
    if not a or a.user_id != user.id:
        raise HTTPException(404, "Dirección no encontrada")
    for f in _ADDR_FIELDS:
        if f in body:
            setattr(a, f, (body[f] or "").strip() or None)
    if body.get("is_default"):
        for other in user.addresses:
            other.is_default = (other.id == aid)
    db.commit()
    return _addr_json(a)


@account_router.delete("/addresses/{aid}")
def delete_address(aid: int, user: User = Depends(require_user), db: Session = Depends(get_db)):
    a = db.get(Address, aid)
    if not a or a.user_id != user.id:
        raise HTTPException(404, "Dirección no encontrada")
    db.delete(a)
    db.commit()
    return {"ok": True}


# --------------------------------------------------------------------------- #
# Recuperación de contraseña
# --------------------------------------------------------------------------- #
@account_router.post("/password/forgot")
def password_forgot(body: dict, db: Session = Depends(get_db)):
    email = (body.get("email") or "").strip().lower()
    user = db.query(User).filter(User.email == email).one_or_none()
    # Respondemos siempre OK (no revelar si el email existe).
    if not user:
        return {"ok": True}
    raw = generate_opaque_token()
    db.add(PasswordReset(user_id=user.id, token_hash=hash_token(raw), expires_at=refresh_expiry()))
    db.commit()
    link = f"{settings.STORE_BASE_URL}/cuenta/reset?token={raw}"
    # En producción esto se envía por email (SMTP). En dev lo devolvemos para poder probar.
    if settings.DEV_MODE:
        return {"ok": True, "dev_reset_link": link}
    # TODO: enviar `link` por email cuando haya SMTP configurado.
    print(f"[password-reset] link para {email}: {link}")
    return {"ok": True}


@account_router.post("/password/reset")
def password_reset(body: dict, db: Session = Depends(get_db)):
    raw = body.get("token") or ""
    password = body.get("password") or ""
    if len(password) < 8:
        raise HTTPException(400, "La contraseña debe tener al menos 8 caracteres")
    pr = db.query(PasswordReset).filter(PasswordReset.token_hash == hash_token(raw)).one_or_none()
    if not pr or pr.used or pr.expires_at < datetime.now(timezone.utc):
        raise HTTPException(400, "Token inválido o expirado")
    user = db.get(User, pr.user_id)
    user.password_hash = hash_password(password)
    pr.used = True
    db.commit()
    return {"ok": True}


# --------------------------------------------------------------------------- #
# Google OAuth
# --------------------------------------------------------------------------- #
GOOGLE_AUTH = "https://accounts.google.com/o/oauth2/v2/auth"
GOOGLE_TOKEN = "https://oauth2.googleapis.com/token"
GOOGLE_USERINFO = "https://openidconnect.googleapis.com/v1/userinfo"


def _google_redirect_uri() -> str:
    return f"{settings.STORE_BASE_URL}/auth/google/callback"


@oauth_router.get("/auth/google/login")
def google_login():
    if not settings.GOOGLE_CLIENT_ID:
        raise HTTPException(503, "Google OAuth no está configurado")
    state = secrets.token_urlsafe(16)
    from urllib.parse import urlencode
    params = {
        "client_id": settings.GOOGLE_CLIENT_ID,
        "redirect_uri": _google_redirect_uri(),
        "response_type": "code",
        "scope": "openid email profile",
        "state": state,
        "access_type": "online",
        "prompt": "select_account",
    }
    resp = RedirectResponse(f"{GOOGLE_AUTH}?{urlencode(params)}")
    resp.set_cookie("g_state", state, httponly=True, samesite="lax",
                    secure=settings.COOKIE_SECURE, max_age=600, path="/")
    return resp


@oauth_router.get("/auth/google/callback")
def google_callback(request: Request, code: str = "", state: str = "",
                    db: Session = Depends(get_db),
                    g_state: str | None = Cookie(default=None),
                    mi_cart: str | None = Cookie(default=None)):
    if not settings.GOOGLE_CLIENT_ID or not settings.GOOGLE_CLIENT_SECRET:
        raise HTTPException(503, "Google OAuth no está configurado")
    if not code or not state or state != g_state:
        raise HTTPException(400, "Estado OAuth inválido")
    tok = requests.post(GOOGLE_TOKEN, data={
        "code": code,
        "client_id": settings.GOOGLE_CLIENT_ID,
        "client_secret": settings.GOOGLE_CLIENT_SECRET,
        "redirect_uri": _google_redirect_uri(),
        "grant_type": "authorization_code",
    }, timeout=15)
    if not tok.ok:
        raise HTTPException(502, "No se pudo validar con Google")
    access = tok.json().get("access_token")
    info = requests.get(GOOGLE_USERINFO, headers={"Authorization": f"Bearer {access}"}, timeout=15).json()
    google_id = info.get("sub")
    email = (info.get("email") or "").lower()
    if not google_id or not email:
        raise HTTPException(502, "Google no devolvió email")

    user = db.query(User).filter(User.google_id == google_id).one_or_none()
    if not user:
        user = db.query(User).filter(User.email == email).one_or_none()
        if user:
            user.google_id = google_id  # vincular cuenta existente
        else:
            user = User(email=email, google_id=google_id, full_name=info.get("name"),
                        email_verified=bool(info.get("email_verified")))
            db.add(user)
    db.commit()
    db.refresh(user)
    merge_anonymous_cart_into_user(db, user.id, mi_cart)

    resp = RedirectResponse("/cuenta", status_code=302)
    _set_session(resp, user)
    resp.delete_cookie("g_state", path="/")
    db.add(AuditLog(user_id=user.id, action="login_google", entity="user", entity_id=str(user.id),
                    ip=request.client.host if request.client else None))
    db.commit()
    return resp
