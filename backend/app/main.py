from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.database import Base, engine
from app.routes.categories import router as categories_router
from app.routes.expenses import router as expenses_router
from app.routes.stats import router as stats_router


Base.metadata.create_all(bind=engine)

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]
)

app.include_router(categories_router)
app.include_router(expenses_router)
app.include_router(stats_router)


@app.get("/")
def read_root():
    return {"message": "Budget Tracker API is running"}