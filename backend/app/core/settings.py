from pydantic_settings import BaseSettings

DB_PATH = "sqlite+aiosqlite:////root/git/groceries_delivery_app/backend/groceries.db"

class Settings(BaseSettings):
    API_NAME: str = "Groceries Delivery API"
    VERSION: str = "0.1.0"
    DATABASE_URL: str = DB_PATH
    ACCESS_TOKEN_LIFETIME: int = 3600*2
settings = Settings()
