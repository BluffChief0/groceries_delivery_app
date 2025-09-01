from pydantic_settings import BaseSettings, SettingsConfigDict
from pathlib import Path


ENV_FILE = (Path(__file__).parent / ".env").resolve()


class Settings(BaseSettings):
    API_NAME: str = "Groceries Delivery API"
    VERSION: str = "0.1.0"
    DB_PATH: str

    ACCESS_TOKEN_LIFETIME: int
    USER_SECRET: str

    model_config = SettingsConfigDict(env_file=str(ENV_FILE),
                                    env_file_encoding="utf-8",
                                    extra="ignore")


class SMSSettings(BaseSettings):
    SMS_API_KEY: str
    SMS_URL: str
    PHONE: str

    model_config = SettingsConfigDict(env_file=str(ENV_FILE),
                                env_file_encoding="utf-8",
                                extra="ignore")


class YMSettings(BaseSettings):
    YM_CLIENT_ID: str
    YM_TOKEN: str

    model_config = SettingsConfigDict(env_file=str(ENV_FILE),
                                env_file_encoding="utf-8",
                                extra="ignore")
    

class YKSettings(BaseSettings):
    YK_SHOP_ID: str
    YK_SECRET_ID: str
    AUTHORIZATION_HEADER: str

    model_config = SettingsConfigDict(env_file=str(ENV_FILE),
                                env_file_encoding="utf-8",
                                extra="ignore")
    

class BotSettings(BaseSettings):
    BOT_TOKEN: str
    CHAT_ID: str
    model_config = SettingsConfigDict(env_file=str(ENV_FILE),
                                    env_file_encoding="utf-8",
                                    extra="ignore")


settings = Settings()

sms_settings = SMSSettings()

ym_settings = YMSettings()
yk_settings = YKSettings()

bot_settings = BotSettings()