"""
Autenticación del panel administrativo (JWT en cookie HttpOnly).

- Login con email + contraseña contra la tabla users (is_admin=True).
- El token va en cookie HttpOnly/SameSite; nunca expuesto al JS.
- `ensure_admin()` crea el admin inicial al arrancar (ADMIN_EMAIL/ADMIN_PASSWORD).
- `get_current_admin` protege los endpoints del panel.
"""
from __future__ import annotations

import pyotp
from fastapi import APIRouter, Cookie, Depends, HTTPException, Request, Response
from sqlalchemy.orm import Session

from core.config import settings
from core.db import SessionLocal, get_db
from core.models import AuditLog, User
from core.security import (
    create_access_token, decode_token, hash_password, password_needs_rehash,
    verify_password,
)
from core.web_security import clear_failures, is_locked, record_failure

COOKIE_NAME = "mi_admin"
ADMIN_TOKEN_MINUTES = 720  # 12 h de sesión de admin

auth_router = APIRouter(prefix="/api/auth", tags=["auth"])


# --------------------------------------------------------------------------- #
# Dependencia: admin actual
# --------------------------------------------------------------------------- #
def get_current_admin(
    request: Request,
    db: Session = Depends(get_db),
    mi_admin: str | None = Cookie(default=None),
) -> User:
    token = mi_admin
    if not token:
        # fallback: Authorization: Bearer xxx (útil para tests/curl)
        auth = request.headers.get("Authorization", "")
        if auth.lower().startswith("bearer "):
            token = auth[7:]
    payload = decode_token(token) if token else None
    if not payload or payload.get("type") != "access":
        raise HTTPException(401, "No autenticado")
    user = db.get(User, int(payload["sub"])) if payload.get("sub") else None
    if not user or not user.is_admin or not user.is_active:
        raise HTTPException(403, "Acceso denegado")
    return user


# --------------------------------------------------------------------------- #
# Endpoints
# --------------------------------------------------------------------------- #
@auth_router.post("/login")
def login(body: dict, response: Response, request: Request, db: Session = Depends(get_db)):
    email = (body.get("email") or "").strip().lower()
    password = body.get("password") or ""
    ip = request.client.host if request.client else "?"
    lock_key = f"admin:{email}:{ip}"

    rem = is_locked(lock_key)
    if rem:
        raise HTTPException(429, f"Demasiados intentos. Reintentá en {rem // 60 + 1} min.")

    user = db.query(User).filter(User.email == email).one_or_none()
    if not user or not user.is_admin or not verify_password(password, user.password_hash):
        record_failure(lock_key)
        db.add(AuditLog(action="admin_login_failed", entity="user", entity_id=email, ip=ip))
        db.commit()
        raise HTTPException(401, "Email o contraseña incorrectos")
    if not user.is_active:
        raise HTTPException(403, "Usuario inactivo")

    # MFA/TOTP obligatorio si está habilitado.
    if user.totp_enabled:
        code = (body.get("totp_code") or "").strip()
        if not code:
            return {"ok": False, "mfa_required": True}
        if not pyotp.TOTP(user.totp_secret).verify(code, valid_window=1):
            record_failure(lock_key)
            db.add(AuditLog(user_id=user.id, action="admin_mfa_failed", entity="user",
                            entity_id=str(user.id), ip=ip))
            db.commit()
            raise HTTPException(401, "Código MFA inválido")

    # Login OK: limpiar bloqueo y rehashear a Argon2 si hacía falta.
    clear_failures(lock_key)
    if password_needs_rehash(user.password_hash):
        user.password_hash = hash_password(password)

    token = create_access_token(user.id, {"adm": True}, minutes=ADMIN_TOKEN_MINUTES)
    response.set_cookie(
        key=COOKIE_NAME, value=token, httponly=True, samesite="strict",
        secure=settings.COOKIE_SECURE, max_age=ADMIN_TOKEN_MINUTES * 60,
        domain=settings.COOKIE_DOMAIN, path="/",
    )
    db.add(AuditLog(user_id=user.id, action="admin_login", entity="user", entity_id=str(user.id), ip=ip))
    db.commit()
    return {"ok": True, "email": user.email, "name": user.full_name,
            "mfa_enabled": user.totp_enabled, "mfa_setup_required": not user.totp_enabled}


@auth_router.post("/logout")
def logout(response: Response):
    response.delete_cookie(COOKIE_NAME, path="/", domain=settings.COOKIE_DOMAIN)
    return {"ok": True}


@auth_router.get("/me")
def me(admin: User = Depends(get_current_admin)):
    return {"id": admin.id, "email": admin.email, "name": admin.full_name,
            "is_admin": admin.is_admin, "role": admin.role, "mfa_enabled": admin.totp_enabled}


# --------------------------------------------------------------------------- #
# MFA / TOTP (Google Authenticator, Authy, 1Password, etc.)
# --------------------------------------------------------------------------- #
@auth_router.post("/totp/setup")
def totp_setup(admin: User = Depends(get_current_admin), db: Session = Depends(get_db)):
    """Genera (o reusa) el secreto TOTP y devuelve la URI para el QR.
    No queda habilitado hasta confirmar un código con /totp/enable."""
    if not admin.totp_secret or admin.totp_enabled is False:
        admin.totp_secret = pyotp.random_base32()
        db.commit()
    uri = pyotp.TOTP(admin.totp_secret).provisioning_uri(
        name=admin.email, issuer_name="MIAMI IMPORT Panel")
    return {"secret": admin.totp_secret, "otpauth_uri": uri}


@auth_router.post("/totp/enable")
def totp_enable(body: dict, request: Request, admin: User = Depends(get_current_admin),
                db: Session = Depends(get_db)):
    code = (body.get("totp_code") or "").strip()
    if not admin.totp_secret or not pyotp.TOTP(admin.totp_secret).verify(code, valid_window=1):
        raise HTTPException(400, "Código inválido")
    admin.totp_enabled = True
    db.add(AuditLog(user_id=admin.id, action="mfa_enabled", entity="user", entity_id=str(admin.id),
                    ip=request.client.host if request.client else None))
    db.commit()
    return {"ok": True}


@auth_router.post("/totp/disable")
def totp_disable(body: dict, request: Request, admin: User = Depends(get_current_admin),
                 db: Session = Depends(get_db)):
    # Para desactivar exigimos un código válido (evita que un secuestro de sesión lo apague).
    code = (body.get("totp_code") or "").strip()
    if admin.totp_enabled and not pyotp.TOTP(admin.totp_secret or "").verify(code, valid_window=1):
        raise HTTPException(400, "Código inválido")
    admin.totp_enabled = False
    admin.totp_secret = None
    db.add(AuditLog(user_id=admin.id, action="mfa_disabled", entity="user", entity_id=str(admin.id),
                    ip=request.client.host if request.client else None))
    db.commit()
    return {"ok": True}


# --------------------------------------------------------------------------- #
# Bootstrap del admin inicial
# --------------------------------------------------------------------------- #
def ensure_admin() -> None:
    """Crea/actualiza el admin inicial si ADMIN_EMAIL/ADMIN_PASSWORD están seteados.
    Si no hay password configurada y no existe ningún admin, avisa por consola."""
    db = SessionLocal()
    try:
        any_admin = db.query(User).filter(User.is_admin.is_(True)).first()
        if settings.ADMIN_EMAIL and settings.ADMIN_PASSWORD:
            email = settings.ADMIN_EMAIL.strip().lower()
            user = db.query(User).filter(User.email == email).one_or_none()
            if not user:
                user = User(email=email, is_admin=True, email_verified=True)
                db.add(user)
            user.is_admin = True
            user.is_active = True
            user.role = "owner"
            user.password_hash = hash_password(settings.ADMIN_PASSWORD)
            user.full_name = user.full_name or "Administrador"
            db.commit()
            print(f"[auth] admin asegurado: {email}")
        elif not any_admin:
            print("[auth] ⚠ No hay admin y no se configuró ADMIN_PASSWORD. "
                  "Seteá ADMIN_EMAIL/ADMIN_PASSWORD en .env para crear uno.")
    finally:
        db.close()
