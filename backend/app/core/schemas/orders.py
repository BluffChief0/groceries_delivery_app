# from pydantic import BaseModel
# from datetime import datetime
# from typing import List, Optional
# from backend.app.core.models.models import OrderStatus

# class OrderItemCreate(BaseModel):
#     product_id: str
#     amount: int
#     price: float


# class OrderCreate(BaseModel):
#     user_phone: str
#     delivery_address: str
#     delivery_time: datetime
#     items: List[OrderItemCreate]
    
    
#     class Config:
#         json_schema_extra = {
#             "example": {
#                 "user_phone": "+79123456789",
#                 "fio": "Иванов Иван Иванович",
#                 "delivery_address": "г. Москва, ул. Ленина, д. 10",
#                 "delivery_time": "2025-09-01T14:00:00",
#                 "delivery_type": "курьер",
#                 "payment_type": "карта",
#                 "comment": "Позвонить за 10 минут",
#                 "items": [
#                     {
#                         "product_id": "136fa2d1-e5aa-4a9f-8def-5e6bda51315e",
#                         "amount": 2,
#                         "price": 100
#                     }
#                 ]
#             }
#         }


# class Order(BaseModel):
#     id: str
#     user_phone: str

#     delivery_type: str
#     delivery_address: str
#     delivery_time: datetime

#     total_price: float
#     payment_type: str
    
#     status: OrderStatus
#     created_at: datetime
#     updated_at: Optional[datetime]
#     comment: Optional[str] = None



from pydantic import BaseModel, ConfigDict, conint, condecimal
from typing import List, Optional, Literal
from datetime import datetime
from uuid import UUID
from backend.app.core.models.models import OrderStatus  # enum


class OrderItemCreate(BaseModel):
    product_id: UUID | str           # выбери один тип и придерживайся его в БД
    amount: conint(ge=1)
    price: condecimal(max_digits=10, decimal_places=2, ge=0)


class OrderCreate(BaseModel):
    user_phone: str
    fio: str
    delivery_address: str
    delivery_time: Optional[datetime] = None
    delivery_type: Literal["курьер", "самовывоз"]
    payment_type: Literal["карта", "наличные", "онлайн"]
    comment: Optional[str] = None
    items: List[OrderItemCreate]

    model_config = ConfigDict(
        extra="forbid",
        json_schema_extra={
            "example": {
                "user_phone": "+79123456789",
                "fio": "Иванов Иван Иванович",
                "delivery_address": "г. Москва, ул. Ленина, д. 10",
                "delivery_time": "2025-09-01T14:00:00",
                "delivery_type": "курьер",
                "payment_type": "карта",
                "comment": "Позвонить за 10 минут",
                "items": [
                    {
                        "product_id": "136fa2d1-e5aa-4a9f-8def-5e6bda51315e",
                        "amount": 2,
                        "price": "100.00"
                    }
                ]
            }
        }
    )


class OrderItemRead(BaseModel):
    id: str
    product_id: str
    amount: int
    price: float


class OrderRead(BaseModel):
    id: str
    user_phone: str
    fio: str
    delivery_type: str
    delivery_address: str
    delivery_time: Optional[datetime]
    total_price: float
    payment_type: str
    status: OrderStatus
    created_at: datetime
    updated_at: Optional[datetime]
    comment: Optional[str] = None
    items: List[OrderItemRead] = []