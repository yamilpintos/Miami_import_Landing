"""
Carrito persistente de la tienda.

- Carrito anónimo identificado por cookie `mi_cart` (token opaco) -> fila Cart.
- Al loguearse, el carrito anónimo se fusiona con el del usuario (ver auth/merge).
- Valida stock en el backend (nada de confiar en el front).
- Devuelve siempre un resumen JSON consistente para que el front re-renderice.
"""
from __future__ import annotations

import secrets
from decimal import Decimal

from fastapi import APIRouter, Cookie, Depends, HTTPException, Response
from sqlalchemy.orm import Session

from core.config import settings
from core.db import get_db
from core.models import Cart, CartItem, Variant

COOKIE_NAME = "mi_cart"
cart_router = APIRouter(prefix="/api/cart", tags=["cart"])


# --------------------------------------------------------------------------- #
# Resolución del carrito
# --------------------------------------------------------------------------- #
def get_or_create_cart(db: Session, response: Response | None,
                       token: str | None, create: bool = True) -> Cart | None:
    cart = None
    if token:
        cart = db.query(Cart).filter(Cart.token == token).one_or_none()
    if cart or not create:
        return cart
    new_token = secrets.token_urlsafe(24)
    cart = Cart(token=new_token, currency="ARS")
    db.add(cart)
    db.flush()
    if response is not None:
        response.set_cookie(
            COOKIE_NAME, new_token, httponly=True, samesite="lax",
            secure=settings.COOKIE_SECURE, max_age=60 * 60 * 24 * 90,
            domain=settings.COOKIE_DOMAIN, path="/",
        )
    return cart


def cart_summary(cart: Cart | None) -> dict:
    if not cart:
        return {"items": [], "count": 0, "subtotal": "0.00", "subtotal_raw": 0.0}
    items = []
    subtotal = Decimal("0")
    count = 0
    for it in cart.items:
        v = it.variant
        if not v:
            continue
        line = (it.unit_price or Decimal("0")) * it.quantity
        subtotal += line
        count += it.quantity
        prod = v.product
        img = prod.images[0].url if (prod and prod.images) else "/static/images/empty-placeholder.png"
        items.append({
            "variant_id": v.id,
            "product_id": prod.id if prod else None,
            "handle": prod.handle if prod else None,
            "product_name": prod.name if prod else "",
            "brand": prod.brand if prod else "",
            "value": v.value,
            "sku": v.sku,
            "quantity": it.quantity,
            "stock": v.stock,
            "unit_price": f"{it.unit_price:.2f}",
            "line_total": f"{line:.2f}",
            "image": img,
        })
    return {
        "items": items,
        "count": count,
        "subtotal": f"{subtotal:.2f}",
        "subtotal_raw": float(subtotal),
    }


# --------------------------------------------------------------------------- #
# Endpoints
# --------------------------------------------------------------------------- #
def merge_anonymous_cart_into_user(db: Session, user_id: int, anon_token: str | None) -> None:
    """Al loguearse: fusiona el carrito anónimo (cookie) con el del usuario.
    Suma cantidades (capadas al stock) y deja un único carrito por usuario."""
    user_cart = db.query(Cart).filter(Cart.user_id == user_id).order_by(Cart.id).first()
    anon_cart = (
        db.query(Cart).filter(Cart.token == anon_token).one_or_none() if anon_token else None
    )
    if anon_cart and anon_cart.user_id and anon_cart.user_id != user_id:
        anon_cart = None  # el carrito de la cookie ya es de otro usuario; no tocar

    if not user_cart:
        # El usuario no tenía carrito: adoptamos el anónimo (si hay) o creamos uno.
        if anon_cart:
            anon_cart.user_id = user_id
            db.commit()
        return

    if not anon_cart or anon_cart.id == user_cart.id:
        return

    for it in list(anon_cart.items):
        existing = db.query(CartItem).filter_by(cart_id=user_cart.id, variant_id=it.variant_id).one_or_none()
        stock = it.variant.stock if it.variant else 0
        if existing:
            existing.quantity = min(existing.quantity + it.quantity, stock)
        else:
            db.add(CartItem(cart_id=user_cart.id, variant_id=it.variant_id,
                            quantity=min(it.quantity, stock), unit_price=it.unit_price))
    db.delete(anon_cart)
    db.commit()


@cart_router.get("")
def get_cart(db: Session = Depends(get_db), mi_cart: str | None = Cookie(default=None)):
    cart = get_or_create_cart(db, None, mi_cart, create=False)
    return cart_summary(cart)


@cart_router.post("/add")
def add_to_cart(body: dict, response: Response, db: Session = Depends(get_db),
                mi_cart: str | None = Cookie(default=None)):
    variant_id = body.get("variant_id")
    qty = max(1, int(body.get("quantity", 1)))
    v = db.get(Variant, int(variant_id)) if variant_id else None
    if not v or not v.visible:
        raise HTTPException(404, "Variante no encontrada")
    if v.stock <= 0:
        raise HTTPException(409, "Sin stock disponible")

    cart = get_or_create_cart(db, response, mi_cart)
    item = db.query(CartItem).filter_by(cart_id=cart.id, variant_id=v.id).one_or_none()
    current = item.quantity if item else 0
    new_qty = min(current + qty, v.stock)  # nunca por encima del stock
    if item:
        item.quantity = new_qty
        item.unit_price = v.price or Decimal("0")
    else:
        db.add(CartItem(cart_id=cart.id, variant_id=v.id, quantity=new_qty,
                        unit_price=v.price or Decimal("0")))
    db.commit()
    db.refresh(cart)
    return cart_summary(cart)


@cart_router.post("/update")
def update_cart(body: dict, db: Session = Depends(get_db),
                mi_cart: str | None = Cookie(default=None)):
    cart = get_or_create_cart(db, None, mi_cart, create=False)
    if not cart:
        raise HTTPException(404, "Carrito vacío")
    variant_id = int(body.get("variant_id"))
    qty = int(body.get("quantity", 1))
    item = db.query(CartItem).filter_by(cart_id=cart.id, variant_id=variant_id).one_or_none()
    if not item:
        raise HTTPException(404, "Ítem no está en el carrito")
    if qty <= 0:
        db.delete(item)
    else:
        item.quantity = min(qty, item.variant.stock)
    db.commit()
    db.refresh(cart)
    return cart_summary(cart)


@cart_router.post("/remove")
def remove_from_cart(body: dict, db: Session = Depends(get_db),
                     mi_cart: str | None = Cookie(default=None)):
    cart = get_or_create_cart(db, None, mi_cart, create=False)
    if not cart:
        return cart_summary(None)
    variant_id = int(body.get("variant_id"))
    item = db.query(CartItem).filter_by(cart_id=cart.id, variant_id=variant_id).one_or_none()
    if item:
        db.delete(item)
        db.commit()
        db.refresh(cart)
    return cart_summary(cart)
