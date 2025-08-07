from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from backend.app.db import get_db

route = APIRouter()

@route.get('/')
def auth_status(db: Session = Depends(get_db)):
    return {"status": "Auth endpoint (stub)"}

