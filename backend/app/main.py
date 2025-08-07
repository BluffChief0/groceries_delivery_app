from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routes.v1 import categories, products, orders, auth
from app.db import engine, Base
import logging

from settings import VERSION, API_NAME

logging.basicConfig(level=logging.DEBUG)

app = FastAPI(title=API_NAME,
              version=VERSION,
              debug=True)

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

app.include_router(categories.route, prefix='/categories', tags=["categories"])
app.include_router(products.route, prefix='/products', tags=["products"])
app.include_router(orders.route, prefix='/orders', tags=["orders"])
app.include_router(auth.route, prefix='/auth', tags=["auth"])

@app.get("/")
async def root():
    return {"status": f"{API_NAME} is running!"}

