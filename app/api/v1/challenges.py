from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from app.core.db import get_db
from app.core.deps import get_current_user
from app.models.user import User
from app.services.challenge_service import ChallengeService

router = APIRouter(prefix="/challenges", tags=["Challenges"])


@router.get("")
async def get_challenges(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return await ChallengeService(db).get_user_challenges(current_user.id)


@router.get("/badges")
async def get_badges(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return await ChallengeService(db).get_badges(current_user.id)
