"""
Configuración central leída del entorno (.env local o variables de Render).

Nunca hardcodear credenciales. Todo sale de variables de entorno; los valores
por defecto son seguros para desarrollo local.
"""
from __future__ import annotations

import os
from functools import lru_cache
from pathlib import Path

HERE = Path(__file__).resolve().parent
PANEL_ROOT = HERE.parent


def _load_dotenv() -> None:
    """Carga panel-control/.env al entorno del proceso (sin pisar lo ya seteado)."""
    env_file = PANEL_ROOT / ".env"
    if not env_file.exists():
        return
    for line in env_file.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        k, _, v = line.partition("=")
        os.environ.setdefault(k.strip(), v.strip())


_load_dotenv()


def _bool(name: str, default: bool = False) -> bool:
    return os.environ.get(name, str(default)).strip().lower() in ("1", "true", "yes", "on")


def _normalize_db_url(url: str) -> str:
    """Render/Heroku entregan postgres://; SQLAlchemy 2.x necesita postgresql+psycopg2://.
    Además forzamos TLS en tránsito (sslmode=require) si no se especificó."""
    if url.startswith("postgres://"):
        url = url.replace("postgres://", "postgresql+psycopg2://", 1)
    elif url.startswith("postgresql://"):
        url = url.replace("postgresql://", "postgresql+psycopg2://", 1)
    if url.startswith("postgresql+psycopg2://") and "sslmode=" not in url:
        url += ("&" if "?" in url else "?") + "sslmode=require"
    return url


class Settings:
    # --- Base de datos ---
    # Local por defecto: SQLite compartido en la raíz del proyecto, así panel y
    # tienda apuntan al MISMO archivo. En Render se usa DATABASE_URL (Postgres).
    _default_sqlite = f"sqlite:///{(PANEL_ROOT.parent / 'miami_import.db').as_posix()}"
    DATABASE_URL: str = _normalize_db_url(os.environ.get("DATABASE_URL", _default_sqlite))

    # --- Seguridad / JWT ---
    SECRET_KEY: str = os.environ.get("SECRET_KEY", "dev-insecure-change-me")
    JWT_ALGORITHM: str = os.environ.get("JWT_ALGORITHM", "HS256")
    ACCESS_TOKEN_MINUTES: int = int(os.environ.get("ACCESS_TOKEN_MINUTES", "30"))
    REFRESH_TOKEN_DAYS: int = int(os.environ.get("REFRESH_TOKEN_DAYS", "30"))
    COOKIE_SECURE: bool = _bool("COOKIE_SECURE", default=not _bool("DEV_MODE", True))
    COOKIE_DOMAIN: str | None = os.environ.get("COOKIE_DOMAIN") or None

    # --- Tienda Nube (solo para migrar / refrescar datos) ---
    TIENDANUBE_STORE_ID: str = os.environ.get("TIENDANUBE_STORE_ID", "")
    TIENDANUBE_ACCESS_TOKEN: str = os.environ.get("TIENDANUBE_ACCESS_TOKEN", "")
    TIENDANUBE_USER_AGENT: str = os.environ.get("TIENDANUBE_USER_AGENT", "MiamiImport StockManager")

    # --- Precios ---
    USD_TO_ARS_RATE: float = float(os.environ.get("USD_TO_ARS_RATE", "1410") or "1410")

    # --- Stripe ---
    STRIPE_SECRET_KEY: str = os.environ.get("STRIPE_SECRET_KEY", "")
    STRIPE_PUBLISHABLE_KEY: str = os.environ.get("STRIPE_PUBLISHABLE_KEY", "")
    STRIPE_WEBHOOK_SECRET: str = os.environ.get("STRIPE_WEBHOOK_SECRET", "")
    CHECKOUT_CURRENCY: str = os.environ.get("CHECKOUT_CURRENCY", "ars").lower()

    # --- Google OAuth ---
    GOOGLE_CLIENT_ID: str = os.environ.get("GOOGLE_CLIENT_ID", "")
    GOOGLE_CLIENT_SECRET: str = os.environ.get("GOOGLE_CLIENT_SECRET", "")

    # --- Supabase Storage (imágenes de productos) ---
    SUPABASE_URL: str = os.environ.get("SUPABASE_URL", "").rstrip("/")
    SUPABASE_SECRET_KEY: str = os.environ.get("SUPABASE_SECRET_KEY", "")
    SUPABASE_BUCKET: str = os.environ.get("SUPABASE_BUCKET", "productos")

    @property
    def storage_enabled(self) -> bool:
        return bool(self.SUPABASE_URL and self.SUPABASE_SECRET_KEY)

    # --- URLs públicas (para CORS, OAuth callbacks, links de Stripe) ---
    STORE_BASE_URL: str = os.environ.get("STORE_BASE_URL", "http://localhost:8001")
    PANEL_BASE_URL: str = os.environ.get("PANEL_BASE_URL", "http://localhost:8000")

    # --- Admin inicial (se crea si no existe ningún admin) ---
    ADMIN_EMAIL: str = os.environ.get("ADMIN_EMAIL", "yamilpintos18@gmail.com")
    ADMIN_PASSWORD: str = os.environ.get("ADMIN_PASSWORD", "")  # vacío => no autocrea

    DEV_MODE: bool = _bool("DEV_MODE", default=True)

    @property
    def cors_origins(self) -> list[str]:
        raw = os.environ.get("CORS_ORIGINS", "")
        if raw:
            return [o.strip() for o in raw.split(",") if o.strip()]
        return [self.STORE_BASE_URL, self.PANEL_BASE_URL]


@lru_cache
def get_settings() -> Settings:
    return Settings()


settings = get_settings()
