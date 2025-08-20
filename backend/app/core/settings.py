from pydantic_settings import BaseSettings
from dotenv import load_dotenv
import os

load_dotenv()

DB_PATH = os.getenv(str("DB_PATH"))

class Settings(BaseSettings):
    API_NAME: str = "Groceries Delivery API"
    VERSION: str = "0.1.0"
    DATABASE_URL: str = DB_PATH
    ACCESS_TOKEN_LIFETIME: int = 3600*2
settings = Settings()
