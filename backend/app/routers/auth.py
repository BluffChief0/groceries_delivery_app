from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from ..db import get_db

router = APIRouter()

@router.get('/')
def auth_status(db: Session = Depends(get_db)):
    return {"status": "Auth endpoint (stub)"}

