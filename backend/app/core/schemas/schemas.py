from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional
from backend.app.core.models.models import OrderStatus


class Category(BaseModel):
    id: str
    name: str
    image_url: str


    class Config:
        orm_mode = True


class Product(BaseModel):
    id: str
    category_id: str
    name: str
    description: Optional[str]
    image_url: str
    price: float
    discount_price: Optional[float]
    stock: int
    rating: Optional[float]
    composition: Optional[str]
    nutritional_value: Optional[str]
    calories: Optional[int]
    weight: Optional[float]
    country: Optional[str]


    class Config:
        orm_mode = True


class OrderItemCreate(BaseModel):
    product_id: str
    amount: int
    price: float


class OrderCreate(BaseModel):
    user_phone: str
    delivery_address: str
    delivery_time: datetime
    items: List[OrderItemCreate]


class Order(BaseModel):
    id: str
    user_phone: str
    delivery_address: str
    delivery_time: datetime
    total_price: float
    status: OrderStatus
    created_at: datetime
    updated_at: Optional[datetime]


    class Config:
        orm_mode = True

