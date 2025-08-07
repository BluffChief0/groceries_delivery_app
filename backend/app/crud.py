from sqlalchemy.orm import Session
from app import models, schemas
from typing import List
import uuid

def get_categories(db: Session) -> List[models.Category]:
    return db.query(models.Category).all()

def get_products(db: Session, category_id: str = None) -> List[models.Product]:
    query = db.query(models.Product)
    if category_id:
        query = query.filter(models.Product.category_id == category_id)
    return query.all()

def get_product(db: Session, product_id: str) -> models.Product:
    return db.query(models.Product).filter(models.Product.id == product_id).first()

def search_products(db: Session, query: str) -> List[models.Product]:
    return db.query(models.Product).filter(models.Product.name.ilike(f"%{query}%")).all()

def create_order(db: Session, order: schemas.OrderCreate) -> models.Order:
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
    return db_order

