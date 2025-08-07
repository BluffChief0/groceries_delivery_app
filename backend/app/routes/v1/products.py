from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from backend.app.db import get_db
from backend.app.crud.products import ProductsCRUD
from backend.app.schemas import Product
from typing import List

route = APIRouter()

@route.get('/', response_model=List[Product])
def list_products(category_id: str = None, db: Session = Depends(get_db)):
    return ProductsCRUD.get_products(db, category_id)

@route.get('/search', response_model=List[Product])
def search_products_endpoint(q: str, db: Session = Depends(get_db)):
    return ProductsCRUD.search_products(db, q)

@route.get('/{product_id}', response_model=Product)
def get_product_endpoint(product_id: str, db: Session = Depends(get_db)):
    return ProductsCRUD.get_product(db, product_id)

