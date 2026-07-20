# MIAMI IMPORT — Plataforma Propia

Proyecto para **salir de Tiendanube** y tener web + panel propios (hosteados en Render).
Acá conviven las dos piezas para trabajarlas en conjunto.

## Carpetas

### `panel-control/`
El **panel de control** (Stock Manager). Desde acá se suben modelos de ropa,
se maneja stock, precios (USD→ARS), pedidos y métricas.
- Es una app **FastAPI** (Python).
- Se arranca con doble-click en `start.bat` → abre en `http://localhost:8000`.
- La pestaña **"Nuevo producto"** es la que usás para subir ropa.
- Config en `.env` (token de Tiendanube, tipo de cambio, etc.).

> Hoy este panel le habla a la API de Tiendanube. En la migración lo vamos a
> apuntar a **nuestra propia base de datos**, así deja de depender de Tiendanube.

### `web-tienda/`
La **web pública** (el theme actual de Tiendanube, "Champagne Noir / Miami").
Todo el diseño: hero con lluvia de marcas, fondo 3D (Vanta), animaciones GSAP,
sección trilogía Diesel, lookbook, precios duales USD/ARS.
- Son archivos `.tpl` (plantillas), `.css`, `.js` e imágenes.
- Hoy corren DENTRO de Tiendanube. En la migración los vamos a convertir en un
  sitio que corre **solo, sin Tiendanube**.

## Cómo cobramos (decisión tomada)
- **Transferencia bancaria** como medio principal (sin pasarela = nada que te
  puedan bloquear). Con descuento por transferencia como incentivo.
- Mercado Pago queda como **opción enchufable a futuro** (NO Stripe: Stripe no
  opera en Argentina para cobrar en pesos y es el que más congela fondos).

## Plan por fases
1. Base de datos propia + migrar el catálogo completo (ya hay backups JSON).
2. Panel de control apuntando a la base propia (alta/edición de productos, stock).
3. Web pública clonada (mismo diseño) corriendo sola.
4. Carrito + checkout por transferencia + comprobante por WhatsApp.
5. Blindaje de seguridad + deploy en Render + cambio de dominio.

---
_Generado el 2026-06-03. Las dos carpetas son COPIAS — los originales siguen
intactos en sus ubicaciones, así no rompemos nada de lo que hoy funciona._
