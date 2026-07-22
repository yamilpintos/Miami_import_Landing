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


# Qué servicio somos (los dos comparten este archivo, pero no la configuración).
IS_PANEL = PANEL_ROOT.name == "panel-control"


def _load_dotenv() -> None:
    """Carga el .env del servicio al entorno del proceso (sin pisar lo ya seteado).

    Las claves con valor vacío se IGNORAN: un `SECRET_KEY=` en el .env no debe
    pisar el default ni, peor, dejar la clave en "" (era un fail-open grave).
    """
    env_file = PANEL_ROOT / ".env"
    if not env_file.exists():
        return
    for line in env_file.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        k, _, v = line.partition("=")
        k, v = k.strip(), v.strip()
        if not v:
            continue
        os.environ.setdefault(k, v)


_load_dotenv()


def _bool(name: str, default: bool = False) -> bool:
    return os.environ.get(name, str(default)).strip().lower() in ("1", "true", "yes", "on")


_DEV_MODE = _bool("DEV_MODE", default=False)


def _resolve_secret_key() -> str:
    """Clave de firma de los JWT. Obligatoria y fuerte; sin fallback hardcodeado.

    El panel puede (y debe) usar una clave distinta de la tienda: si comparten
    firma, un token de cliente de la tienda sirve como token del panel.
    En producción el proceso NO arranca sin una clave de >=32 caracteres.
    En desarrollo se genera una efímera por proceso (las sesiones no sobreviven
    a un reinicio, que es exactamente lo que queremos en local).
    """
    key = ""
    if IS_PANEL:
        key = os.environ.get("ADMIN_SECRET_KEY", "").strip()
        if not key and os.environ.get("SECRET_KEY", "").strip():
            # Cae a la clave de la tienda: la separación de claim (adm vs cust)
            # sigue impidiendo el cruce, pero se pierde la defensa en
            # profundidad de claves independientes. Avisar fuerte.
            print("[config] [!] ADMIN_SECRET_KEY no seteada: el panel firma con la "
                  "SECRET_KEY de la tienda. Seteá una clave DISTINTA para el panel.")
    key = key or os.environ.get("SECRET_KEY", "").strip()

    if len(key) >= 32:
        return key
    if not _DEV_MODE:
        raise RuntimeError(
            "SECRET_KEY ausente o débil (se requieren >=32 caracteres). "
            "Generá una con: python -c \"import secrets;print(secrets.token_urlsafe(48))\" "
            "y cargala en las variables de entorno. El panel debe usar una clave "
            "DISTINTA de la tienda (ADMIN_SECRET_KEY)."
        )
    import secrets as _secrets
    return _secrets.token_urlsafe(48)


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
    SECRET_KEY: str = _resolve_secret_key()
    JWT_ALGORITHM: str = "HS256"  # fijo: no se negocia por entorno
    ACCESS_TOKEN_MINUTES: int = int(os.environ.get("ACCESS_TOKEN_MINUTES", "30"))
    REFRESH_TOKEN_DAYS: int = int(os.environ.get("REFRESH_TOKEN_DAYS", "30"))
    # Minutos de vida de la sesión (tienda y panel). Cortos: no hay revocación
    # instantánea de JWT más allá de token_version.
    SESSION_MINUTES: int = int(os.environ.get("SESSION_MINUTES", "720"))
    # Ventana del link de recuperación de contraseña.
    RESET_TOKEN_MINUTES: int = int(os.environ.get("RESET_TOKEN_MINUTES", "30"))
    COOKIE_SECURE: bool = _bool("COOKIE_SECURE", default=not _DEV_MODE)
    COOKIE_DOMAIN: str | None = os.environ.get("COOKIE_DOMAIN") or None

    # ¿El panel EXIGE segundo factor para operar?
    # En false, el admin entra solo con contraseña. Si un usuario igual tiene
    # TOTP activado, se le sigue pidiendo al ingresar: apagar esto no desactiva
    # el MFA de quien ya lo configuró, solo deja de hacerlo obligatorio.
    # Poner REQUIRE_MFA=true (recomendado) cuando se termine de configurar.
    REQUIRE_MFA: bool = _bool("REQUIRE_MFA", default=False)

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
    CHECKOUT_CURRENCY: str = os.environ.get("CHECKOUT_CURRENCY", "ars").strip().lower()

    @property
    def currency_minor_units(self) -> int:
        """Multiplicador a la unidad mínima de la moneda, según la tabla de Stripe.

        Las monedas de cero decimales (JPY, CLP, COP...) se cobran en unidades
        enteras: multiplicar por 100 cobraría 100x de más.
        """
        zero_decimal = {
            "bif", "clp", "djf", "gnf", "jpy", "kmf", "krw", "mga",
            "pyg", "rwf", "ugx", "vnd", "vuv", "xaf", "xof", "xpf",
        }
        return 1 if self.CHECKOUT_CURRENCY in zero_decimal else 100

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
    # Sin default: hardcodear el email del owner le regala al atacante el
    # objetivo exacto para fuerza bruta y phishing.
    ADMIN_EMAIL: str = os.environ.get("ADMIN_EMAIL", "")
    ADMIN_PASSWORD: str = os.environ.get("ADMIN_PASSWORD", "")  # vacío => no autocrea

    # Fail-closed: si la variable falta, asumimos PRODUCCIÓN. Un deploy sin
    # DEV_MODE no debe quedar con cookies inseguras ni webhooks sin firma.
    DEV_MODE: bool = _DEV_MODE
    IS_PANEL: bool = IS_PANEL

    @property
    def cors_origins(self) -> list[str]:
        """Orígenes permitidos con credenciales.

        Cada servicio se sirve su propio frontend (same-origin), así que por
        defecto NO se habilita el otro: darle a la tienda pública acceso
        credencializado a la API del panel amplía la superficie sin necesidad.
        """
        raw = os.environ.get("CORS_ORIGINS", "")
        if raw:
            return [o.strip() for o in raw.split(",") if o.strip()]
        return [self.PANEL_BASE_URL] if self.IS_PANEL else [self.STORE_BASE_URL]


@lru_cache
def get_settings() -> Settings:
    return Settings()


settings = get_settings()
