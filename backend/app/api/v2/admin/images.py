from pathlib import Path
from fastapi import APIRouter, UploadFile, File, HTTPException, Form
from fastapi.responses import JSONResponse

images = APIRouter(tags=["files"])

CATEGORIES_DIR = Path("backend/app/templates/images/categories")
PRODUCTS_DIR   = Path("backend/app/templates/images/products")

ALLOWED_EXT = {"png", "jpg", "jpeg", "webp", "gif"}

@images.post("/categories/upload")
async def upload_category_image(
    file: UploadFile = File(...),
    category_name: str = Form(...)
):
    if not (file.content_type or "").startswith("image/"):
        raise HTTPException(415, detail="Ожидается изображение (image/*)")

    ext = file.filename.rsplit(".", 1)[-1].lower() if "." in file.filename else "png"
    if ext == "jpeg": ext = "jpg"
    if ext not in ALLOWED_EXT:
        raise HTTPException(415, detail=f"Разрешены: {', '.join(ALLOWED_EXT)}")

    content = await file.read()
    if not content:
        raise HTTPException(400, detail="Пустой файл")

    # делаем имя файла = категория (латиница, без пробелов)
    safe_name = category_name.lower().replace(" ", "_")
    fname = f"{safe_name}.{ext}"

    (CATEGORIES_DIR / fname).write_bytes(content)

    return JSONResponse({"url": f"/categories/images/{fname}", "filename": fname})


@images.post("/products/upload")
async def upload_product_image(file: UploadFile = File(...), name: str = Form(...)):
    # ... проверка типа ...
    ext = file.filename.rsplit(".", 1)[-1].lower()
    safe_name = name.lower().replace(" ", "_")
    fname = f"{safe_name}.{ext}"
    dest = PRODUCTS_DIR / fname
    dest.write_bytes(await file.read())
    return {"url": f"/products/images/{fname}", "filename": fname}