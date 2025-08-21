import uuid
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy import ForeignKey, DateTime, Integer, String, UniqueConstraint, func
from datetime import datetime, timedelta

from backend.app.core.models.db import Base

class PhoneOTP(Base):
    __tablename__ = "phone_otp"
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    user_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("users.id"), index=True)
    code_hash: Mapped[str] = mapped_column(String(128), nullable=False)
    expires_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), index=True)
    attempts_left: Mapped[int] = mapped_column(Integer, default=5)

    __table_args__ = (UniqueConstraint("user_id", name="uq_phone_otp_user"),)