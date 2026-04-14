from datetime import date, datetime
from typing import Optional

from pydantic import BaseModel, Field


class CategoryResponse(BaseModel):
    name: str


class ExpenseCreate(BaseModel):
    amount: float = Field(..., gt=0)
    description: Optional[str] = None
    category: str
    date: date


class ExpenseResponse(BaseModel):
    id: int
    amount: float
    description: Optional[str]
    category: str
    date: date
    created_at: datetime

    class Config:
        from_attributes = True