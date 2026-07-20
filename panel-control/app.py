#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Stock Manager Miami Import — Backend FastAPI (plataforma propia).

Ya NO es un proxy a Tiendanube: sirve la webapp del panel y expone una API
respaldada por NUESTRA base de datos (ver panel_api.py + core/). Conserva las
utilidades locales (plantillas de WhatsApp, config del bot, páginas legales,
backup de fotos a Drive, redeploy).

Uso:
    python app.py
Abrir: http://localhost:8000
"""
from __future__ import annotations

import json
import os
from pathlib import Path
from typing import Any

import uvicorn
from fastapi import APIRouter, Depends, FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse, RedirectResponse
from fastapi.staticfiles import StaticFiles

from auth import auth_router, ensure_admin, get_current_admin, is_admin_request
from core.config import settings
from core.db import init_db
from core.web_security import install_security
from panel_api import router as panel_router

HERE = Path(__file__).resolve().parent

# Backup de fotos a Drive (opcional, no rompe si falta config)
try:
    import drive_helper
    drive_helper.init()
    _HAS_DRIVE = True
except Exception as e:  # noqa: BLE001
    print(f"[drive] backup desactivado: {e}")
    _HAS_DRIVE = False


# --------------------------------------------------------------------------- #
# App
# --------------------------------------------------------------------------- #
app = FastAPI(
    title="Stock Manager Miami Import", version="2.0",
    docs_url="/docs" if settings.DEV_MODE else None,
    redoc_url="/redoc" if settings.DEV_MODE else None,
    openapi_url="/openapi.json" if settings.DEV_MODE else None,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


install_security(app, sensitive_prefixes=("/api/auth/login",), rate_limit=20)

# Todas las utilidades locales cuelgan de acá: la dependencia de admin se
# aplica a nivel de router. Declarar rutas /api sueltas sobre `app` las dejaba
# SIN autenticación (así quedaron expuestos bot_config, redeploy_bot y demás).
admin_api = APIRouter(prefix="/api", dependencies=[Depends(get_current_admin)])


@app.on_event("startup")
def _startup() -> None:
    init_db()
    ensure_admin()


app.include_router(auth_router)
app.include_router(panel_router)


def _is_authed(request: Request) -> bool:
    """¿Esta request trae una sesión de ADMIN válida?

    Antes solo miraba que el JWT fuera de tipo `access`, sin verificar
    is_admin: cualquier cliente de la tienda podía pegar su token en la cookie
    `mi_admin` y entrar a la UI del panel.
    """
    return is_admin_request(request)


@app.get("/")
def root(request: Request):
    if not _is_authed(request):
        return RedirectResponse("/login", status_code=302)
    return FileResponse(HERE / "static" / "index.html")


@app.get("/login")
def login_page(request: Request):
    if _is_authed(request):
        return RedirectResponse("/", status_code=302)
    return FileResponse(HERE / "static" / "login.html")


@app.get("/api/health")
def health():
    return {"ok": True, "service": "panel-control", "db": settings.DATABASE_URL.split("://")[0]}


# --------------------------------------------------------------------------- #
# Utilidades locales (persistencia en data/*.json)
# --------------------------------------------------------------------------- #
DATA_DIR = HERE / "data"
DATA_DIR.mkdir(exist_ok=True)

WA_TEMPLATES_FILE = DATA_DIR / "whatsapp_templates.json"
BOT_CONFIG_FILE = DATA_DIR / "bot_config.json"

LEGAL_PAGES_DIR = Path(os.environ.get(
    "LEGAL_PAGES_DIR",
    str(HERE / ".." / "Miami Import" / "Stock mIAmimport_-20260422T165214Z-3-001"
        / "Stock mIAmimport_" / "PEGAR_EN_ADMIN" / "6-paginas_legales"),
)).resolve()

DEFAULT_WA_TEMPLATES: dict[str, str] = {
    "coordinar_caba": (
        "Hola {name}! 👋 Te confirmo que recibimos tu pago del pedido #{order}.\n\n"
        "Hago entrega personal en CABA + GBA cercano. ¿En qué barrio estás? "
        "Te paso el costo del envío y coordinamos día/horario."
    ),
    "salida_camino": (
        "Hola {name}, salí en camino con tu pedido #{order} 🛵\n"
        "Llegada estimada: {eta}.\nCualquier cosa avisame por acá."
    ),
    "entregado": (
        "Listo {name}, entregado! 🤝\n\n"
        "Tenés 48hs hábiles para cambio de talle si hace falta. Estoy por acá."
    ),
    "post_venta": (
        "Hola {name}! Pasaron unos días desde la entrega del pedido #{order}. "
        "¿Cómo te quedó? Si te tira otra marca/talle, contame — siempre tenemos drops nuevos. 🖤"
    ),
    "tracking_correo": (
        "Hola {name}, despachamos tu pedido #{order} 📦\n\n"
        "Operador: {carrier}\nTracking: {tracking}\nPlazo estimado: {eta}"
    ),
}


def load_json(path: Path, default: Any) -> Any:
    if not path.exists():
        return default
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except Exception as e:  # noqa: BLE001
        print(f"[load_json] {path.name}: {e} -> usando default")
        return default


def save_json(path: Path, data: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, indent=2, ensure_ascii=False), encoding="utf-8")


# ---- WhatsApp templates ----
@admin_api.get("/whatsapp_templates")
def wa_templates_get():
    tpls = load_json(WA_TEMPLATES_FILE, {})
    for k, v in DEFAULT_WA_TEMPLATES.items():
        tpls.setdefault(k, v)
    return tpls


@admin_api.post("/whatsapp_templates")
def wa_templates_save(body: dict):
    save_json(WA_TEMPLATES_FILE, {str(k): str(v) for k, v in (body or {}).items()})
    return {"ok": True}


# ---- Bot config ----
@admin_api.get("/bot_config")
def bot_config_get():
    cfg = load_json(BOT_CONFIG_FILE, {})
    cfg.setdefault("shipping_info", "")
    cfg.setdefault("payment_info", "")
    cfg.setdefault("exchange_info", "")
    cfg.setdefault("usd_rate", settings.USD_TO_ARS_RATE)
    return cfg


@admin_api.post("/bot_config")
def bot_config_save(body: dict):
    cfg = load_json(BOT_CONFIG_FILE, {})
    for key in ("shipping_info", "payment_info", "exchange_info"):
        if key in body:
            cfg[key] = str(body[key])
    if "usd_rate" in body:
        try:
            cfg["usd_rate"] = float(body["usd_rate"])
        except (TypeError, ValueError):
            raise HTTPException(400, "usd_rate inválido")
    save_json(BOT_CONFIG_FILE, cfg)
    return {"ok": True, "saved": cfg}


# ---- Páginas legales ----
@admin_api.get("/legal_pages")
def legal_pages_list():
    if not LEGAL_PAGES_DIR.exists():
        return {"available": False, "dir": str(LEGAL_PAGES_DIR), "pages": []}
    pages = [{"name": f.stem, "filename": f.name, "size": f.stat().st_size}
             for f in sorted(LEGAL_PAGES_DIR.glob("*.html"))]
    return {"available": True, "dir": str(LEGAL_PAGES_DIR), "pages": pages}


@admin_api.get("/legal_pages/{name}")
def legal_page_get(name: str):
    import re
    safe = re.sub(r"[^a-z0-9_-]", "", name.lower())
    if not safe:
        raise HTTPException(400, "name inválido")
    f = LEGAL_PAGES_DIR / f"{safe}.html"
    if not f.exists():
        raise HTTPException(404, f"No existe {f.name}")
    return {"name": safe, "filename": f.name, "html": f.read_text(encoding="utf-8")}


# ---- Backup status ----
@admin_api.get("/backup/status")
def backup_status():
    if not _HAS_DRIVE:
        return {"enabled": False, "reason": "drive_helper no disponible"}
    return drive_helper.status()


# ---- Acciones rápidas ----
@admin_api.post("/actions/redeploy_bot")
def action_redeploy_bot():
    import requests
    hook = os.environ.get("RENDER_DEPLOY_HOOK", "")
    if not hook:
        return {"ok": False, "error": "RENDER_DEPLOY_HOOK no configurado."}
    try:
        r = requests.post(hook, timeout=10)
        return {"ok": r.status_code < 400, "status": r.status_code}
    except Exception as e:  # noqa: BLE001
        return {"ok": False, "error": str(e)}


# --------------------------------------------------------------------------- #
# Estáticos
# --------------------------------------------------------------------------- #
app.include_router(admin_api)

app.mount("/static", StaticFiles(directory=HERE / "static"), name="static")


if __name__ == "__main__":
    print()
    print(" >> Stock Manager Miami Import (plataforma propia)")
    print(f"    DB          : {settings.DATABASE_URL}")
    if _HAS_DRIVE:
        dst = drive_helper.status()
        print(f"    Backup fotos: {'ON -> ' + dst.get('backup_path', '') if dst.get('enabled') else 'OFF'}")
    print()
    print(" Abriendo en: http://localhost:8000")
    print(" Ctrl+C para detener.")
    print()
    uvicorn.run("app:app", host="0.0.0.0", port=8000, reload=False, server_header=False)
