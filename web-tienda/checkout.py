"""
Checkout con Stripe (Payment Intents) — única pasarela.

Flujo:
  1. POST /api/checkout/create-intent: valida carrito + stock, RESERVA el stock,
     crea Order (pending) + OrderItems (snapshot de precios), crea el
     PaymentIntent y devuelve client_secret.
  2. El front monta el Payment Element con client_secret y confirma el pago.
  3. POST /api/stripe/webhook: Stripe confirma. Al cobrar
     (payment_intent.succeeded) verificamos monto y moneda contra lo que
     esperábamos, marcamos la orden pagada y vaciamos el carrito. Si el pago
     falla o se cancela, devolvemos el stock reservado.

Decisiones de seguridad (no cambiar sin entender el porqué):
  - El monto SIEMPRE se recalcula server-side desde Variant.price. Nada del
    request influye en lo que se cobra.
  - El stock se reserva al crear el intent, con SELECT ... FOR UPDATE. Validar
    sin reservar permite vender la misma unidad dos veces.
  - La firma del webhook es OBLIGATORIA siempre. No hay modo "sin firma": era
    un camino a marcar pedidos como pagados sin pagar.
  - La autoridad para resolver la orden es la fila Payment (la escribimos
    nosotros), NO el metadata del evento (viaja en el objeto de Stripe).
  - Idempotencia real por event.id en la tabla webhook_events.

Las claves viven SOLO en backend (settings). Si no están configuradas, los
endpoints responden 503 sin romper la tienda.
"""
from __future__ import annotations

import logging
from datetime import datetime, timedelta, timezone
from decimal import Decimal

import stripe
from email_validator import EmailNotValidError, validate_email
from fastapi import APIRouter, Cookie, Depends, HTTPException, Request
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from auth_store import current_user
from cart import get_or_create_cart, resolve_cart
from core.config import settings
from core.db import get_db
from core.models import (
    AuditLog, Cart, CartItem, Order, OrderItem, Payment, User, Variant, WebhookEvent,
)

log = logging.getLogger("checkout")

checkout_router = APIRouter(tags=["checkout"])

# Campos de envío aceptados y su largo máximo. Todo lo que no esté acá se
# descarta: el shipping_address va a JSON y de ahí al panel, así que un campo
# libre sin límite es superficie de XSS y de basura en la base.
_SHIPPING_FIELDS = {
    "full_name": 120, "phone": 40, "street": 160, "number": 20, "floor": 40,
    "city": 80, "province": 80, "zipcode": 20, "country": 60,
}


def _stripe_ready() -> bool:
    if not settings.STRIPE_SECRET_KEY:
        return False
    stripe.api_key = settings.STRIPE_SECRET_KEY
    return True


def _clean_shipping(body: dict) -> dict:
    """Recorta y limita los campos de envío; descarta cualquier clave extra."""
    out: dict[str, str] = {}
    for field, maxlen in _SHIPPING_FIELDS.items():
        raw = body.get(field)
        if raw is None:
            continue
        value = str(raw).strip()[:maxlen]
        if value:
            out[field] = value
    return out


def _next_order_number(db: Session) -> int:
    last = db.query(Order).order_by(Order.number.desc()).first()
    return (last.number + 1) if last and last.number else 1000


def _release_stock(db: Session, order: Order) -> None:
    """Devuelve al stock lo reservado por una orden. Idempotente vía el flag."""
    if not order.stock_reserved:
        return
    for it in order.items:
        if not it.variant_id:
            continue
        v = db.get(Variant, it.variant_id, with_for_update=True)
        if v:
            v.stock = (v.stock or 0) + it.quantity
    order.stock_reserved = False


# Minutos tras los cuales una orden pending con stock reservado se considera
# abandonada. Stripe NO cancela solo los PaymentIntents, así que sin este
# barrido la reserva quedaría para siempre y agotaría el inventario.
_RESERVATION_TTL_MIN = 30


def _reap_abandoned_reservations(db: Session) -> None:
    """Libera el stock de órdenes pending abandonadas (checkout no confirmado).

    Corre de forma oportunista al inicio de cada create-intent. Barato: filtra
    por índice sobre created_at + estado. Cancela el PaymentIntent en Stripe
    (idempotente) para que no pueda cobrarse después de liberada la reserva.
    """
    cutoff = datetime.now(timezone.utc) - timedelta(minutes=_RESERVATION_TTL_MIN)
    stale = (db.query(Order)
             .filter(Order.stock_reserved.is_(True),
                     Order.payment_status == "pending",
                     Order.created_at < cutoff)
             .limit(50)
             .all())
    for order in stale:
        try:
            pay = order.payments[0] if order.payments else None
            if pay and pay.stripe_payment_intent_id:
                # cancel() dispara payment_intent.canceled; si ya no es
                # cancelable (p.ej. ya se cobró) Stripe lanza y NO liberamos.
                stripe.PaymentIntent.cancel(pay.stripe_payment_intent_id)
                pay.status = "cancelled"
            _release_stock(db, order)
            order.status = "cancelled"
            order.payment_status = "cancelled"
            db.commit()
        except stripe.StripeError:
            # El intent no era cancelable (posible cobro en curso): dejar la
            # orden como está; el webhook resolverá el estado real.
            db.rollback()
        except Exception:  # noqa: BLE001
            db.rollback()
            log.exception("Fallo liberando reserva de la orden %s", order.id)


@checkout_router.post("/api/checkout/create-intent")
def create_intent(body: dict, request: Request, db: Session = Depends(get_db),
                  user: User | None = Depends(current_user),
                  mi_cart: str | None = Cookie(default=None)):
    if not _stripe_ready():
        raise HTTPException(503, "Stripe no está configurado todavía")

    # Liberar reservas de checkouts abandonados antes de tomar stock nuevo.
    _reap_abandoned_reservations(db)
    return _create_intent_once(body, request, db, user, mi_cart)


def _create_intent_once(body: dict, request: Request, db: Session,
                        user: User | None, mi_cart: str | None):

    # Misma resolución que usa el resto de la tienda: si el usuario logueado ve
    # un carrito, es el que se le cobra. Antes /carrito leía por cookie y el
    # checkout priorizaba el del usuario, así que se cobraba otro carrito.
    cart = resolve_cart(db, None, user, mi_cart, create=False)
    if not cart or not cart.items:
        raise HTTPException(400, "El carrito está vacío")

    raw_email = (body.get("email") or (user.email if user else "") or "").strip()
    if user:
        # Para usuarios logueados manda la sesión, no el body: si no, uno puede
        # asociar el mail de otro a su orden y desviar el recibo de Stripe.
        raw_email = user.email
    try:
        email = validate_email(raw_email, check_deliverability=False).normalized.lower()
    except EmailNotValidError:
        raise HTTPException(400, "Email inválido")

    shipping = _clean_shipping(body)

    # --- Validar y RESERVAR stock con lock de fila ---------------------------
    # with_for_update serializa a los compradores concurrentes de la misma
    # variante. En SQLite local es no-op (no hay lock de fila); el deploy real
    # es Postgres, donde sí aplica.
    subtotal = Decimal("0")
    snapshot = []
    for it in sorted(cart.items, key=lambda x: x.variant_id or 0):  # orden fijo: evita deadlocks
        v = db.get(Variant, it.variant_id, with_for_update=True) if it.variant_id else None
        if not v or it.quantity > (v.stock or 0):
            db.rollback()
            name = v.product.name if v and v.product else "un producto"
            raise HTTPException(409, f"Sin stock suficiente de {name}")
        price = v.price or Decimal("0")
        line = price * it.quantity
        subtotal += line
        snapshot.append((v, it.quantity, price, line))

    total = subtotal  # MVP: sin costo de envío (se suma al confirmar logística)
    if total <= 0:
        db.rollback()
        raise HTTPException(400, "El total del pedido es inválido")

    currency = settings.CHECKOUT_CURRENCY
    minor = settings.currency_minor_units

    # --- Crear la orden y descontar la reserva -------------------------------
    order = Order(
        number=_next_order_number(db), user_id=user.id if user else None,
        cart_id=cart.id, email=email,
        contact_name=shipping.get("full_name"), contact_phone=shipping.get("phone"),
        status="pending", payment_status="pending", currency=currency.upper()[:3],
        subtotal=subtotal, shipping_cost=Decimal("0"), discount=Decimal("0"), total=total,
        shipping_address=shipping, stock_reserved=True,
    )
    # Se usa la relación (no order_id=...) porque el id todavía no existe: lo
    # asigna SQLAlchemy al hacer flush.
    for v, qty, price, line in snapshot:
        v.stock = (v.stock or 0) - qty  # reserva efectiva
        order.items.append(OrderItem(
            variant_id=v.id, product_id=v.product_id,
            product_name=v.product.name if v.product else "",
            variant_value=v.value, sku=v.sku, unit_price=price,
            quantity=qty, subtotal=line))
    db.add(order)

    # Order.number es único y sale de max+1: dos create-intent concurrentes
    # pueden sacar el mismo. El retry se acota SOLO a este commit —no envuelve
    # la llamada a Stripe— para no crear un segundo PaymentIntent ni reservar
    # stock dos veces si un IntegrityError apareciera más adelante.
    for attempt in range(5):
        try:
            db.commit()
            break
        except IntegrityError:
            db.rollback()
            if attempt == 4:
                log.error("No se pudo asignar número de orden tras 5 intentos")
                raise HTTPException(503, "No pudimos generar el pedido. Probá de nuevo.")
            # Rehacer la reserva (el rollback la deshizo) con un número nuevo.
            for it in cart.items:
                v = db.get(Variant, it.variant_id, with_for_update=True) if it.variant_id else None
                if not v or it.quantity > (v.stock or 0):
                    raise HTTPException(409, "Sin stock suficiente")
                v.stock = (v.stock or 0) - it.quantity
            order.number = _next_order_number(db)
            db.add(order)
    db.refresh(order)

    # --- Recién ahora hablamos con Stripe ------------------------------------
    # Si esto falla, compensamos: devolvemos el stock y cancelamos la orden.
    try:
        intent = stripe.PaymentIntent.create(
            amount=int((total * minor).to_integral_value()),
            currency=currency,
            receipt_email=email,
            metadata={"order_id": order.id, "order_number": order.number},
            automatic_payment_methods={"enabled": True},
            idempotency_key=f"order-{order.id}-{order.public_token[:16]}",
        )
    except stripe.StripeError as exc:
        log.exception("Stripe rechazó la creación del PaymentIntent (orden %s)", order.id)
        _release_stock(db, order)
        order.status = "cancelled"
        order.payment_status = "failed"
        db.commit()
        raise HTTPException(502, "No pudimos iniciar el pago. Probá de nuevo en un momento.") from exc

    db.add(Payment(order_id=order.id, provider="stripe",
                   stripe_payment_intent_id=intent.id, amount=total,
                   currency=currency.upper()[:3], status="pending"))
    db.add(AuditLog(user_id=user.id if user else None, action="checkout_intent",
                    entity="order", entity_id=str(order.id),
                    ip=request.client.host if request.client else None))
    db.commit()

    return {
        "client_secret": intent.client_secret,
        "publishable_key": settings.STRIPE_PUBLISHABLE_KEY,
        "order_number": order.number,
        "order_token": order.public_token,
        "amount": f"{total:.2f}",
    }


@checkout_router.post("/api/stripe/webhook")
async def stripe_webhook(request: Request, db: Session = Depends(get_db)):
    if not _stripe_ready():
        raise HTTPException(503, "Stripe no está configurado")
    if not settings.STRIPE_WEBHOOK_SECRET:
        # Sin secret no hay forma de distinguir a Stripe de un atacante. No se
        # procesa nada, ni siquiera en desarrollo: para pruebas locales, el
        # Stripe CLI entrega su propio whsec_.
        log.error("Webhook recibido pero STRIPE_WEBHOOK_SECRET no está configurado")
        raise HTTPException(503, "Webhook no configurado")

    payload = await request.body()
    sig = request.headers.get("stripe-signature", "")
    try:
        event = stripe.Webhook.construct_event(payload, sig, settings.STRIPE_WEBHOOK_SECRET)
    except Exception as exc:  # noqa: BLE001  (firma inválida / payload manipulado)
        log.warning("Firma de webhook inválida: %s", exc)
        raise HTTPException(400, "Firma inválida")  # sin filtrar el detalle

    event_id = event.get("id") or ""
    etype = event.get("type") or ""
    obj = (event.get("data") or {}).get("object") or {}
    pi_id = obj.get("id")

    # --- Idempotencia ATÓMICA -------------------------------------------------
    # El WebhookEvent NO se commitea por separado: se agrega a la sesión y viaja
    # en el MISMO commit que el efecto (marcar pagado, liberar stock, etc.). Si
    # el procesamiento falla, el event_id no queda persistido y Stripe reintenta
    # de verdad. Si el mismo evento llega dos veces en paralelo, la PK única
    # hace que uno de los dos commits explote con IntegrityError → rollback de
    # TODO su trabajo, sin doble efecto. Marcar procesado antes de aplicar
    # perdía el pago si el paso siguiente fallaba.
    if event_id and db.get(WebhookEvent, event_id) is not None:
        return {"received": True, "duplicate": True}
    if event_id:
        db.add(WebhookEvent(event_id=event_id, event_type=etype))

    def _commit() -> bool:
        """Cierra la transacción. False si el evento resultó duplicado (otra
        entrega concurrente ganó la carrera de la PK)."""
        try:
            db.commit()
            return True
        except IntegrityError:
            db.rollback()
            return False

    # --- La fila Payment es la autoridad, no el metadata del evento ----------
    payment = (db.query(Payment)
               .filter(Payment.stripe_payment_intent_id == pi_id)
               .one_or_none()) if pi_id else None
    order = payment.order if payment else None

    if not payment:
        # No hay fila Payment: casi siempre es un PaymentIntent que no es
        # nuestro. PERO existe una ventana mínima —el proceso muere entre crear
        # el intent y guardar el Payment— en la que el cliente sí pudo pagar una
        # orden nuestra. Recuperamos por metadata.order_id, y creamos la fila
        # que faltaba, SIEMPRE verificando monto/moneda después (más abajo), así
        # que aunque el metadata fuera manipulable no se despacha de más.
        meta_oid = (obj.get("metadata") or {}).get("order_id")
        if meta_oid:
            try:
                order = db.get(Order, int(meta_oid))
            except (TypeError, ValueError):
                order = None
        if order and pi_id:
            payment = Payment(order_id=order.id, provider="stripe",
                              stripe_payment_intent_id=pi_id,
                              amount=order.total, currency=order.currency,
                              status="pending")
            db.add(payment)
        if not payment:
            log.info("Webhook %s para PaymentIntent desconocido %s", etype, pi_id)
            _commit()  # persistir el WebhookEvent: no hay nada que reintentar
            return {"received": True, "ignored": "payment_intent desconocido"}

    if not order:
        _commit()
        return {"received": True, "ignored": "orden inexistente"}

    if etype == "payment_intent.succeeded":
        # Verificar que lo cobrado sea lo que esperábamos, en la moneda correcta.
        minor = settings.currency_minor_units
        paid = Decimal(obj.get("amount_received") or obj.get("amount") or 0) / minor
        paid_cur = (obj.get("currency") or "").upper()[:3]
        if paid != payment.amount or paid_cur != (payment.currency or "").upper()[:3]:
            log.error("Monto/moneda no coinciden en orden %s: cobrado %s %s, esperado %s %s",
                      order.id, paid, paid_cur, payment.amount, payment.currency)
            db.add(AuditLog(user_id=order.user_id, action="payment_amount_mismatch",
                            entity="order", entity_id=str(order.id)))
            payment.status = "review"
            payment.error_message = (f"Cobrado {paid} {paid_cur}, "
                                     f"esperado {payment.amount} {payment.currency}")
            if not _commit():
                return {"received": True, "duplicate": True}
            return {"received": True, "review": True}  # NO despachar

        if order.payment_status != "paid":
            order.payment_status = "paid"
            order.status = "processing"
            payment.status = "paid"
            payment.raw = {"event": etype, "event_id": event_id}
            # El stock ya se reservó al crear el intent: NO se vuelve a descontar.
            # Vaciar exactamente el carrito que originó la orden (también el de
            # invitados, que antes quedaba lleno y llevaba a pagar dos veces).
            if order.cart_id:
                db.query(CartItem).filter(CartItem.cart_id == order.cart_id).delete(
                    synchronize_session=False)
            db.add(AuditLog(user_id=order.user_id, action="payment_succeeded",
                            entity="order", entity_id=str(order.id)))
            if not _commit():
                return {"received": True, "duplicate": True}
        else:
            _commit()  # ya estaba pagada; solo persistir el WebhookEvent

    elif etype in ("payment_intent.payment_failed", "payment_intent.canceled"):
        # Nunca degradar un pago ya acreditado: Stripe no garantiza el orden de
        # entrega y reintenta hasta 3 días. Un `failed` viejo llegando después
        # de un `succeeded` dejaba la orden como fallida con la plata cobrada.
        if order.payment_status == "paid":
            log.info("Ignorando %s sobre orden %s ya pagada", etype, order.id)
            _commit()
            return {"received": True, "ignored": "orden ya pagada"}
        payment.status = "failed"
        payment.error_message = (obj.get("last_payment_error") or {}).get("message")
        order.payment_status = "failed"
        if etype == "payment_intent.canceled":
            order.status = "cancelled"
        _release_stock(db, order)  # devolver lo reservado
        db.add(AuditLog(user_id=order.user_id, action="payment_failed",
                        entity="order", entity_id=str(order.id)))
        if not _commit():
            return {"received": True, "duplicate": True}

    else:
        _commit()  # evento de otro tipo: persistir el WebhookEvent y listo

    return {"received": True}
