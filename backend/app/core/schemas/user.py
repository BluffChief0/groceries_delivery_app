import uuid
import re
from pydantic import EmailStr, Field, field_validator
from typing import Optional
from fastapi_users import schemas

PHONE_RE = re.compile(r"^\+?[1-9]\d{7,14}$")

class UserRead(schemas.BaseUser[uuid.UUID]):
    phone_number: Optional[str] = None
    name: Optional[str] = None
    role: str


class UserCreate(schemas.BaseUserCreate):
    # Без права ИЗМЕНЯТЬ РОЛЬ
    email: EmailStr
    password: str
    phone_number: Optional[str] = Field(None, example="+79991234567")
    name: Optional[str] = Field(None, example="Иван Иванов")
    role: Optional[str] = Field(None, example="user")

    @field_validator("phone_number")
    @classmethod
    def _check_phone(cls, v: Optional[str]):
        if v is None:
            return v
        if not PHONE_RE.fullmatch(v):
            raise ValueError("Некорректный телефон (E.164)")
        return v


class UserUpdate(schemas.BaseUserUpdate):
    phone_number: Optional[str] = Field(None, example="+79991234567 или 79991234567")
    name: Optional[str] = Field(None, example="Иван Иванов")