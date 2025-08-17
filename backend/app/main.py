from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from backend.app.api.v1 import categories, products, orders
from backend.app.api.v1.auth import (auth_router, register_router, users_router, 
                                     current_active_user, current_active_superuser)
from backend.app.core.models.db import create_async_engine, engine, Base
import logging

from backend.app.core.settings import settings

logging.basicConfig(level=logging.DEBUG)

app = FastAPI(title=settings.API_NAME,
              version=settings.VERSION,
              debug=True)

@app.on_event("startup")
async def on_startup():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

origins = [
    "http://localhost",
    "http://127.0.0.1",
    "http://127.0.0.1:8080",
    "http://158.255.6.22:8080",
    "http://127.0.0.1:22822",
    "http://158.255.5.22:22822"
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.mount(
    "/categories/images",
    StaticFiles(directory="backend/app/templates/categories/img"),
    name="category_images"
)

# app.include_router(auth.route, prefix='/auth', tags=["auth"])
app.include_router(register_router, prefix="/auth", tags=["auth"])
app.include_router(auth_router,     prefix="/auth/jwt", tags=["auth"])
app.include_router(users_router,    prefix="/users",     tags=["users"])


app.include_router(categories.route, prefix='/categories', tags=["categories"])
app.include_router(products.route, prefix='/products', tags=["products"])
app.include_router(orders.route, prefix='/orders', tags=["orders"])

@app.get("/")
async def root():
    return {"status": f"{settings.API_NAME} is running!"}