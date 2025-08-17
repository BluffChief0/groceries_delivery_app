from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from backend.app.core.models.db import get_async_session
from backend.app.core.crud.products import ProductsCRUD
from backend.app.core.schemas.schemas import Product
from typing import List

route = APIRouter()

@route.get('/', response_model=List[Product])
async def list_products(category_id: str = None, db: AsyncSession = Depends(get_async_session)):
    return await ProductsCRUD.get_products(db, category_id)

@route.get('/search', response_model=List[Product])
async def search_products_endpoint(q: str, db: AsyncSession = Depends(get_async_session)):
    return await ProductsCRUD.search_products(db, q)

@route.get('/{product_id}', response_model=Product)
async def get_product_endpoint(product_id: str, db: AsyncSession = Depends(get_async_session)):
    return await ProductsCRUD.get_product(db, product_id)