"""
Primitivas de seguridad compartidas: hashing de contraseñas (Argon2id) y JWT.

- Argon2id es el algoritmo recomendado por OWASP para contraseñas (2024+).
- Compatibilidad hacia atrás: si quedó algún hash bcrypt viejo, se verifica y
  se re-hashea a Argon2 en el próximo login (ver password_needs_rehash).
Las claves salen de la config (entorno). Nunca hardcodear secretos.
"""
from __future__ import annotations

import hashlib
import secrets
from datetime import datetime, timedelta, timezone

import bcrypt
import jwt
from argon2 import PasswordHasher
from argon2.exceptions import InvalidHashError, VerifyMismatchError

from .config import settings

# Parámetros Argon2id (balance seguridad/latencia para web; ajustables por entorno).
_ph = PasswordHasher(time_cost=3, memory_cost=64 * 1024, parallelism=2,
                     hash_len=32, salt_len=16)

# Hash señuelo: se verifica contra él cuando el usuario no existe / no tiene
# contraseña, para que el login pague SIEMPRE el costo de Argon2. Sin esto, un
# email inexistente responde en ~1 ms y uno real en ~100 ms, y esa diferencia
# de tiempo permite enumerar cuentas.
_DECOY_HASH = _ph.hash("decoy-password-para-timing-constante")


def hash_password(plain: str) -> str:
    return _ph.hash(plain)


def verify_password(plain: str, hashed: str | None) -> bool:
    if not hashed:
        # Igualar el tiempo con una verificación real contra el señuelo.
        try:
            _ph.verify(_DECOY_HASH, plain)
        except (VerifyMismatchError, InvalidHashError):
            pass
        return False
    # Hashes nuevos: Argon2 ($argon2id$...). Viejos: bcrypt ($2a/$2b/$2y$).
    if hashed.startswith("$argon2"):
        try:
            return _ph.verify(hashed, plain)
        except (VerifyMismatchError, InvalidHashError):
            return False
    if hashed.startswith("$2"):
        try:
            return bcrypt.checkpw(plain.encode("utf-8")[:72], hashed.encode("ascii"))
        except (ValueError, TypeError):
            return False
    return False


def password_needs_rehash(hashed: str | None) -> bool:
    """True si el hash no es Argon2 o quedó con parámetros viejos (rehashear al login)."""
    if not hashed:
        return False
    if not hashed.startswith("$argon2"):
        return True
    try:
        return _ph.check_needs_rehash(hashed)
    except InvalidHashError:
        return True


# --- Tokens opacos (refresh / reset): se guarda solo el hash ---
def generate_opaque_token() -> str:
    return secrets.token_urlsafe(48)


def hash_token(token: str) -> str:
    return hashlib.sha256(token.encode("utf-8")).hexdigest()


# --- JWT de acceso ---
def create_access_token(subject: str | int, extra: dict | None = None,
                        minutes: int | None = None) -> str:
    now = datetime.now(timezone.utc)
    payload = {
        "sub": str(subject),
        "iat": now,
        "exp": now + timedelta(minutes=minutes or settings.ACCESS_TOKEN_MINUTES),
        "type": "access",
    }
    if extra:
        payload.update(extra)
    return jwt.encode(payload, settings.SECRET_KEY, algorithm=settings.JWT_ALGORITHM)


def decode_token(token: str) -> dict | None:
    try:
        return jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.JWT_ALGORITHM])
    except jwt.PyJWTError:
        return None


def refresh_expiry() -> datetime:
    return datetime.now(timezone.utc) + timedelta(days=settings.REFRESH_TOKEN_DAYS)
