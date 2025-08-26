from backend.services.yk.payments import pay, check_payment

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from sqlalchemy.ext.asyncio import AsyncSession
from backend.app.core.models.db import get_async_session
from backend.app.core.crud.categories import CategoriesCRUD
from backend.app.core.schemas.schemas import Category
from typing import List
from uuid import uuid4

payment_route = APIRouter()
payment_id = uuid4()

@payment_route.get("/payment/", response_model=List[Category])
async def list_categories(db: AsyncSession = Depends(get_async_session)):
    return await CategoriesCRUD.get_categories(db)