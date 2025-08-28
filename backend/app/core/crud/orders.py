from typing import Iterable, Optional
from decimal import Decimal
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload
from sqlalchemy import select
from fastapi import HTTPException
from backend.app.core.models import models
from backend.app.core.schemas import schemas
from backend.app.core.schemas import orders
import uuid

class OrdersCRUD:

    @staticmethod
    async def create_order(db: AsyncSession, order: orders.OrderCreate) -> models.Order:
        # 0) Базовая валидация
        if not order.items:
            raise HTTPException(status_code=422, detail="ORDER_EMPTY_ITEMS")

        # 1) Проверяем, что все product_id существуют
        product_ids = [str(i.product_id) for i in order.items]
        rows = await db.execute(
            select(models.Product.id).where(models.Product.id.in_(product_ids))
        )
        found = {r[0] for r in rows}
        missing = sorted(set(product_ids) - found)
        if missing:
            raise HTTPException(
                status_code=400,
                detail={"error": "UNKNOWN_PRODUCT", "missing_ids": missing},
            )

        # 2) Считаем total_price точно (Decimal)
        total_price = sum(Decimal(str(i.price)) * i.amount for i in order.items)

        # 3) Создаём Order — ВАЖНО: проставляем fio / delivery_type / payment_type / comment
        db_order = models.Order(
            id=str(uuid.uuid4()),
            user_phone=order.user_phone,
            fio=order.fio,
            delivery_type=order.delivery_type,
            delivery_address=order.delivery_address,
            delivery_time=order.delivery_time,
            payment_type=order.payment_type,
            comment=getattr(order, "comment", None),
            total_price=total_price,
            status=models.OrderStatus.created,
        )

        # 4) Привязываем позиции
        db_order.items = [
            models.OrderItem(
                id=str(uuid.uuid4()),
                product_id=str(i.product_id),
                amount=i.amount,
                price=Decimal(str(i.price)),
            )
            for i in order.items
        ]

        db.add(db_order)
        await db.commit()

        # 5) Корректно возвращаем заказ с items (refresh отношений не делает)
        res = await db.execute(
            select(models.Order)
            .options(selectinload(models.Order.items))
            .where(models.Order.id == db_order.id)
        )
        return res.scalar_one()
    

    @staticmethod
    async def get_order(db: AsyncSession, order_id: str) -> models.Order:
        q = (
            select(models.Order)
            .options(selectinload(models.Order.items))
            .where(models.Order.id == order_id)
        )
        res = await db.execute(q)
        order = res.scalar_one_or_none()
        if not order:
            raise HTTPException(status_code=404, detail="ORDER_NOT_FOUND")
        return order


    @staticmethod
    async def list_orders(
        db: AsyncSession,
        limit: int = 50,
        offset: int = 0,
        statuses: Optional[Iterable[models.OrderStatus]] = None,
    ) -> list[models.Order]:
        q = (
            select(models.Order)
            .options(selectinload(models.Order.items))
            .order_by(models.Order.created_at.desc())
            .limit(limit)
            .offset(offset)
        )
        if statuses:
            q = q.where(models.Order.status.in_([s.value for s in statuses]))
            # если у тебя native_enum=True в Postgres, можно без .value

        res = await db.execute(q)
        return list(res.scalars().all())