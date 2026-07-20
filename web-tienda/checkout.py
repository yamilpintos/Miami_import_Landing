"""
Checkout con Stripe (Payment Intents) — única pasarela.

Flujo:
  1. POST /api/checkout/create-intent: valida carrito + stock, crea Order (pending)
     + OrderItems (snapshot de precios), crea PaymentIntent y devuelve client_secret.
  2. El front monta el Payment Element con client_secret y confirma el pago.
  3. POST /api/stripe/webhook: Stripe confirma. Al cobrar (payment_intent.succeeded)
     marcamos la orden pagada, descontamos stock y vaciamos el carrito.

Las claves viven SOLO en backend (settings). Si no están configuradas, los
endpoints responden 503 sin romper la tienda.
"""
from __future__ import annotations

from decimal import Decimal

import stripe
from fastapi import APIRouter, Cookie, Depends, HTTPException, Request
from sqlalchemy.orm import Session

from auth_store import current_user
from cart import get_or_create_cart
from core.config import settings
from core.db import get_db
from core.models import (
    AuditLog, Cart, Order, OrderItem, Payment, User, Variant,
)

checkout_router = APIRouter(tags=["checkout"])

# Multiplicador a unidades mínimas. ARS/USD usan 2 decimales en Stripe.
_MINOR = 100


def _stripe_ready() -> bool:
    if not settings.STRIPE_SECRET_KEY:
        return False
    stripe.api_key = settings.STRIPE_SECRET_KEY
    return True


def _next_order_number(db: Session) -> int:
    last = db.query(Order).order_by(Order.number.desc()).first()
    return (last.number + 1) if last and last.number else 1000


def _resolve_cart(db: Session, user: User | None, token: str | None) -> Cart | None:
    if user:
        cart = db.query(Cart).filter(Cart.user_id == user.id).order_by(Cart.id).first()
        if cart:
            return cart
    return get_or_create_cart(db, None, token, create=False)


@checkout_router.post("/api/checkout/create-intent")
def create_intent(body: dict, request: Request, db: Session = Depends(get_db),
                  user: User | None = Depends(current_user),
                  mi_cart: str | None = Cookie(default=None)):
    if not _stripe_ready():
        raise HTTPException(503, "Stripe no está configurado todavía")

    cart = _resolve_cart(db, user, mi_cart)
    if not cart or not cart.items:
        raise HTTPException(400, "El carrito está vacío")

    email = (body.get("email") or (user.email if user else "")).strip().lower()
    if not email:
        raise HTTPException(400, "Falta el email")

    # Validar stock y armar snapshot
    subtotal = Decimal("0")
    snapshot = []
    for it in cart.items:
        v: Variant = it.variant
        if not v or it.quantity > v.stock:
            raise HTTPException(409, f"Sin stock suficiente de {v.product.name if v and v.product else 'un producto'}")
        line = (v.price or Decimal("0")) * it.quantity
        subtotal += line
        snapshot.append((v, it.quantity, v.price or Decimal("0"), line))

    shipping = {k: body.get(k) for k in
                ("full_name", "phone", "street", "number", "floor", "city", "province", "zipcode", "country")}
    total = subtotal  # envío se suma al confirmar logística (MVP: sin costo de envío)

    order = Order(
        number=_next_order_number(db), user_id=user.id if user else None,
        email=email, contact_name=shipping.get("full_name"), contact_phone=shipping.get("phone"),
        status="pending", payment_status="pending", currency="ARS",
        subtotal=subtotal, shipping_cost=Decimal("0"), discount=Decimal("0"), total=total,
        shipping_address=shipping,
    )
    db.add(order)
    db.flush()
    for v, qty, price, line in snapshot:
        db.add(OrderItem(order_id=order.id, variant_id=v.id, product_id=v.product_id,
                         product_name=v.product.name if v.product else "",
                         variant_value=v.value, sku=v.sku, unit_price=price,
                         quantity=qty, subtotal=line))
    db.flush()

    intent = stripe.PaymentIntent.create(
        amount=int((total * _MINOR).to_integral_value()),
        currency=settings.CHECKOUT_CURRENCY,
        receipt_email=email,
        metadata={"order_id": order.id, "order_number": order.number},
        automatic_payment_methods={"enabled": True},
    )
    db.add(Payment(order_id=order.id, provider="stripe",
                   stripe_payment_intent_id=intent.id, amount=total,
                   currency="ARS", status="pending"))
    db.add(AuditLog(user_id=user.id if user else None, action="checkout_intent",
                    entity="order", entity_id=str(order.id),
                    ip=request.client.host if request.client else None))
    db.commit()

    return {
        "client_secret": intent.client_secret,
        "publishable_key": settings.STRIPE_PUBLISHABLE_KEY,
        "order_number": order.number,
        "amount": f"{total:.2f}",
    }


@checkout_router.post("/api/stripe/webhook")
async def stripe_webhook(request: Request, db: Session = Depends(get_db)):
    if not _stripe_ready():
        raise HTTPException(503, "Stripe no está configurado")
    payload = await request.body()
    sig = request.headers.get("stripe-signature", "")
    if settings.STRIPE_WEBHOOK_SECRET:
        try:
            event = stripe.Webhook.construct_event(payload, sig, settings.STRIPE_WEBHOOK_SECRET)
        except Exception as e:  # noqa: BLE001  (firma inválida / payload manipulado)
            raise HTTPException(400, f"Firma de webhook inválida: {e}")
    elif settings.DEV_MODE:
        # SOLO en desarrollo local se acepta sin firma (para pruebas con Stripe CLI).
        import json
        event = json.loads(payload)
    else:
        # En producción la firma es OBLIGATORIA: sin secret no se procesa nada.
        raise HTTPException(503, "STRIPE_WEBHOOK_SECRET no configurado: webhook rechazado")

    etype = event["type"]
    obj = event["data"]["object"]
    pi_id = obj.get("id")
    payment = db.query(Payment).filter(Payment.stripe_payment_intent_id == pi_id).one_or_none()
    order = db.get(Order, int(obj.get("metadata", {}).get("order_id"))) if obj.get("metadata", {}).get("order_id") else None
    if payment and not order:
        order = payment.order

    if etype == "payment_intent.succeeded" and order:
        if order.payment_status != "paid":  # idempotente
            order.payment_status = "paid"
            order.status = "processing"
            if payment:
                payment.status = "paid"
                payment.raw = {"event": etype}
            # Descontar stock
            for it in order.items:
                v = db.get(Variant, it.variant_id) if it.variant_id else None
                if v:
                    v.stock = max(0, v.stock - it.quantity)
            # Vaciar carrito del usuario / asociado
            cart = None
            if order.user_id:
                cart = db.query(Cart).filter(Cart.user_id == order.user_id).first()
            if cart:
                for ci in list(cart.items):
                    db.delete(ci)
            db.add(AuditLog(user_id=order.user_id, action="payment_succeeded",
                            entity="order", entity_id=str(order.id)))
            db.commit()
    elif etype == "payment_intent.payment_failed" and payment:
        payment.status = "failed"
        payment.error_message = (obj.get("last_payment_error") or {}).get("message")
        if order:
            order.payment_status = "failed"
        db.commit()

    return {"received": True}
