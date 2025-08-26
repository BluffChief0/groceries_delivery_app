import json
import functools
import asyncio
from uuid import uuid4
from decimal import Decimal, ROUND_HALF_UP

from yookassa import Payment, Configuration
from backend.settings import yk_settings

Configuration.account_id = yk_settings.YK_SECRET_ID
Configuration.secret_key = yk_settings.YK_SHOP_ID


def _money(value: str | int | float | Decimal) -> str:
    """Форматирование суммы как '0.00' (требование YooKassa)."""
    d = Decimal(str(value)).quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)
    return f"{d:.2f}"


async def create_payment(value, description: str, return_url: str = "https://yandex.ru") -> dict:
    """
    Асинхронно создаёт платёж через синхронный SDK.
    Возвращает dict ответа YooKassa.
    """
    payload = {
        "amount": {"value": _money(value), "currency": "RUB"},
        "payment_method_data": {"type": "bank_card"},
        "confirmation": {"type": "redirect", "return_url": return_url},
        "capture": True,
        "description": description,
    }
    idempotence_key = str(uuid4())

    loop = asyncio.get_running_loop()
    payment_obj = await loop.run_in_executor(
        None,
        functools.partial(Payment.create, payload, idempotence_key)
    )
    return json.loads(payment_obj.json())


async def get_payment(payment_id: str) -> dict:
    """Асинхронно получает платёж по id, оборачивая синхронный SDK."""
    loop = asyncio.get_running_loop()
    payment_obj = await loop.run_in_executor(None, functools.partial(Payment.find_one, payment_id))
    return json.loads(payment_obj.json())


async def wait_until_final(payment_id: str, *, poll_interval: float = 3.0, timeout: float = 300.0) -> dict:
    """
    Ожидает конечного статуса платежа.
    Конечные: 'succeeded' или 'canceled'.
    Промежуточные: 'pending', 'waiting_for_capture'.
    Бросает asyncio.TimeoutError по истечении timeout.
    Возвращает финальный ответ платежа (dict).
    """
    end = asyncio.get_event_loop().time() + timeout
    while True:
        payment = await get_payment(payment_id)
        status = payment.get("status")

        if status in ("succeeded", "canceled"):
            return payment

        # Всё ещё не финальный — ждём, но следим за таймаутом
        if asyncio.get_event_loop().time() >= end:
            raise asyncio.TimeoutError(f"Ожидание платежа {payment_id} превысило {timeout} сек")

        await asyncio.sleep(poll_interval)


async def main():
    payment_data = await create_payment(value="2", description="Заказ №34")
    payment_id = payment_data["id"]
    payment_url = payment_data.get("confirmation", {}).get("confirmation_url")

    print("PAYMENT URL:", payment_url)
    print("PAYMENT ID:", payment_id)

    # Ждём финала (лучше — вебхуки, см. ниже)
    try:
        final = await wait_until_final(payment_id, poll_interval=3, timeout=300)
        print("FINAL STATUS:", final.get("status"))
        print("FINAL DATA:", final)
    except asyncio.TimeoutError as e:
        print("TIMEOUT:", e)

if __name__ == "__main__":
    asyncio.run(main())