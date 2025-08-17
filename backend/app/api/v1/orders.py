from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from backend.app.core.models.db import get_async_session
from backend.app.core.crud.orders import OrdersCRUD
from backend.app.core.schemas.schemas import OrderCreate, Order

route = APIRouter()

@route.post('/', response_model=Order)
async def create_order_endpoint(order: OrderCreate, db: AsyncSession = Depends(get_async_session)):
    return await OrdersCRUD.create_order(db, order)

