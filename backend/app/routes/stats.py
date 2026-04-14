from fastapi import APIRouter


router = APIRouter(
    prefix="/stats",
    tags=["Stats"]
)


@router.get("/by-category")
def get_stats_by_category():
    return {"message": "Not implemented yet"}


@router.get("/by-month")
def get_stats_by_month():
    return {"message": "Not implemented yet"}


@router.get("/by-day")
def get_stats_by_day():
    return {"message": "Not implemented yet"}