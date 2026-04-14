from fastapi import APIRouter

from app.services.category_service import get_categories


router = APIRouter(
    prefix="/categories",
    tags=["Categories"]
)


@router.get("")
def read_categories():
    return get_categories()