from sqlalchemy import extract, func

from app.models import Expense

from datetime import datetime

def get_stats_by_category(db, month=None, year=None):
    query = db.query(
        Expense.category,
        func.sum(Expense.amount).label("total")
    )

    if month is not None:
        query = query.filter(extract("month", Expense.date) == month)

    if year is not None:
        query = query.filter(extract("year", Expense.date) == year)

    results = query.group_by(Expense.category).all()

    stats = []

    for category, total in results:
        stats.append({
            "category": category,
            "total": float(total)
        })

    return stats


def get_stats_by_month(db, year=None):
    query = db.query(
        extract("year", Expense.date).label("year"),
        extract("month", Expense.date).label("month"),
        func.sum(Expense.amount).label("total")
    )

    if year is not None:
        query = query.filter(extract("year", Expense.date) == year)

    results = query.group_by(
        extract("year", Expense.date),
        extract("month", Expense.date)
    ).order_by(
        extract("year", Expense.date),
        extract("month", Expense.date)
    ).all()

    stats = []

    for result_year, result_month, total in results:
        stats.append({
            "year": int(result_year),
            "month": int(result_month),
            "total": float(total)
        })

    return stats


def get_stats_by_day(db, month=None, year=None):
    query = db.query(
        Expense.date,
        func.sum(Expense.amount).label("total")
    )

    if month is not None:
        query = query.filter(extract("month", Expense.date) == month)

    if year is not None:
        query = query.filter(extract("year", Expense.date) == year)

    results = query.group_by(Expense.date).order_by(Expense.date).all()

    stats = []

    for date, total in results:
        stats.append({
            "date": date,
            "total": float(total)
        })

    return stats

def get_stats_by_year(db,year=None):
    query = db.query(
        Expense.category,
        func.sum(Expense.amount).label("total")
    )

    if year is None:
        year = datetime.now().year

    query = query.filter(extract("year", Expense.date) == year)

    results = query.group_by(Expense.category).all()

    stats = []

    for category, total in results:
        stats.append({
            "category": category,
            "total": float(total)
        })

    return {
        "year": year,
        "stats": stats
    }

def get_stats_by_range(db, start_date, end_date):
    query = db.query(
        Expense.category,
        func.sum(Expense.amount).label("total")
    ).filter(
        Expense.date >= start_date,
        Expense.date <= end_date
    )

    results = query.group_by(Expense.category).all()

    stats = []

    for category, total in results:
        stats.append({
            "category": category,
            "total": float(total)
        })

    return {
        "start_date": start_date,
        "end_date": end_date,
        "stats": stats
    }