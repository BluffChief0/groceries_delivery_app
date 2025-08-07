from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from ..db import get_db
from ..crud import get_products, get_product, search_products
from ..schemas import Product
from typing import List

router = APIRouter()

@router.get('/', response_model=List[Product])
def list_products(category_id: str = None, db: Session = Depends(get_db)):
    return get_products(db, category_id)

@router.get('/search', response_model=List[Product])
def search_products_endpoint(q: str, db: Session = Depends(get_db)):
    return search_products(db, q)

@router.get('/{product_id}', response_model=Product)
def get_product_endpoint(product_id: str, db: Session = Depends(get_db)):
    return get_product(db, product_id)

