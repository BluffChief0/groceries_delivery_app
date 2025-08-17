from sqlalchemy.ext.asyncio import AsyncSession
from backend.app.core.models import models
from typing import List


class ProductsCRUD:

    @staticmethod
    async def get_products(db: AsyncSession, category_id: str = None) -> List[models.Product]:
        query = db.query(models.Product)
        if category_id:
            query = query.filter(models.Product.category_id == category_id)
        return await query.all()


    @staticmethod
    async def get_product(db: AsyncSession, product_id: str) -> models.Product:
        return await db.query(models.Product).filter(models.Product.id == product_id).first()


    @staticmethod
    async def search_products(db: AsyncSession, query: str) -> List[models.Product]:
        return await db.query(models.Product).filter(models.Product.name.ilike(f"%{query}%")).all()
