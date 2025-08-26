from pathlib import Path

from fastapi import APIRouter, Depends, HTTPException, Response
from fastapi.responses import HTMLResponse
from sqlalchemy import select, delete
from sqlalchemy.exc import IntegrityError
from sqlalchemy.ext.asyncio import AsyncSession

from backend.app.core.models.db import get_async_session
from backend.app.core.models.models import Category
from backend.app.core.schemas.manage import CategoryCreate, CategoryOut

CATEGORIES_FS_DIR = Path("backend/app/templates/images/categories").resolve()
manage_categories_router = APIRouter()


@manage_categories_router.get("/categories", response_model=list[CategoryOut])
async def list_categories(db: AsyncSession = Depends(get_async_session)):
    res = await db.execute(select(Category).order_by(Category.name))
    return [CategoryOut.model_validate(row) for row in res.scalars().all()]

@manage_categories_router.post("/categories", response_model=CategoryOut, status_code=201)
async def create_category(payload: CategoryCreate, db: AsyncSession = Depends(get_async_session)):

    exists = await db.execute(select(Category).where(Category.name == payload.name))
    if exists.scalars().first():
        raise HTTPException(status_code=409, detail="Категория с таким названием уже существует")

    obj = Category(name=payload.name, image_url=payload.image_url)
    db.add(obj)
    try:
        await db.commit()
    except IntegrityError as e:
        await db.rollback()
        raise HTTPException(status_code=400, detail="Ошибка сохранения категории") from e
    await db.refresh(obj)
    return CategoryOut.model_validate(obj)

def _fs_path_from_url(image_url: str) -> Path | None:
    """
    Преобразует /categories/images/<file> в абсолютный путь на ФС и
    защищает от path traversal. Вернёт None, если URL пустой/внешний/не наш.
    """
    if not image_url or not image_url.startswith("/categories/images/"):
        return None
    fname = image_url.split("/categories/images/", 1)[1]

    p = (CATEGORIES_FS_DIR / fname).resolve()
    if not str(p).startswith(str(CATEGORIES_FS_DIR)):
        return None
    return p

@manage_categories_router.delete("/categories/{category_id}", status_code=204, response_class=Response)
async def delete_category(category_id: str, db: AsyncSession = Depends(get_async_session)):
    # 1) найдём категорию
    res = await db.execute(select(Category).where(Category.id == category_id))
    obj = res.scalars().first()
    if not obj:
        raise HTTPException(status_code=404, detail="Категория не найдена")

    # 2) удалим запись
    await db.execute(delete(Category).where(Category.id == category_id))
    await db.commit()

    # 3) попробуем удалить файл
    fpath = _fs_path_from_url(obj.image_url or "")
    if fpath and fpath.exists():
        try:
            fpath.unlink()
        except Exception:
            # по желанию — залогировать
            pass

    return Response(status_code=204)