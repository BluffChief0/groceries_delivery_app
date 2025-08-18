from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload
from sqlalchemy import select
from fastapi import HTTPException
from backend.app.core.models import models
from backend.app.core.schemas import schemas
import uuid

class OrdersCRUD:

    @staticmethod
    async def create_order(db: AsyncSession, order: schemas.OrderCreate) -> models.Order:
        # Проверяем что product_id есть
        product_ids = [i.product_id for i in order.items]
        if product_ids:
            rows = await db.execute(
                select(models.Product.id).where(models.Product.id.in_(product_ids))
            )
            found = {r[0] for r in rows}
            missing = set(product_ids) - found
            if missing:
                raise HTTPException(
                    status_code=400,
                    detail={"error": "UNKNOWN_PRODUCT", "missing_ids": sorted(missing)},
                )
            
        total_price = sum(i.amount * i.price for i in order.items)
        db_order = models.Order(
            id=str(uuid.uuid4()),
            user_phone=order.user_phone,
            delivery_address=order.delivery_address,
            delivery_time=order.delivery_time,
            total_price=total_price,
            status=models.OrderStatus.created,
        )

        db_order.items = [
            models.OrderItem(
                id=str(uuid.uuid4()),
                product_id=i.product_id,
                amount=i.amount,
                price=i.price,
            )
            for i in order.items
        ]

        db.add(db_order)
        await db.commit()

        # created_at/updated_at задаются БД → обновим их, и items уже подгружены (lazy='selectin')
        await db.refresh(db_order, attribute_names=["created_at", "updated_at", "items"])

        return db_order