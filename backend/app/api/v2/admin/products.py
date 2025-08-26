from fastapi import APIRouter, Depends, HTTPException, Response
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, delete
from backend.app.core.models.db import get_async_session
from backend.app.core.models.models import Product
from backend.app.core.schemas.manage import ProductCreate, ProductOut
from pathlib import Path

manage_products_router = APIRouter(tags=["products"])

PRODUCTS_DIR = Path("backend/app/templates/images/products").resolve()

def _fs_path_from_url(image_url: str) -> Path | None:
    if not image_url or not image_url.startswith("/products/images/"):
        return None
    fname = image_url.split("/products/images/", 1)[1]
    return (PRODUCTS_DIR / fname).resolve()

@manage_products_router.get("/products", response_model=list[ProductOut])
async def list_products(db: AsyncSession = Depends(get_async_session)):
    res = await db.execute(select(Product))
    return [ProductOut.model_validate(row) for row in res.scalars().all()]

@manage_products_router.post("/products", response_model=ProductOut, status_code=201)
async def create_product(payload: ProductCreate, db: AsyncSession = Depends(get_async_session)):
    obj = Product(**payload.model_dump())
    db.add(obj)
    await db.commit()
    await db.refresh(obj)
    return ProductOut.model_validate(obj)

@manage_products_router.delete("/products/{product_id}", status_code=204, response_class=Response)
async def delete_product(product_id: str, db: AsyncSession = Depends(get_async_session)):
    res = await db.execute(select(Product).where(Product.id == product_id))
    obj = res.scalars().first()
    if not obj:
        raise HTTPException(status_code=404, detail="Продукт не найден")

    # удаляем запись
    await db.execute(delete(Product).where(Product.id == product_id))
    await db.commit()

    # пробуем удалить файл
    fpath = _fs_path_from_url(obj.image_url)
    if fpath and fpath.exists():
        try: fpath.unlink()
        except: pass

    return Response(status_code=204)