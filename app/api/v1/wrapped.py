from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.core.db import get_db
from app.core.deps import get_current_user
from app.models.user import User
from app.schemas.wrapped import WrappedResponse
from app.services.wrapped_service import WrappedService

router = APIRouter(prefix="/clover-wrapped", tags=["Clover Wrapped"])


@router.post("/yearly/{year}", response_model=WrappedResponse)
async def generate_yearly(
    year: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return await WrappedService(db).generate_yearly(current_user.id, year)


@router.post("/monthly/{year}/{month}", response_model=WrappedResponse)
async def generate_monthly(
    year: int,
    month: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return await WrappedService(db).generate_monthly(current_user.id, year, month)


@router.get("", response_model=list[WrappedResponse])
async def get_all(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return await WrappedService(db).get_all(current_user.id)


@router.get("/share/{token}")
async def get_by_share_token(
    token: str,
    db: AsyncSession = Depends(get_db)
):
    wrapped = await WrappedService(db).get_by_share_token(token)
    if not wrapped:
        raise HTTPException(status_code=404, detail="Wrapped not found")
    return wrapped
