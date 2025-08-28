from typing import List, Optional, Annotated
from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession
from backend.app.core.models.db import get_async_session
from backend.app.core.schemas import orders as sch
from backend.app.core.crud.orders import OrdersCRUD
from backend.app.core.models.models import OrderStatus

route = APIRouter(prefix="/orders", tags=["orders"])


@route.post("/", response_model=sch.OrderRead)
async def create_order_endpoint(order: sch.OrderCreate, db: AsyncSession = Depends(get_async_session)):
    created = await OrdersCRUD.create_order(db, order)
    return created


@route.get("/{order_id}", response_model=sch.OrderRead)
async def read_order_endpoint(
    order_id: str,
    db: AsyncSession = Depends(get_async_session),
):
    order = await OrdersCRUD.get_order(db, order_id)
    return order


@route.get("/", response_model=list[sch.OrderRead], summary="List Orders Endpoint")
async def list_orders_endpoint(
    limit: int = Query(50, ge=1, le=500),
    offset: int = Query(0, ge=0),
    status: Optional[List[OrderStatus]] = Query(
        default=None,
        description="Можно несколько: ?status=created&status=delivered"
    ),
    db: AsyncSession = Depends(get_async_session),
):
    return await OrdersCRUD.list_orders(db, limit=limit, offset=offset, statuses=status)