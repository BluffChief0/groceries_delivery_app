from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from ..db import get_db
from ..crud import create_order
from ..schemas import OrderCreate, Order

router = APIRouter()

@router.post('/', response_model=Order)
def create_order_endpoint(order: OrderCreate, db: Session = Depends(get_db)):
    return create_order(db, order)

