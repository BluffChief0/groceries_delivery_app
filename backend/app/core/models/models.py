import uuid
from enum import Enum as PyEnum
from sqlalchemy import Enum as SAEnum
from sqlalchemy.ext.mutable import MutableList
from sqlalchemy import Column, String, Integer, Float, Text, DECIMAL, ForeignKey, Enum, DateTime, JSON
from sqlalchemy.orm import relationship, Mapped, mapped_column
from sqlalchemy.sql import func
from fastapi_users.db import SQLAlchemyBaseUserTableUUID

from backend.app.core.models.db import Base


class OrderStatus(str, Enum):
    created = 'created'
    processing = 'processing'
    delivered = 'delivered'
    canceled = 'canceled'


class Category(Base):
    __tablename__ = 'categories'
    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    name = Column(String(128), nullable=False)
    image_url = Column(String(2048), nullable=False)
    products = relationship('Product', back_populates='category')

class Product(Base):
    __tablename__ = 'products'
    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    category_id = Column(String(36), ForeignKey('categories.id'))
    name = Column(String(128), nullable=False)
    description = Column(Text, nullable=True)
    image_url = Column(String(2048), nullable=False)
    price = Column(DECIMAL(10,2), nullable=False)
    discount_price = Column(DECIMAL(10,2), nullable=True)
    stock = Column(Integer, nullable=False, default=0)
    rating = Column(Float, nullable=True)
    composition = Column(Text, nullable=True)
    nutritional: Mapped[list[dict]] = mapped_column(MutableList.as_mutable(JSON),
                                                    nullable=True,
                                                    default=list)
    package = Column(Text, nullable=True)
    calories = Column(Integer, nullable=True)
    weight = Column(Float, nullable=True)
    country = Column(String(128), nullable=True)
    category = relationship('Category', back_populates='products')
    order_items = relationship('OrderItem', back_populates='product')


class User(SQLAlchemyBaseUserTableUUID, Base):
    __tablename__ = 'users'
    phone_number: Mapped[str | None] = mapped_column(String(32), unique=True, nullable=True)
    name: Mapped[str | None] = mapped_column(String(128), nullable=True)
    role: Mapped[str] = mapped_column(String(32), default="user")
    created_at: Mapped[DateTime] = mapped_column(DateTime, server_default=func.now())
    updated_at: Mapped[DateTime | None] = mapped_column(DateTime, onupdate=func.now())

    # если у тебя есть таблица Order с FK на users.id:
    orders: Mapped[list["Order"]] = relationship(back_populates="user")

class Role(str, Enum):
    admin="admin"; manager="manager"; employee="employee"; viewer="viewer"

role = Column(Enum(Role), nullable=False, default=Role.manager)


class OAuthAccount(SQLAlchemyBaseUserTableUUID, Base):
    __tablename__ = "oauth_accounts"


class OrderStatus(str, PyEnum):
    created    = "created"
    paid       = "paid"
    processing = "processing"
    delivering = "delivering"
    delivered  = "delivered"
    cancelled  = "cancelled"


class Order(Base):
    __tablename__ = 'orders'
    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_phone = Column(String(32), nullable=True)
    user_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("users.id"), nullable=True)
    fio = Column(String(255), nullable=False)
    
    delivery_type = Column(String(50), nullable=False)
    delivery_address = Column(Text, nullable=False)
    delivery_time = Column(DateTime, nullable=True)

    total_price = Column(DECIMAL(10,2), nullable=False)
    payment_type = Column(String(50), nullable=False)

    comment = Column(Text, nullable=True)
    
    status = Column(
        SAEnum(
            OrderStatus,
            name="order_status",
            native_enum=False,
            create_constraint=True,
            validate_strings=True,
        ),
        nullable=False,
        default=OrderStatus.created,
        server_default=OrderStatus.created.value,
    )
    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, onupdate=func.now())
    user: Mapped["User"] = relationship(back_populates="orders")
    items = relationship('OrderItem', back_populates='order', lazy='selectin')


class OrderItem(Base):
    __tablename__ = 'order_items'
    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    order_id = Column(String(36), ForeignKey('orders.id'))
    product_id = Column(String(36), ForeignKey('products.id'))
    amount = Column(Integer, nullable=False)
    price = Column(DECIMAL(10,2), nullable=False)
    order = relationship('Order', back_populates='items')
    product = relationship('Product', back_populates='order_items')

