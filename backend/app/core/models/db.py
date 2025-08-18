from collections.abc import AsyncGenerator

from sqlalchemy.orm import declarative_base
from sqlalchemy import event
from sqlalchemy.ext.asyncio import (AsyncSession, 
                                    async_sessionmaker, 
                                    create_async_engine)

from backend.app.core.settings import settings

engine = create_async_engine(settings.DATABASE_URL, connect_args={"check_same_thread": False}, 
                             echo=True, use_insertmanyvalues=False)


@event.listens_for(engine.sync_engine, "connect")
def set_sqlite_pragma(dbapi_connection, connection_record):
    cursor = dbapi_connection.cursor()
    cursor.execute("PRAGMA foreign_keys=ON")
    cursor.close()


AsyncSessionLocal = async_sessionmaker(bind=engine, 
                                       autoflush=True, 
                                       expire_on_commit=False, 
                                       class_=AsyncSession)
Base = declarative_base()


async def get_async_session() -> AsyncGenerator[AsyncSession, None]:
    async with AsyncSessionLocal() as session:
        yield session

