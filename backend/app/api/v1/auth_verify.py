import random
from datetime import datetime
from fastapi import APIRouter, Depends, BackgroundTasks, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, insert, update
from sqlalchemy.dialects.sqlite import insert as sqlite_insert

from backend.app.core.models.db import get_async_session
from backend.app.core.models.models import User
from backend.app.sms.main import send_sms_async, hash_code, ttl_dt
from backend.app.api.v1.auth import current_active_user
from backend.app.core.models.sms import PhoneOTP
from backend.app.core.schemas.sms import VerifyBody

auth_verify_router = APIRouter(prefix="/auth/phone", tags=["phone-verify"])

@auth_verify_router.post("/request")
async def request_phone_code(
    background: BackgroundTasks,
    user: User = Depends(current_active_user),
    session: AsyncSession = Depends(get_async_session),
):
    if not user.phone_number:
        raise HTTPException(status_code=400, detail="У пользователя не указан phone_number")

    code = f"{random.randint(0, 999999):06d}"
    code_h = hash_code(code)

    stmt = sqlite_insert(PhoneOTP).values(
        user_id=user.id,
        code_hash=code_h,
        expires_at=ttl_dt(10),
        attempts_left=5,
    )
    stmt = stmt.on_conflict_do_update(
        index_elements=[PhoneOTP.user_id],  # UNIQUE(user_id)
        set_={"code_hash": code_h, "expires_at": ttl_dt(10), "attempts_left": 5},
    )
    await session.execute(stmt)
    await session.commit()

    background.add_task(send_sms_async, f"Ваш код: {code}", user.phone_number)
    return {"detail": "Код отправлен"}


@auth_verify_router.post("/verify")
async def verify_phone_code(
    body: VerifyBody,
    user: User = Depends(current_active_user),
    session: AsyncSession = Depends(get_async_session),
):
    code = body.code

    q = await session.execute(select(PhoneOTP).where(PhoneOTP.user_id == user.id))
    otp = q.scalar_one_or_none()
    if not otp:
        raise HTTPException(status_code=400, detail="Код не запрошен")

    if otp.expires_at < datetime.utcnow():
        raise HTTPException(status_code=400, detail="Код просрочен")

    if otp.attempts_left <= 0:
        raise HTTPException(status_code=400, detail="Превышено количество попыток")

    if otp.code_hash != hash_code(code):
        await session.execute(
            update(PhoneOTP)
            .where(PhoneOTP.id == otp.id)
            .values(attempts_left=otp.attempts_left - 1)
        )
        await session.commit()
        raise HTTPException(status_code=400, detail="Неверный код")

    # подтверждаем пользователя
    await session.execute(
        update(User)
        .where(User.id == user.id)
        .values(is_verified=True)
    )

    await session.delete(otp)
    await session.commit()

    return {"detail": "Телефон подтвержден"}