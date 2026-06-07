from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from uuid import UUID
from app.core.db import get_db
from app.core.deps import get_current_user
from app.models.user import User
from app.schemas.itinerary import ItineraryRequest, ItineraryResponse
from app.services.itinerary_service import ItineraryService

router = APIRouter(prefix="/itinerary", tags=["Itinerary"])


@router.post("/generate", response_model=ItineraryResponse)
async def generate(
    data: ItineraryRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return await ItineraryService(db).generate(current_user.id, data)


@router.get("", response_model=list[ItineraryResponse])
async def get_all(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return await ItineraryService(db).get_all(current_user.id)


@router.get("/{itinerary_id}", response_model=ItineraryResponse)
async def get_by_id(
    itinerary_id: UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return await ItineraryService(db).get_by_id(itinerary_id, current_user.id)


@router.delete("/{itinerary_id}")
async def delete(
    itinerary_id: UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return await ItineraryService(db).delete(itinerary_id, current_user.id)
