#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
MIAMI_IMPORT — Tienda pública (FastAPI + Jinja2), independiente de Tiendanube.

Lee el catálogo de la base de datos PROPIA (la misma que administra panel-control)
y renderiza el theme portado a Jinja2, conservando el diseño Champagne Noir.

Uso:
    python app.py
Abrir: http://localhost:8001
"""
from __future__ import annotations

import secrets
from decimal import Decimal
from pathlib import Path

import uvicorn
from fastapi import Cookie, Depends, FastAPI, HTTPException, Request
from fastapi.responses import HTMLResponse, PlainTextResponse, RedirectResponse, Response
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from sqlalchemy.orm import Session

from auth_store import account_router, oauth_router
from cart import cart_router, cart_summary, get_or_create_cart, resolve_cart
from checkout import checkout_router
from core.config import settings
from core.db import get_db, init_db
from core.models import Category, Order, Product, User
from core.web_security import install_security
from deps import current_user

HERE = Path(__file__).resolve().parent

# Los docs de FastAPI enumeran todos los endpoints y esquemas: en producción es
# un mapa gratis para el atacante.
app = FastAPI(
    title="MIAMI_IMPORT Tienda", version="2.0",
    docs_url="/docs" if settings.DEV_MODE else None,
    redoc_url="/redoc" if settings.DEV_MODE else None,
    openapi_url="/openapi.json" if settings.DEV_MODE else None,
)

# Jinja busca en templates_jinja/ y también en snipplets/ (para incluir miami-styles.tpl)
templates = Jinja2Templates(directory=[str(HERE / "templates_jinja"), str(HERE / "snipplets")])
templates.env.globals["USD_RATE"] = settings.USD_TO_ARS_RATE
templates.env.globals["STORE_NAME"] = "MIAMI IMPORT"


# --------------------------------------------------------------------------- #
# Helpers de presentación
# --------------------------------------------------------------------------- #
def fmt_ars(value) -> str:
    if value is None:
        return ""
    n = int(Decimal(str(value)))
    return f"$ {n:,.0f}".replace(",", ".")


def fmt_usd(value) -> str:
    if value is None:
        return ""
    return f"US$ {int(Decimal(str(value))):,}".replace(",", ".")


templates.env.filters["ars"] = fmt_ars
templates.env.filters["usd"] = fmt_usd
# Filtro del theme original: 'images/x.webp' | static_url -> /static/images/x.webp
# Permite incluir los snipplets .tpl (miami-trilogy, etc.) casi sin tocarlos.
templates.env.filters["static_url"] = lambda p: f"/static/{p}"
templates.env.filters["has_custom_image"] = lambda p: False
templates.env.globals["store"] = {"products_url": "/productos"}


def nav_categories(db: Session) -> list[Category]:
    """Categorías de primer nivel (marcas) con sus subcategorías, para el menú."""
    return (
        db.query(Category)
        .filter(Category.parent_id.is_(None))
        .order_by(Category.name)
        .all()
    )


def base_context(request: Request, db: Session, **extra) -> dict:
    ctx = {
        "request": request,
        "nav_categories": nav_categories(db),
        "usd_rate": settings.USD_TO_ARS_RATE,
        # Nonce de la CSP: cada <script> inline lo cita. Sin esto los scripts
        # de las plantillas no se ejecutan (script-src ya no lleva
        # 'unsafe-inline', que es lo que hacía inútil a la CSP frente a XSS).
        "csp_nonce": getattr(request.state, "csp_nonce", ""),
    }
    ctx.update(extra)
    return ctx


# --------------------------------------------------------------------------- #
# Startup
# --------------------------------------------------------------------------- #
# CSP de la TIENDA: permite scripts/estilos inline. El tema (portado de
# TiendaNube) tiene <script> y handlers on* inline por todos lados —el 3D, las
# animaciones, el carrito— y sin 'unsafe-inline' el navegador los bloquea.
# El riesgo de XSS acá está tapado en la capa correcta: el único campo con HTML
# enriquecido (product.description) se sanitiza en el backend, así que ni con
# inline permitido puede inyectarse un <script>. El PANEL sí queda con CSP
# estricta (no tiene inline y es la superficie sensible).
install_security(
    app,
    csp_extra={"script-src": "'unsafe-inline' https://bot-miami.onrender.com",
               "style-src": "'unsafe-inline'",
               "img-src": "https://miamiimport.com.ar",
               "connect-src": "https://bot-miami.onrender.com https://miamiimport.com.ar"},
    use_nonce=False,
    # El webhook también se limita. La firma ya rechaza los eventos falsos, así
    # que esto es solo contra inundación; si Stripe llegara a comerse un 429,
    # reintenga la entrega, no se pierde el evento.
    sensitive_prefixes=("/api/account/login", "/api/account/register",
                        "/api/account/password", "/api/checkout",
                        "/api/stripe/webhook"),
)

app.include_router(cart_router)
app.include_router(account_router)
app.include_router(oauth_router)
app.include_router(checkout_router)


@app.on_event("startup")
def _startup() -> None:
    init_db()


# --------------------------------------------------------------------------- #
# Rutas públicas
# --------------------------------------------------------------------------- #
@app.get("/health")
def health():
    return {"ok": True, "service": "web-tienda"}


@app.get("/", response_class=HTMLResponse)
def home(request: Request, db: Session = Depends(get_db)):
    destacados = (
        db.query(Product)
        .filter(Product.published.is_(True))
        .order_by(Product.id.desc())
        .limit(12)
        .all()
    )
    marcas = nav_categories(db)
    sections = {"primary": {"products": destacados}}
    return templates.TemplateResponse(
        request, "home.html",
        base_context(request, db, destacados=destacados, marcas=marcas,
                     sections=sections, template_class="home"),
    )


@app.get("/productos/{handle}/", response_class=HTMLResponse)
@app.get("/productos/{handle}", response_class=HTMLResponse)
def product_detail(handle: str, request: Request, db: Session = Depends(get_db)):
    prod = db.query(Product).filter(Product.handle == handle).one_or_none()
    if not prod or not prod.published:
        raise HTTPException(404, "Producto no encontrado")
    relacionados = (
        db.query(Product)
        .filter(Product.brand == prod.brand, Product.id != prod.id,
                Product.published.is_(True))
        .limit(4)
        .all()
    )
    return templates.TemplateResponse(
        request, "product.html",
        base_context(request, db, product=prod, relacionados=relacionados,
                     template_class="product"),
    )


@app.get("/productos", response_class=HTMLResponse)
def product_list(request: Request, db: Session = Depends(get_db)):
    productos = (
        db.query(Product).filter(Product.published.is_(True))
        .order_by(Product.id.desc()).all()
    )
    return templates.TemplateResponse(
        request, "category.html",
        base_context(request, db, categoria=None, productos=productos,
                     catalog_title="Catálogo completo", template_class="category"),
    )


@app.get("/categoria/{handle}", response_class=HTMLResponse)
@app.get("/categorias/{handle}", response_class=HTMLResponse)
def category_page(handle: str, request: Request, db: Session = Depends(get_db)):
    cat = db.query(Category).filter(Category.handle == handle).one_or_none()
    if not cat:
        raise HTTPException(404, "Categoría no encontrada")
    # productos de la categoría y de sus subcategorías
    cat_ids = [cat.id] + [c.id for c in cat.subcategories]
    productos = (
        db.query(Product)
        .filter(Product.published.is_(True))
        .filter(Product.categories.any(Category.id.in_(cat_ids)))
        .order_by(Product.id.desc())
        .all()
    )
    return templates.TemplateResponse(
        request, "category.html",
        base_context(request, db, categoria=cat, productos=productos,
                     template_class="category"),
    )


@app.get("/buscar", response_class=HTMLResponse)
def search(request: Request, q: str = "", db: Session = Depends(get_db)):
    productos = []
    if q.strip():
        like = f"%{q.lower()}%"
        from sqlalchemy import func, or_
        productos = (
            db.query(Product)
            .filter(Product.published.is_(True))
            .filter(or_(func.lower(Product.name).like(like),
                        func.lower(Product.brand).like(like)))
            .order_by(Product.id.desc())
            .all()
        )
    return templates.TemplateResponse(
        request, "category.html",
        base_context(request, db, categoria=None, productos=productos,
                     search_query=q, template_class="search"),
    )


@app.get("/carrito", response_class=HTMLResponse)
def cart_page(request: Request, db: Session = Depends(get_db),
              user: User | None = Depends(current_user),
              mi_cart: str | None = Cookie(default=None)):
    cart = resolve_cart(db, None, user, mi_cart, create=False)
    return templates.TemplateResponse(
        request, "cart.html",
        base_context(request, db, cart=cart_summary(cart), template_class="cart"),
    )


@app.get("/checkout", response_class=HTMLResponse)
def checkout_page(request: Request, db: Session = Depends(get_db),
                  user: User | None = Depends(current_user),
                  mi_cart: str | None = Cookie(default=None)):
    # Misma resolución que usa create-intent: la pantalla tiene que mostrar
    # exactamente el carrito que se va a cobrar.
    cart = resolve_cart(db, None, user, mi_cart, create=False)
    summary = cart_summary(cart)
    return templates.TemplateResponse(
        request, "checkout.html",
        base_context(request, db, cart=summary, account=user,
                     stripe_enabled=bool(settings.STRIPE_PUBLISHABLE_KEY),
                     addresses=(user.addresses if user else []),
                     template_class="checkout"),
    )


@app.get("/pedido/{number}", response_class=HTMLResponse)
def order_confirmation(number: int, request: Request, t: str = "",
                       db: Session = Depends(get_db),
                       user: User | None = Depends(current_user)):
    """Confirmación de pedido.

    Los números son secuenciales, así que sin control de acceso se podía
    recorrer /pedido/1000..N y llevarse el registro completo de ventas. Se
    exige ser el dueño (sesión) o presentar el token opaco de la orden.
    Siempre 404 —nunca 403— para no confirmar qué números existen.
    """
    order = db.query(Order).filter(Order.number == number).one_or_none()
    if not order:
        raise HTTPException(404, "Pedido no encontrado")

    is_owner = bool(user and order.user_id and order.user_id == user.id)
    has_token = bool(t and order.public_token
                     and secrets.compare_digest(t, order.public_token))
    if not (is_owner or has_token):
        raise HTTPException(404, "Pedido no encontrado")

    return templates.TemplateResponse(
        request, "order_confirmation.html",
        base_context(request, db, order=order, template_class="order"),
    )


@app.get("/cuenta/ingresar", response_class=HTMLResponse)
def account_login_page(request: Request, db: Session = Depends(get_db),
                       user: User | None = Depends(current_user)):
    if user:
        return RedirectResponse("/cuenta", status_code=302)
    return templates.TemplateResponse(
        request, "account_login.html",
        base_context(request, db, google_enabled=bool(settings.GOOGLE_CLIENT_ID),
                     template_class="account-login"),
    )


@app.get("/cuenta/reset", response_class=HTMLResponse)
def account_reset_page(request: Request, token: str = "", db: Session = Depends(get_db)):
    return templates.TemplateResponse(
        request, "account_reset.html",
        base_context(request, db, reset_token=token, template_class="account-reset"),
    )


@app.get("/cuenta", response_class=HTMLResponse)
def account_page(request: Request, db: Session = Depends(get_db),
                 user: User | None = Depends(current_user)):
    if not user:
        return RedirectResponse("/cuenta/ingresar", status_code=302)
    orders = (
        db.query(Order).filter(Order.user_id == user.id)
        .order_by(Order.created_at.desc()).all()
    )
    return templates.TemplateResponse(
        request, "account.html",
        base_context(request, db, account=user, orders=orders,
                     addresses=user.addresses, template_class="account"),
    )


@app.get("/robots.txt", response_class=PlainTextResponse)
def robots():
    return (
        "User-agent: *\n"
        "Allow: /\n"
        "Disallow: /cuenta\n"
        "Disallow: /carrito\n"
        "Disallow: /checkout\n"
        "Disallow: /api/\n"
        f"Sitemap: {settings.STORE_BASE_URL}/sitemap.xml\n"
    )


@app.get("/sitemap.xml")
def sitemap(db: Session = Depends(get_db)):
    base = settings.STORE_BASE_URL.rstrip("/")
    urls = [f"{base}/", f"{base}/productos"]
    for c in db.query(Category).all():
        urls.append(f"{base}/categorias/{c.handle}")
    for p in db.query(Product).filter(Product.published.is_(True)).all():
        urls.append(f"{base}/productos/{p.handle}/")
    body = "".join(f"<url><loc>{u}</loc></url>" for u in urls)
    xml = ('<?xml version="1.0" encoding="UTF-8"?>'
           '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
           f"{body}</urlset>")
    return Response(content=xml, media_type="application/xml")


app.mount("/static", StaticFiles(directory=HERE / "static"), name="static")


if __name__ == "__main__":
    print("\n 🛍  MIAMI_IMPORT — Tienda pública")
    print(f"    DB: {settings.DATABASE_URL}")
    print(" Abriendo en: http://localhost:8001\n")
    uvicorn.run("app:app", host="0.0.0.0", port=8001, reload=False, server_header=False)
