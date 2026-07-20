"""
Rastrea el catalogo COMPLETO de Tiendanube (Miami Import) y lo guarda local.

Genera, en esta misma carpeta:
  - catalogo_tiendanube_completo.json  -> todos los productos (full: variantes,
                                          imagenes, categorias, stock, precio).
  - categorias_tiendanube.json         -> arbol de categorias.
  - resumen_catalogo.json              -> stats rapidas (conteos, marcas,
                                          productos sin precio, stock total).

Uso:
    python rastrear_catalogo.py

Re-correlo cuando quieras refrescar la foto del catalogo antes de migrar.
"""
from __future__ import annotations

import json
from datetime import datetime, timezone
from pathlib import Path

import tn_api  # helper local (truststore + credenciales + paginado)

AQUI = Path(__file__).resolve().parent


def texto(campo):
    """Tiendanube devuelve campos i18n como {'es': '...'}; saca el string."""
    if isinstance(campo, dict):
        return campo.get("es") or next(iter(campo.values()), "") or ""
    return campo or ""


def precio_min(producto):
    """Precio mas bajo entre las variantes (ARS). None si ninguna tiene."""
    precios = []
    for v in producto.get("variants", []):
        p = v.get("price")
        if p not in (None, "", "0", "0.00"):
            try:
                precios.append(float(p))
            except (TypeError, ValueError):
                pass
    return min(precios) if precios else None


def stock_total(producto):
    total = 0
    for v in producto.get("variants", []):
        s = v.get("stock")
        if isinstance(s, int):
            total += s
    return total


def main():
    print("Rastreando catalogo de Tiendanube (store 7575582)...")

    productos = list(tn_api.all_products(per_page=200))
    print(f"  productos rastreados: {len(productos)}")

    try:
        categorias = tn_api.get("/categories", per_page=200)
    except Exception as e:  # noqa: BLE001
        print(f"  (aviso) no se pudieron traer categorias: {e}")
        categorias = []
    print(f"  categorias rastreadas: {len(categorias)}")

    # --- guardar crudo completo ---
    (AQUI / "catalogo_tiendanube_completo.json").write_text(
        json.dumps(productos, ensure_ascii=False, indent=2), encoding="utf-8"
    )
    (AQUI / "categorias_tiendanube.json").write_text(
        json.dumps(categorias, ensure_ascii=False, indent=2), encoding="utf-8"
    )

    # --- resumen / stats ---
    sin_precio = []
    marcas = {}
    publicados = 0
    total_variantes = 0
    total_imagenes = 0
    stock_global = 0

    for p in productos:
        nombre = texto(p.get("name"))
        marca = (p.get("brand") or "Sin marca").strip() or "Sin marca"
        marcas[marca] = marcas.get(marca, 0) + 1
        if p.get("published"):
            publicados += 1
        total_variantes += len(p.get("variants", []))
        total_imagenes += len(p.get("images", []))
        stock_global += stock_total(p)
        if precio_min(p) is None:
            sin_precio.append({"id": p.get("id"), "nombre": nombre, "marca": marca})

    resumen = {
        "rastreado_en": datetime.now(timezone.utc).isoformat(),
        "store_id": tn_api.STORE_ID,
        "total_productos": len(productos),
        "publicados": publicados,
        "no_publicados": len(productos) - publicados,
        "total_variantes": total_variantes,
        "total_imagenes": total_imagenes,
        "stock_total_unidades": stock_global,
        "total_categorias": len(categorias),
        "productos_por_marca": dict(sorted(marcas.items(), key=lambda x: -x[1])),
        "productos_sin_precio": sin_precio,
    }
    (AQUI / "resumen_catalogo.json").write_text(
        json.dumps(resumen, ensure_ascii=False, indent=2), encoding="utf-8"
    )

    # --- print legible ---
    print("\n===== RESUMEN =====")
    print(f"Total productos : {resumen['total_productos']}")
    print(f"  publicados    : {resumen['publicados']}")
    print(f"  no publicados : {resumen['no_publicados']}")
    print(f"Variantes       : {resumen['total_variantes']}")
    print(f"Imagenes        : {resumen['total_imagenes']}")
    print(f"Stock total     : {resumen['stock_total_unidades']} unidades")
    print(f"Categorias      : {resumen['total_categorias']}")
    print("\nProductos por marca:")
    for marca, n in resumen["productos_por_marca"].items():
        print(f"  {n:>3}  {marca}")
    if sin_precio:
        print(f"\n⚠ Productos SIN precio ({len(sin_precio)}):")
        for x in sin_precio:
            print(f"  - [{x['id']}] {x['nombre']} ({x['marca']})")
    print("\nArchivos generados en:", AQUI)


if __name__ == "__main__":
    main()
