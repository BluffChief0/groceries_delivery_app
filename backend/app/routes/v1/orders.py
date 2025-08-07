from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from backend.app.db import get_db
from backend.app.crud.orders import OrdersCRUD
from backend.app.schemas import OrderCreate, Order

route = APIRouter()

@route.post('/', response_model=Order)
def create_order_endpoint(order: OrderCreate, db: Session = Depends(get_db)):
    return OrdersCRUD.create_order(db, order)

