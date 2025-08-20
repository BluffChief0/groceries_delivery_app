from pydantic_settings import BaseSettings, SettingsConfigDict
from pathlib import Path


ENV_FILE = (Path(__file__).parent / ".env").resolve()


class Settings(BaseSettings):
    API_NAME: str = "Groceries Delivery API"
    VERSION: str = "0.1.0"
    DB_PATH: str
    ACCESS_TOKEN_LIFETIME: int

    model_config = SettingsConfigDict(
        env_file=str(ENV_FILE),
        env_file_encoding="utf-8",
        extra="ignore",
    )


settings = Settings()

print(settings.model_dump())