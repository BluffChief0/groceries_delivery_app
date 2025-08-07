from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from ..db import get_db
from ..crud import get_categories
from ..schemas import Category
from typing import List

router = APIRouter()

@router.get('/', response_model=List[Category])
def list_categories(db: Session = Depends(get_db)):
    return get_categories(db)

