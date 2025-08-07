from sqlalchemy.orm import Session
from backend.app import models
from typing import List

class CategoriesCRUD:

    @staticmethod
    def get_categories(db: Session) -> List[models.Category]:
        return db.query(models.Category).all()