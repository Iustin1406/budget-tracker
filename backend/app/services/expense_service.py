from sqlalchemy import extract, asc, desc

from app.models import Expense

SORT_COLUMNS = {
    "date": Expense.date,
    "amount": Expense.amount,
    "category": Expense.category,
}

SORT_ORDERS = {
    "asc": asc,
    "desc": desc,
}


def create_expense(db, expense_data):
    expense = Expense(
        amount=expense_data.amount,
        description=expense_data.description,
        category=expense_data.category,
        date=expense_data.date
    )

    db.add(expense)
    db.commit()
    db.refresh(expense)

    return expense


def get_expenses(db, category=None, date=None, month=None, year=None, sort_by="date", sort_order="desc"):
    query = db.query(Expense)

    if category is not None:
        query = query.filter(Expense.category == category)

    if date is not None:
        query = query.filter(Expense.date == date)

    if month is not None:
        query = query.filter(extract("month", Expense.date) == month)

    if year is not None:
        query = query.filter(extract("year", Expense.date) == year)

    column = SORT_COLUMNS.get(sort_by, Expense.date)
    order_fn = SORT_ORDERS.get(sort_order, desc)

    expenses = query.order_by(order_fn(column), Expense.id.desc()).all()

    return expenses


def delete_expense(db, expense_id):
    expense = db.query(Expense).filter(Expense.id == expense_id).first()

    if expense is None:
        return False

    db.delete(expense)
    db.commit()

    return True