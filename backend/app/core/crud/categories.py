from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from backend.app.core.models import models
from typing import List


class CategoriesCRUD:
    @staticmethod
    async def get_categories(db: AsyncSession) -> List[models.Category]:
        result = await db.execute(select(models.Category))
        return result.scalars().all()