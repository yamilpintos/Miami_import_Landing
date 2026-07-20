"""
Helper de la API REST de Tiendanube para Miami Import (store 7575582).

Uso:
    from tn_api import get, put, post, delete, all_products

    productos = list(all_products())
    set_variant_price(123, 456, 49999)

Nota SSL: Avast Antivirus intercepta el tráfico HTTPS y re-firma los
certificados con su propio root CA. Por eso usamos `truststore`, que valida
contra el almacén de certificados de Windows (donde sí está el root de Avast).
Si algún día se desactiva el escudo de Avast, esto sigue funcionando igual.
"""

import time
import truststore
truststore.inject_into_ssl()  # usar el cert store de Windows (fix Avast)

import requests

STORE_ID = "7575582"
BASE = f"https://api.tiendanube.com/v1/{STORE_ID}"
HEADERS = {
    "Authentication": "bearer 84f0e99f3969b7359b7b85bda2d3cb8fc046a393",
    "User-Agent": "MiamiImport (yamil@miamiimport.com.ar)",
    "Content-Type": "application/json",
}

# pausa entre requests para no pegar el rate limit (~80/min)
THROTTLE = 0.8


def get(path, **params):
    r = requests.get(f"{BASE}{path}", headers=HEADERS, params=params, timeout=30)
    r.raise_for_status()
    return r.json()


def put(path, payload):
    r = requests.put(f"{BASE}{path}", headers=HEADERS, json=payload, timeout=30)
    r.raise_for_status()
    return r.json()


def post(path, payload):
    r = requests.post(f"{BASE}{path}", headers=HEADERS, json=payload, timeout=30)
    r.raise_for_status()
    return r.json()


def delete(path):
    r = requests.delete(f"{BASE}{path}", headers=HEADERS, timeout=30)
    r.raise_for_status()
    return r.status_code


def all_products(per_page=200, throttle=THROTTLE):
    """Itera TODOS los productos paginando.

    Tiendanube devuelve 404 (no una lista vacía) cuando se pide una página
    inexistente, por eso cortamos cuando una página viene incompleta.
    """
    page = 1
    while True:
        items = get("/products", per_page=per_page, page=page)
        if not items:
            break
        for p in items:
            yield p
        if len(items) < per_page:
            break
        page += 1
        time.sleep(throttle)


def set_variant_price(product_id, variant_id, new_price_ars):
    """Actualiza el precio (ARS) de una variante. El precio vive en la variante."""
    return put(f"/products/{product_id}/variants/{variant_id}",
               {"price": str(new_price_ars)})


if __name__ == "__main__":
    # smoke test
    r = requests.get(f"{BASE}/products", headers=HEADERS,
                     params={"per_page": 1}, timeout=30)
    print("status", r.status_code,
          "| total productos:", r.headers.get("X-Total-Count"),
          "| rate remaining:", r.headers.get("X-Rate-Limit-Remaining"))
