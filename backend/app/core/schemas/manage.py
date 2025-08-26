from pydantic import BaseModel, Field
from backend.app.core.schemas.schemas import Product

class CategoryCreate(BaseModel):
    name: str = Field(..., min_length=1, max_length=255)
    image_url: str = Field(..., min_length=1, max_length=2048)

class CategoryOut(BaseModel):
    id: str
    name: str
    image_url: str

    class Config:
        from_attributes = True


class ProductCreate(Product):
    pass

class ProductOut(Product):
    id: str

    class Config:
        from_attributes = True