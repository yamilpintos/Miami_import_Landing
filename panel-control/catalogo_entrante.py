"""
Catálogo entrante — fotos pendientes de convertir en productos.

Diferencia con el panel viejo: aquel leía una carpeta del disco de la PC
(`catalogo_entrante/`), porque corría en local. Acá el panel vive en Render,
donde no existe esa carpeta y el disco se borra en cada deploy. Entonces las
fotos se SUBEN desde el navegador y quedan en una carpeta de trabajo temporal
del servidor hasta que se convierten en producto (que sí queda persistido en la
base + Supabase).

El resto del flujo es idéntico al viejo: el nombre del archivo sugiere
nombre/marca/talles, todo editable antes de crear el producto.
Convención: "p07 - Off-White buzo - talle S-M-L.jpeg"
"""
from __future__ import annotations

import os
import re
import shutil
import unicodedata
from pathlib import Path
from typing import Any

from fastapi import APIRouter, Depends, File, Form, HTTPException, UploadFile
from fastapi.responses import FileResponse

from auth import get_current_admin

router = APIRouter(prefix="/api/catalogo_entrante", tags=["catalogo-entrante"],
                   dependencies=[Depends(get_current_admin)])

HERE = Path(__file__).resolve().parent
ENTRANTE_DIR = Path(os.environ.get("CATALOGO_ENTRANTE_DIR",
                                   str(HERE / "data" / "catalogo_entrante"))).resolve()
SUBIDOS_DIR = ENTRANTE_DIR / "subidos"
DESCARTADOS_DIR = ENTRANTE_DIR / "descartados"

_IMG_EXTS = {".jpg", ".jpeg", ".png", ".webp"}
_MAX_BYTES = 12 * 1024 * 1024

_BRANDS_CONOCIDAS = [
    "Off-White", "Balenciaga", "Palm Angels", "Diesel", "Boss", "Jacquemus",
    "Calvin Klein", "Tommy Hilfiger", "Ralph Lauren", "Lacoste", "Nike",
    "Adidas", "Puma", "Stone Island", "Moncler", "Gucci", "Prada", "Versace",
    "Armani", "Hugo Boss", "Carhartt", "The North Face", "Champion",
]


def _ensure_dirs() -> None:
    for d in (ENTRANTE_DIR, SUBIDOS_DIR, DESCARTADOS_DIR):
        d.mkdir(parents=True, exist_ok=True)


def _safe_name(filename: str) -> str:
    """Nombre de archivo seguro: sin rutas ni caracteres raros.

    Evita path traversal (../) y nombres que se escapen del directorio.
    """
    base = Path(filename).name  # descarta cualquier ruta
    base = unicodedata.normalize("NFKD", base)
    base = re.sub(r"[^A-Za-z0-9 ._()\-]", "", base).strip()
    if not base or base.startswith("."):
        raise HTTPException(400, "Nombre de archivo inválido")
    return base[:150]


def _safe_path(filename: str) -> Path:
    f = (ENTRANTE_DIR / _safe_name(filename)).resolve()
    # Doble control: el resultado tiene que seguir dentro del directorio.
    if not str(f).startswith(str(ENTRANTE_DIR)):
        raise HTTPException(400, "Ruta inválida")
    return f


def parse_entrante(filename: str) -> dict[str, Any]:
    """Deriva nombre/marca/talles del nombre del archivo. Todo editable después.

    Formato esperado: 'pNN - <descripción> - talle <talles>.jpeg'
    """
    stem = re.sub(r"\.(jpe?g|png|webp)$", "", filename, flags=re.I)
    partes = [p.strip() for p in stem.split(" - ")]
    pagina = partes[0] if partes else ""
    medio = partes[1] if len(partes) > 1 else stem

    talle_raw = ""
    for p in partes:
        if p.lower().startswith("talle"):
            talle_raw = p[len("talle"):].strip()

    revisar = medio.lower().startswith("revisar")
    # Detectar marca sobre el texto SIN la nota "(rev ...)" para no agarrar
    # marcas mencionadas como duda (ej: "Campera Jean (rev CK-Diesel)").
    medio_sin_rev = re.sub(r"\(rev[^)]*\)", "", medio, flags=re.I)
    marca = ""
    if not revisar:
        for b in _BRANDS_CONOCIDAS:
            if b.lower() in medio_sin_rev.lower():
                marca = b
                break

    nombre = re.sub(r"revisar-marca", "", medio_sin_rev, flags=re.I).strip()
    nombre = re.sub(r"\s{2,}", " ", nombre).strip()
    nombre = (nombre[:1].upper() + nombre[1:]) if nombre else pagina

    talles: list[str] = []
    if talle_raw and "completar" not in talle_raw.lower():
        sin_notas = re.sub(r"\([^)]*\)", "", talle_raw)
        for tok in re.split(r"[-/\s]+", sin_notas):
            tok = tok.strip().upper()
            if tok:
                talles.append(tok)

    return {
        "filename": filename,
        "pagina": pagina,
        "nombre_sugerido": nombre,
        "marca_sugerida": marca,
        "talles_sugeridos": talles,
        "talle_original": talle_raw,
        "revisar_marca": revisar or not marca,
        "img_url": f"/api/catalogo_entrante/img/{filename}",
    }


@router.get("")
def listar():
    """Lista las fotos pendientes de convertir en producto."""
    _ensure_dirs()
    items = [parse_entrante(f.name) for f in sorted(ENTRANTE_DIR.iterdir())
             if f.is_file() and f.suffix.lower() in _IMG_EXTS]
    return {
        "available": True,
        "dir": str(ENTRANTE_DIR),
        "cloud": True,  # el front avisa que las fotos se suben por el navegador
        "items": items,
    }


@router.get("/img/{filename}")
def imagen(filename: str):
    f = _safe_path(filename)
    if not f.exists():
        raise HTTPException(404, "No existe la imagen")
    return FileResponse(f)


@router.post("/upload")
async def subir_fotos(files: list[UploadFile] = File(...)):
    """Carga fotos a la bandeja de entrada (reemplaza a la carpeta local).

    Se conserva el nombre original porque de ahí se deducen marca y talles.
    """
    _ensure_dirs()
    guardadas, rechazadas = [], []
    for up in files:
        try:
            name = _safe_name(up.filename or "")
        except HTTPException:
            rechazadas.append({"archivo": up.filename, "motivo": "nombre inválido"})
            continue
        if Path(name).suffix.lower() not in _IMG_EXTS:
            rechazadas.append({"archivo": name, "motivo": "no es una imagen"})
            continue
        data = await up.read()
        if len(data) > _MAX_BYTES:
            rechazadas.append({"archivo": name, "motivo": "supera 12 MB"})
            continue
        if not data:
            rechazadas.append({"archivo": name, "motivo": "archivo vacío"})
            continue
        (ENTRANTE_DIR / name).write_bytes(data)
        guardadas.append(name)
    return {"ok": True, "guardadas": guardadas, "rechazadas": rechazadas}


@router.post("/descartar")
def descartar(filename: str = Form(...)):
    """Saca una foto de pendientes sin cargarla (la archiva en 'descartados')."""
    _ensure_dirs()
    f = _safe_path(filename)
    if not f.exists():
        raise HTTPException(404, "No existe la imagen")
    shutil.move(str(f), str(DESCARTADOS_DIR / f.name))
    return {"ok": True}


def archivar_subida(filename: str) -> None:
    """Mueve la foto a 'subidos' una vez creado el producto."""
    _ensure_dirs()
    f = _safe_path(filename)
    if f.exists():
        shutil.move(str(f), str(SUBIDOS_DIR / f.name))
