import asyncio
import contextlib
import logging
from typing import Optional

from aiogram import Bot, Dispatcher
from aiogram.client.default import DefaultBotProperties
from aiogram.filters import CommandStart
from aiogram.types import Message
from sqlalchemy import select, func
from sqlalchemy.orm import selectinload  # <-- добавили

# === твои импорты ===
from backend.settings import bot_settings
from backend.app.core.models.db import AsyncSessionLocal  # ВАЖНО: именно factory!
from backend.app.core.models.models import Order, OrderItem  # <-- добавили OrderItem

from datetime import datetime, timezone
from zoneinfo import ZoneInfo
# ====== базовая настройка логов ======
logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s: %(message)s")
log = logging.getLogger("bot")

# ====== конфиг из настроек ======
BOT_TOKEN = bot_settings.BOT_TOKEN
CHAT_ID   = int(bot_settings.CHAT_ID)

# ====== инициализация бота и диспетчера (aiogram 3.7+) ======
bot = Bot(
    token=BOT_TOKEN,
    default=DefaultBotProperties(parse_mode="HTML")  # можно добавить: disable_web_page_preview=True
)
dp = Dispatcher()

# ====== форматирование уведомления ======

MSK = ZoneInfo("Europe/Moscow")

def _parse_dt(value) -> datetime | None:
    """
    Приводим created_at/delivery_time к datetime.
    Поддерживаем: datetime (aware/naive), ISO-строки, строки без TZ.
    """
    if value is None:
        return None
    if isinstance(value, datetime):
        return value
    # Пытаемся распарсить строку (SQLite может хранить 'YYYY-MM-DD HH:MM:SS[.ffffff]')
    s = str(value).strip()
    # заменим 'T' на пробел для совместимости
    s = s.replace("T", " ")
    # убираем 'Z' => UTC
    if s.endswith("Z"):
        s = s[:-1]
        try:
            dt = datetime.fromisoformat(s)
            return dt.replace(tzinfo=timezone.utc)
        except Exception:
            pass
    # пробуем ISO без Z/таймзоны
    try:
        return datetime.fromisoformat(s)
    except Exception:
        # fallback: без микросекунд
        try:
            return datetime.strptime(s, "%Y-%m-%d %H:%M:%S")
        except Exception:
            # ещё один вариант с микросекундами
            try:
                return datetime.strptime(s, "%Y-%m-%d %H:%M:%S.%f")
            except Exception:
                return None

def _to_msk(dt: datetime | None) -> str:
    """
    Конвертируем в МСК и красиво форматируем.
    Если dt naive — считаем, что это UTC.
    """
    if dt is None:
        return "—"
    if dt.tzinfo is None:
        dt = dt.replace(tzinfo=timezone.utc)
    try:
        return dt.astimezone(MSK).strftime("%Y-%m-%d %H:%M:%S")
    except Exception:
        return str(dt)

def fmt_order(o: Order) -> str:
    # статус: Enum -> .value, строка -> как есть
    st = getattr(o, "status", None)
    status_text = getattr(st, "value", st) if st is not None else "—"

    # время по МСК
    created_raw = getattr(o, "created_at", None)
    created_dt = _parse_dt(created_raw)
    created_text = _to_msk(created_dt)

    # если нужно — тоже в МСК
    delivery_raw = getattr(o, "delivery_time", None)
    delivery_dt = _parse_dt(delivery_raw)
    delivery_text = _to_msk(delivery_dt)

    # состав заказа (твоя связь называется items)
    lines = []
    for it in (getattr(o, "items", None) or []):
        prod_obj = getattr(it, "product", None)
        name = getattr(prod_obj, "name", None) or getattr(it, "product_id", "?")
        amount = getattr(it, "amount", 0)
        price  = getattr(it, "price", 0)
        lines.append(f"- {name} x{amount} ({price} ₽)")
    items_text = "\n".join(lines) if lines else "—"

    return (
        f"<b>Новый заказ</b> #{o.id}\n"
        f"Статус: {status_text}\n"
        f"ФИО: {getattr(o, 'fio', None) or '—'}\n"
        f"Телефон: {getattr(o, 'user_phone', None) or '—'}\n\n"
        f"Состав заказа:\n{items_text}\n"
        f"Доставка: {getattr(o, 'delivery_type', '—')} — {getattr(o, 'delivery_address', '—')}\n"
        f"Сумма: {getattr(o, 'total_price', '—')} ₽\n"
        f"Время создания заказа: {created_text}\n"
        f"Время доставки: {delivery_text}\n"
        f"Способ оплаты: {getattr(o, 'payment_type', '—')}\n"
        f"Комментарий: {getattr(o, 'comment', None) or '—'}\n"
    )

# /start — опционально
@dp.message(CommandStart())
async def start(m: Message):
    await m.answer("Я слежу за новыми заказами ✅")

# ====== чекер новых заказов ======
async def orders_checker(bot: Bot, poll_interval: float = 2.0):
    """
    Периодически проверяет таблицу orders на появление записей позже last_seen_ts.
    На старте берёт last_seen_ts = MAX(created_at), чтобы не слать историю.
    """
    last_seen_ts: Optional[object] = None

    # инициализируем watermark
    async with AsyncSessionLocal() as session:
        res = await session.execute(select(func.max(Order.created_at)))
        last_seen_ts = res.scalar()
        log.info("checker стартовал, last_seen_ts=%s", last_seen_ts)

    while True:
        try:
            async with AsyncSessionLocal() as session:
                # запросим новые заказы
                if last_seen_ts is None:
                    res = await session.execute(select(func.max(Order.created_at)))
                    last_seen_ts = res.scalar()

                q = (
                    select(Order)
                    .options(  # <-- подгружаем order_items и product, чтобы fmt_order видел имена
                        selectinload(Order.items).selectinload(OrderItem.product)
                    )
                    .where(Order.created_at > last_seen_ts)  # строго позже
                    .order_by(Order.created_at.asc())
                    .limit(200)
                )
                res = await session.execute(q)
                new_orders = res.scalars().all()

                if not new_orders:
                    await asyncio.sleep(poll_interval)
                    continue

                # шлём по одному и двигаем watermark
                for order in new_orders:
                    try:
                        await bot.send_message(
                            CHAT_ID,
                            fmt_order(order),
                            disable_web_page_preview=True
                        )
                    except Exception as te:
                        log.error("Ошибка отправки в Telegram: %s", te)

                    last_seen_ts = order.created_at

        except Exception as e:
            log.error("Ошибка в checker: %s", e)
            await asyncio.sleep(2.0)  # лёгкий бэк-офф при проблемах

# ====== точка входа ======
async def main():
    checker_task = asyncio.create_task(orders_checker(bot))
    try:
        await dp.start_polling(bot)
    finally:
        checker_task.cancel()
        with contextlib.suppress(asyncio.CancelledError):
            await checker_task
        await bot.session.close()

if __name__ == "__main__":
    asyncio.run(main())
