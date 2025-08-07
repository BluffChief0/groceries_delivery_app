from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from backend.app.db import get_db
from backend.app.crud.categories import CategoriesCRUD
from backend.app.schemas import Category
from typing import List

route = APIRouter()

@route.get('/', response_model=List[Category])
def list_categories(db: Session = Depends(get_db)):
    return CategoriesCRUD.get_categories(db)

