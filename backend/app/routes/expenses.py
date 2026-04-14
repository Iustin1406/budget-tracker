from datetime import date as date_type

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.database import get_db
from app.schemas import ExpenseCreate, ExpenseResponse
from app.services.category_service import is_valid_category
from app.services.expense_service import create_expense, get_expenses, delete_expense


router = APIRouter(
    prefix="/expenses",
    tags=["Expenses"]
)


@router.post("", response_model=ExpenseResponse)
def add_expense(expense: ExpenseCreate, db: Session = Depends(get_db)):
    if not is_valid_category(expense.category):
        raise HTTPException(status_code=400, detail="Invalid category")

    return create_expense(db, expense)


@router.get("", response_model=list[ExpenseResponse])
def read_expenses(
    category: str = None,
    date: date_type = None,
    month: int = None,
    year: int = None,
    db: Session = Depends(get_db)
):
    return get_expenses(
        db=db,
        category=category,
        date=date,
        month=month,
        year=year
    )


@router.delete("/{expense_id}")
def remove_expense(expense_id: int, db: Session = Depends(get_db)):
    deleted = delete_expense(db, expense_id)

    if not deleted:
        raise HTTPException(status_code=404, detail="Expense not found")

    return {"message": "Expense deleted"}