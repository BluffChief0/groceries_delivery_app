import uuid
from fastapi_users import schemas


class UserRead(schemas.BaseUser[uuid.UUID]):
    name: str | None = None
    role: str


class UserCreate(schemas.BaseUserCreate):
    name: str | None = None


class UserUpdate(schemas.BaseUserUpdate):
    name: str | None = None
    role: str | None = None