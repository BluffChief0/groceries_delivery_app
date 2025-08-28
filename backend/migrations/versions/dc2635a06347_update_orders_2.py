"""update orders 2

Revision ID: dc2635a06347
Revises: 0e24c44e9d20
Create Date: 2025-08-28 18:10:18.393068
"""
from typing import Sequence, Union
from alembic import op
import sqlalchemy as sa

# --- обязательные идентификаторы ---
revision: str = "dc2635a06347"
down_revision: Union[str, Sequence[str], None] = "0e24c44e9d20"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None
# -----------------------------------

def upgrade() -> None:
    # 1) Заполнить все NULL
    op.execute(sa.text("UPDATE orders SET status = 'created' WHERE status IS NULL"))

    # 2) Изменить колонку через batch (SQLite-friendly)
    with op.batch_alter_table("orders") as batch:
        batch.alter_column(
            "status",
            existing_type=sa.String(length=10),  # если используешь SAEnum — подставь его сюда
            nullable=False,
            server_default="created",
        )

    # 3) (опционально) убрать дефолт в схеме БД
    with op.batch_alter_table("orders") as batch:
        batch.alter_column("status", server_default=None)


def downgrade() -> None:
    with op.batch_alter_table("orders") as batch:
        batch.alter_column(
            "status",
            existing_type=sa.String(length=10),
            nullable=True,
        )