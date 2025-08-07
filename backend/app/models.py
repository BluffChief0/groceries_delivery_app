import uuid
import enum
from sqlalchemy import Column, String, Integer, Float, Text, DECIMAL, ForeignKey, Enum, DateTime
from sqlalchemy.types import UUID
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from backend.app.db import Base


class OrderStatus(str, enum.Enum):
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
    nutritional_value = Column(Text, nullable=True)
    calories = Column(Integer, nullable=True)
    weight = Column(Float, nullable=True)
    country = Column(String(128), nullable=True)
    category = relationship('Category', back_populates='products')
    order_items = relationship('OrderItem', back_populates='product')


class User(Base):
    __tablename__ = 'users'
    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    phone_number = Column(String(32), unique=True, nullable=False)
    name = Column(String(128), nullable=True)
    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, onupdate=func.now())
    orders = relationship('Order', back_populates='user')


class Order(Base):
    __tablename__ = 'orders'
    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_phone = Column(String(32), nullable=True)
    user_id = Column(String(36), ForeignKey('users.id'), nullable=True)
    delivery_address = Column(Text, nullable=False)
    delivery_time = Column(DateTime, nullable=True)
    total_price = Column(DECIMAL(10,2), nullable=False)
    status = Column(Enum(OrderStatus), default=OrderStatus.created)
    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, onupdate=func.now())
    user = relationship('User', back_populates='orders')
    items = relationship('OrderItem', back_populates='order')


class OrderItem(Base):
    __tablename__ = 'order_items'
    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    order_id = Column(String(36), ForeignKey('orders.id'))
    product_id = Column(String(36), ForeignKey('products.id'))
    quantity = Column(Integer, nullable=False)
    price = Column(DECIMAL(10,2), nullable=False)
    order = relationship('Order', back_populates='items')
    product = relationship('Product', back_populates='order_items')

