import hashlib, hmac
import httpx
from datetime import datetime, timedelta

from backend.settings import sms_settings
from backend.settings import settings


async def send_sms_async(text: str, phone: str):
    payload = {
        "apiKey": sms_settings.SMS_API_KEY,
        "sms": [{"channel": "digit", "text": text, "phone": phone}]
    }
    async with httpx.AsyncClient(timeout=10) as client:
        r = await client.post(sms_settings.SMS_URL, json=payload)
        r.raise_for_status()
        return r.json()


def hash_code(code: str) -> str:
    return hmac.new(settings.USER_SECRET.encode(), code.encode(), hashlib.sha256).hexdigest()


def ttl_dt(minutes: int = 10) -> datetime:
    return datetime.utcnow() + timedelta(minutes=minutes)