from sqlalchemy.orm import Session
from backend.app import models
from typing import List


class ProductsCRUD:

    @staticmethod
    def get_products(db: Session, category_id: str = None) -> List[models.Product]:
        query = db.query(models.Product)
        if category_id:
            query = query.filter(models.Product.category_id == category_id)
        return query.all()


    @staticmethod
    def get_product(db: Session, product_id: str) -> models.Product:
        return db.query(models.Product).filter(models.Product.id == product_id).first()


    @staticmethod
    def search_products(db: Session, query: str) -> List[models.Product]:
        return db.query(models.Product).filter(models.Product.name.ilike(f"%{query}%")).all()
