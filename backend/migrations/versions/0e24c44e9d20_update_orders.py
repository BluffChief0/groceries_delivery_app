"""update orders

Revision ID: 0e24c44e9d20
Revises: 65b4d8c9356a
Create Date: 2025-08-28 17:23:13.898403

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '0e24c44e9d20'
down_revision: Union[str, Sequence[str], None] = '65b4d8c9356a'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    with op.batch_alter_table("orders") as batch:
        batch.add_column(sa.Column("fio", sa.String(255), nullable=False, server_default="—"))
        batch.add_column(sa.Column("delivery_type", sa.String(50), nullable=False, server_default="courier"))
        batch.add_column(sa.Column("payment_type", sa.String(50), nullable=False, server_default="card"))

    # убираем временные дефолты
    with op.batch_alter_table("orders") as batch:
        batch.alter_column("fio", server_default=None)
        batch.alter_column("delivery_type", server_default=None)
        batch.alter_column("payment_type", server_default=None)


def downgrade() -> None:
    """Downgrade schema."""
    with op.batch_alter_table("orders") as batch:
        batch.drop_column("payment_type")
        batch.drop_column("delivery_type")
        batch.drop_column("fio")
