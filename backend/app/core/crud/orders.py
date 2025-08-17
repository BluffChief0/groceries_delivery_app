from sqlalchemy.ext.asyncio import AsyncSession
from backend.app.core.models import models
from backend.app.core.schemas import schemas
import uuid

class OrdersCRUD:

    @staticmethod
    async def create_order(db: AsyncSession, order: schemas.OrderCreate) -> models.Order:
        db_order = models.Order(
            id=str(uuid.uuid4()),
            user_phone=order.user_phone,
            delivery_address=order.delivery_address,
            delivery_time=order.delivery_time,
            total_price=order.total_price,
            status=models.OrderStatus.created
        )
        db.add(db_order)
        db.commit()
        db.refresh(db_order)
        for item in order.items:
            db_item = models.OrderItem(
                id=str(uuid.uuid4()),
                order_id=db_order.id,
                product_id=item.product_id,
                quantity=item.quantity,
                price=item.price
            )
            db.add(db_item)
        db.commit()
        return await db_order
