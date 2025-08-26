import uuid
from __future__ import annotations
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy import (
    String, Integer, Numeric, Boolean, DateTime, ForeignKey,
    JSON, UniqueConstraint, Index, func
)
from datetime import datetime
from decimal import Decimal
from typing import Optional, Dict, Any

from backend.app.core.models.db import Base


class PaymentDB(Base):
    __tablename__ = "payments"
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    yk_payment_id: Mapped[str] = mapped_column(String(64), unique=True, index=True)
    idempotence_key: Mapped[str] = mapped_column(String(64), nullable=False)

    # Пользователь — у тебя, судя по проекту, PK=int.
    # Если у тебя всё-таки UUID: замени Integer -> UUID(as_uuid=True) и тип аннотации.
    user_id: Mapped[Optional[int]] = mapped_column(ForeignKey("users.id"), index=True, nullable=True)
    # user: Mapped["User"] = relationship(back_populates="payments")  # если нужно

    # Деньги
    amount_value: Mapped[Decimal] = mapped_column(Numeric(12, 2), nullable=False)
    amount_currency: Mapped[str] = mapped_column(String(3), nullable=False, default="RUB")

    # Описание
    description: Mapped[Optional[str]] = mapped_column(String(255))

    # Статусы по YooKassa: pending | waiting_for_capture | succeeded | canceled
    status: Mapped[str] = mapped_column(String(32), index=True, nullable=False)

    # Флаги
    paid: Mapped[bool] = mapped_column(Boolean, nullable=False, default=False)
    refundable: Mapped[bool] = mapped_column(Boolean, nullable=False, default=False)

    # Подтверждение
    confirmation_type: Mapped[Optional[str]] = mapped_column(String(32))
    confirmation_url: Mapped[Optional[str]] = mapped_column(String(512))

    # Метод оплаты (например, "bank_card")
    payment_method_type: Mapped[Optional[str]] = mapped_column(String(32))

    # Временные метки
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    captured_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True))
    canceled_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True))
    expires_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True))

    # Полезно хранить всё, что пришло
    metadata: Mapped[Dict[str, Any]] = mapped_column(JSON, default=dict)
    raw: Mapped[Dict[str, Any]] = mapped_column(JSON, default=dict)

    __table_args__ = (
        UniqueConstraint("idempotence_key", name="uq_payments_idempotence_key"),
        Index("ix_payments_user_status_created", "user_id", "status", "created_at"),
    )