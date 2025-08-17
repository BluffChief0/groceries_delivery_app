from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from sqlalchemy.ext.asyncio import AsyncSession
from backend.app.core.models.db import get_async_session
from backend.app.core.crud.categories import CategoriesCRUD
from backend.app.core.schemas.schemas import Category
from typing import List

route = APIRouter()

@route.get('/', response_model=List[Category])
async def list_categories(db: AsyncSession = Depends(get_async_session)):
    return await CategoriesCRUD.get_categories(db)

