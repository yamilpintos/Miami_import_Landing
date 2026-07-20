"""
Blindaje web compartido: cabeceras de seguridad + rate limiting básico.

Pensado para producción pero sin dependencias externas (Redis, slowapi):
el rate limiter es en memoria por proceso — suficiente para 1 instancia en
Render. Si se escala a varias instancias, migrar a Redis.
"""
from __future__ import annotations

import time
from collections import defaultdict, deque

from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
from starlette.responses import JSONResponse, Response

from .config import settings

# --------------------------------------------------------------------------- #
# Bloqueo de cuenta tras intentos fallidos (anti brute-force / credential stuffing)
# En memoria por proceso; para multi-instancia migrar a Redis.
# --------------------------------------------------------------------------- #
_LOCKOUT_THRESHOLD = 5          # intentos fallidos
_LOCKOUT_WINDOW = 15 * 60       # se cuentan dentro de 15 min
_LOCKOUT_TIME = 15 * 60         # bloqueo de 15 min
_failed: dict[str, deque] = defaultdict(deque)
_locked_until: dict[str, float] = {}


def is_locked(key: str) -> int:
    """Devuelve segundos restantes de bloqueo, o 0 si no está bloqueado."""
    until = _locked_until.get(key, 0)
    rem = int(until - time.time())
    return rem if rem > 0 else 0


def record_failure(key: str) -> None:
    now = time.time()
    q = _failed[key]
    q.append(now)
    while q and now - q[0] > _LOCKOUT_WINDOW:
        q.popleft()
    if len(q) >= _LOCKOUT_THRESHOLD:
        _locked_until[key] = now + _LOCKOUT_TIME
        q.clear()


def clear_failures(key: str) -> None:
    _failed.pop(key, None)
    _locked_until.pop(key, None)

# Hosts permitidos por la tienda (CDNs de animación, Stripe, fuentes, imágenes TN, bot).
_DEFAULT_CSP = {
    "default-src": "'self'",
    "script-src": "'self' 'unsafe-inline' https://cdn.jsdelivr.net https://js.stripe.com https://ajax.googleapis.com",
    "style-src": "'self' 'unsafe-inline' https://fonts.googleapis.com",
    "img-src": "'self' data: https:",
    "font-src": "'self' https://fonts.gstatic.com data:",
    "connect-src": "'self' https://api.stripe.com",
    "frame-src": "https://js.stripe.com https://hooks.stripe.com",
    "frame-ancestors": "'self'",
    "base-uri": "'self'",
    "form-action": "'self'",
}


def _csp_string(extra: dict | None = None) -> str:
    policy = dict(_DEFAULT_CSP)
    if extra:
        for k, v in extra.items():
            policy[k] = f"{policy.get(k, '')} {v}".strip()
    return "; ".join(f"{k} {v}" for k, v in policy.items())


class SecurityHeadersMiddleware(BaseHTTPMiddleware):
    def __init__(self, app, csp_extra: dict | None = None):
        super().__init__(app)
        self._csp = _csp_string(csp_extra)

    async def dispatch(self, request: Request, call_next):
        resp: Response = await call_next(request)
        resp.headers.setdefault("X-Content-Type-Options", "nosniff")
        resp.headers.setdefault("X-Frame-Options", "DENY")
        resp.headers.setdefault("Referrer-Policy", "strict-origin-when-cross-origin")
        resp.headers.setdefault("Permissions-Policy",
                                "geolocation=(), microphone=(), camera=(), payment=(self)")
        resp.headers.setdefault("Content-Security-Policy", self._csp)
        resp.headers.setdefault("Cross-Origin-Opener-Policy", "same-origin")
        resp.headers.setdefault("Cross-Origin-Resource-Policy", "same-site")
        # No filtrar la tecnología del stack.
        for h in ("Server", "X-Powered-By"):
            if h in resp.headers:
                del resp.headers[h]
        # Nunca cachear respuestas sensibles (API, auth, cuenta, checkout).
        p = request.url.path
        if p.startswith(("/api/", "/auth/", "/cuenta", "/checkout")):
            resp.headers["Cache-Control"] = "no-store"
        if settings.COOKIE_SECURE and not settings.DEV_MODE:
            resp.headers.setdefault(
                "Strict-Transport-Security",
                "max-age=63072000; includeSubDomains; preload")
        return resp


class RateLimitMiddleware(BaseHTTPMiddleware):
    """Limita ráfagas en endpoints sensibles (login, registro, checkout, etc.)."""

    def __init__(self, app, limit: int = 30, window: int = 60,
                 sensitive_prefixes: tuple[str, ...] = ()):
        super().__init__(app)
        self.limit = limit
        self.window = window
        self.sensitive = sensitive_prefixes
        self._hits: dict[str, deque] = defaultdict(deque)

    async def dispatch(self, request: Request, call_next):
        path = request.url.path
        if request.method == "POST" and any(path.startswith(p) for p in self.sensitive):
            ip = request.client.host if request.client else "?"
            key = f"{ip}:{path}"
            now = time.time()
            q = self._hits[key]
            while q and now - q[0] > self.window:
                q.popleft()
            if len(q) >= self.limit:
                return JSONResponse({"detail": "Demasiados intentos. Probá en un minuto."},
                                    status_code=429)
            q.append(now)
        return await call_next(request)


def install_security(app, *, csp_extra: dict | None = None,
                     rate_limit: int = 30, rate_window: int = 60,
                     sensitive_prefixes: tuple[str, ...] = ()) -> None:
    app.add_middleware(SecurityHeadersMiddleware, csp_extra=csp_extra)
    if sensitive_prefixes:
        app.add_middleware(RateLimitMiddleware, limit=rate_limit, window=rate_window,
                           sensitive_prefixes=sensitive_prefixes)
