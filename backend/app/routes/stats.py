from datetime import date

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.database import get_db
from app.schemas import StatsByCategoryResponse, StatsByMonthResponse, StatsByDayResponse, StatsByYearResponse, StatsByRangeResponse
from app.services.stats_service import get_stats_by_category, get_stats_by_month, get_stats_by_day, get_stats_by_year, get_stats_by_range


router = APIRouter(
    prefix="/stats",
    tags=["Stats"]
)


@router.get("/by-category", response_model=list[StatsByCategoryResponse])
def read_stats_by_category(
    month: int = None,
    year: int = None,
    db: Session = Depends(get_db)
):
    return get_stats_by_category(db=db, month=month, year=year)


@router.get("/by-month", response_model=list[StatsByMonthResponse])
def read_stats_by_month(
    year: int = None,
    db: Session = Depends(get_db)
):
    return get_stats_by_month(db=db, year=year)


@router.get("/by-day", response_model=list[StatsByDayResponse])
def read_stats_by_day(
    month: int = None,
    year: int = None,
    db: Session = Depends(get_db)
):
    return get_stats_by_day(db=db, month=month, year=year)

@router.get("/by-year", response_model=StatsByYearResponse)
def read_stats_by_year(
    year: int = None,
    db: Session = Depends(get_db)
):
    return get_stats_by_year(db=db, year=year)

@router.get("/by-range", response_model=StatsByRangeResponse)
def read_stats_by_range(
    start_date: date,
    end_date: date,
    db: Session = Depends(get_db)
):
    return get_stats_by_range(db=db, start_date=start_date, end_date=end_date)