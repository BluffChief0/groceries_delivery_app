from typing import List, Optional
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
from backend.app.core.models import models  # где лежит Product

class ProductsCRUD:
    @staticmethod
    async def get_products(db: AsyncSession, category_id: Optional[str] = None) -> List[models.Product]:
        stmt = select(models.Product)
        if category_id:
            stmt = stmt.where(models.Product.category_id == category_id)
        result = await db.execute(stmt)
        return result.scalars().all()

    @staticmethod
    async def get_product(db: AsyncSession, product_id: str) -> Optional[models.Product]:
        stmt = select(models.Product).where(models.Product.id == product_id)
        result = await db.execute(stmt)
        return result.scalar_one_or_none()

    @staticmethod
    async def search_products(db: AsyncSession, query: str) -> List[models.Product]:
        q = (query or "").strip()
        if not q:
            return []
        stmt = select(models.Product).where(
            func.lower(models.Product.name).like(f"%{q.lower()}%")
        )
        result = await db.execute(stmt)
        return result.scalars().all()