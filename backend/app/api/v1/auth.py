import uuid
from typing import AsyncGenerator, Optional

from fastapi import APIRouter, Depends, Request
from fastapi_users import FastAPIUsers, BaseUserManager, UUIDIDMixin
from fastapi_users.authentication import AuthenticationBackend, BearerTransport, JWTStrategy
from fastapi_users.db import SQLAlchemyUserDatabase
from sqlalchemy.ext.asyncio import AsyncSession

from backend.app.core.models.models import User  # , OAuthAccount (если нужен OAuth)
from backend.app.core.models.db import get_async_session
from backend.app.core.schemas.user import UserCreate, UserRead, UserUpdate
from backend.settings import settings


class UserManager(UUIDIDMixin, BaseUserManager[User, uuid.UUID]):
    reset_password_token_secret = settings.USER_SECRET
    verification_token_secret = settings.USER_SECRET


    async def on_after_register(self, user: User, request: Optional[Request] = None):
        pass


    async def on_after_forgot_password(self, user: User, token: str, request: Optional[Request] = None):
        return "Забыли пароль"


async def get_user_db(session: AsyncSession = Depends(get_async_session)) -> AsyncGenerator:
    # Если не нужен OAuth:
    yield SQLAlchemyUserDatabase(session, User)
    # Если нужен OAuth: yield SQLAlchemyUserDatabase(session, User, OAuthAccount)


async def get_user_manager(user_db: SQLAlchemyUserDatabase = Depends(get_user_db)):
    yield UserManager(user_db)


bearer_transport = BearerTransport(tokenUrl="/auth/jwt/login")  # ведущий слэш не обязателен, но чаще так


def get_jwt_strategy() -> JWTStrategy[User, uuid.UUID]:
    return JWTStrategy(
        secret=settings.USER_SECRET,
        lifetime_seconds=int(settings.ACCESS_TOKEN_LIFETIME),
    )


auth_backend = AuthenticationBackend(
    name="jwt",
    transport=bearer_transport,
    get_strategy=get_jwt_strategy,
)

fastapi_users = FastAPIUsers[User, uuid.UUID](get_user_manager, [auth_backend])

current_active_user = fastapi_users.current_user(active=True)
current_active_superuser = fastapi_users.current_user(active=True, superuser=True)

route = APIRouter()
auth_router = fastapi_users.get_auth_router(auth_backend)
register_router = fastapi_users.get_register_router(UserRead, UserCreate)
users_router = fastapi_users.get_users_router(UserRead, UserUpdate)