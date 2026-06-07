from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from uuid import UUID
from app.core.db import get_db
from app.core.deps import get_current_user
from app.models.user import User
from app.schemas.trip import TripCreate, TripUpdate, TripResponse, TripStats
from app.services.trip_service import TripService

router = APIRouter(prefix="/trips", tags=["Trips"])


@router.post("", response_model=TripResponse)
async def create_trip(
    data: TripCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return await TripService(db).create_trip(current_user.id, data)


@router.get("", response_model=list[TripResponse])
async def get_trips(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return await TripService(db).get_trips(current_user.id)


@router.get("/stats/summary", response_model=TripStats)
async def get_stats(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return await TripService(db).get_stats(current_user.id)


@router.get("/{trip_id}", response_model=TripResponse)
async def get_trip(
    trip_id: UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return await TripService(db).get_trip(trip_id, current_user.id)


@router.put("/{trip_id}", response_model=TripResponse)
async def update_trip(
    trip_id: UUID,
    data: TripUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return await TripService(db).update_trip(trip_id, current_user.id, data)


@router.delete("/{trip_id}")
async def delete_trip(
    trip_id: UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return await TripService(db).delete_trip(trip_id, current_user.id)
