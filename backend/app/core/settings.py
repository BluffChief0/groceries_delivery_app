from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    API_NAME: str = "Groceries Delivery API"
    VERSION: str = "0.1.0"
    DATABASE_URL: str = "sqlite+aiosqlite:///./groceries.db"
    ACCESS_TOKEN_LIFETIME: int = 3600*2
settings = Settings()
