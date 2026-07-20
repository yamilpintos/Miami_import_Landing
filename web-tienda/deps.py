"""
Dependencias de sesión de la tienda.

Vive aparte de `auth_store` porque `cart` también necesita saber quién es el
usuario, y `auth_store` ya importa `cart` (importarlo al revés sería un ciclo).
"""
from __future__ import annotations

from fastapi import Cookie, Depends, HTTPException, Response
from sqlalchemy.orm import Session

from core.config import settings
from core.db import get_db
from core.models import User
from core.security import create_access_token, decode_token

SESSION_COOKIE = "mi_session"


def set_session(response: Response, user: User) -> None:
    """Emite la cookie de sesión.

    El claim `tv` congela la versión de sesión del usuario: si se cambia la
    contraseña (o se cierra sesión en todos lados), `token_version` sube y
    todos los JWT viejos dejan de validar aunque no hayan expirado.
    """
    token = create_access_token(
        user.id,
        {"cust": True, "tv": user.token_version or 0},
        minutes=settings.SESSION_MINUTES,
    )
    response.set_cookie(
        SESSION_COOKIE, token, httponly=True, samesite="lax",
        secure=settings.COOKIE_SECURE, max_age=settings.SESSION_MINUTES * 60,
        domain=settings.COOKIE_DOMAIN, path="/",
    )


def current_user(db: Session = Depends(get_db),
                 mi_session: str | None = Cookie(default=None)) -> User | None:
    payload = decode_token(mi_session) if mi_session else None
    if not payload or payload.get("type") != "access":
        return None
    # Un token del PANEL no debe servir como sesión de cliente ni al revés.
    if not payload.get("cust"):
        return None
    if not payload.get("sub"):
        return None
    try:
        user = db.get(User, int(payload["sub"]))
    except (TypeError, ValueError):
        return None
    if not user or not user.is_active:
        return None
    if int(payload.get("tv", -1)) != int(user.token_version or 0):
        return None  # sesión invalidada (cambio de contraseña / logout global)
    return user


def require_user(user: User | None = Depends(current_user)) -> User:
    if not user:
        raise HTTPException(401, "Iniciá sesión para continuar")
    return user
