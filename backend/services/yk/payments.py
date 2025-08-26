import json
from uuid import uuid4
import requests
import time
import asyncio
import functools

from yookassa import Payment, Configuration
from backend.settings import yk_settings


authorization = yk_settings.AUTHORIZATION_HEADER

Configuration.account_id = yk_settings.YK_SHOP_ID
Configuration.secret_key = yk_settings.YK_SECRET_ID


def pay(value, description):
    payment = Payment.create({
        "amount": {
            "value": value,
            "currency": "RUB"
        },
        "payment_method_data": {
            "type": "bank_card",
        },
        "confirmation": {
            "type": "redirect",
            "return_url": "https://yandex.ru"
        },
        "capture": True,
        "description": description
    }, idempotency_key=uuid4)
	
    return json.loads(payment.json())


async def _get_payment(yk_id: str) -> dict:
    loop = asyncio.get_running_loop()
    obj = await loop.run_in_executor(None, functools.partial(Payment.find_one, yk_id))
    return json.loads(obj.json())


async def check_payment(payment_id):
	payment = json.loads((Payment.find_one(payment_id)).json())
	while payment['status'] == 'pending':
		payment = json.loads((Payment.find_one(payment_id)).json())
		await asyncio.sleep(3)

	if payment['status']=='succeeded':
		print("SUCCSESS RETURN")
		print(payment)
		return True
	else:
		print("BAD RETURN")
		print(payment)
		return False
	
if __name__ == "__main__":

    payment_data = pay(value="2", description="Заказ")
    payment_id = payment_data["id"]
    payment_url = (payment_data["confirmation"])["confirmation_url"]
    print(f"PAYMENT URL: {payment_url}", 
        f"PAYMENT DATA: {payment_data}", 
        f"PAYMENT ID: {payment_id}", sep="\n\n")
	
    asyncio.run(check_payment(payment_id=payment_id))