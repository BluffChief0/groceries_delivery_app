from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers import categories, products, orders, auth
from app.db import engine, Base
import logging

logging.basicConfig(level=logging.DEBUG)

app = FastAPI(title="Groceries Delivery API")

Base.metadata.create_all(bind=engine)

origins = [
    "http://localhost",
    "http://127.0.0.1",
    "http://127.0.0.1:8080",
    "http://158.255.6.22:8080",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(categories.router, prefix='/categories', tags=["categories"])
app.include_router(products.router, prefix='/products', tags=["products"])
app.include_router(orders.router, prefix='/orders', tags=["orders"])
app.include_router(auth.router, prefix='/auth', tags=["auth"])

@app.get("/")
async def root():
    return {"status": "Groceries Delivery API is running!"}

