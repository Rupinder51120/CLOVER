from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession
from app.core.db import get_db
from app.core.deps import get_current_user
from app.models.user import User
from app.services.recommendation_service import RecommendationService

router = APIRouter(prefix="/recommendations", tags=["Recommendations"])


@router.get("")
async def get_recommendations(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return await RecommendationService(db).get_recommendations(current_user.id)


@router.get("/hidden-gems")
async def get_hidden_gems(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return await RecommendationService(db).get_hidden_gems(current_user.id)


@router.get("/destinations/search")
async def search_destinations(
    q: str = Query(..., min_length=2),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return await RecommendationService(db).search_destinations(q)
