from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import HTTPException, status
from uuid import UUID
from app.repositories.trip_repository import TripRepository
from app.schemas.trip import TripCreate, TripUpdate


class TripService:
    def __init__(self, db: AsyncSession):
        self.repo = TripRepository(db)

    async def create_trip(self, user_id: UUID, data: TripCreate):
        return await self.repo.create(user_id, data.model_dump())

    async def get_trips(self, user_id: UUID):
        return await self.repo.get_all(user_id)

    async def get_trip(self, trip_id: UUID, user_id: UUID):
        trip = await self.repo.get_by_id(trip_id, user_id)
        if not trip:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Trip not found")
        return trip

    async def update_trip(self, trip_id: UUID, user_id: UUID, data: TripUpdate):
        trip = await self.get_trip(trip_id, user_id)
        return await self.repo.update(trip, data.model_dump(exclude_unset=True))

    async def delete_trip(self, trip_id: UUID, user_id: UUID):
        trip = await self.get_trip(trip_id, user_id)
        await self.repo.delete(trip)
        return {"message": "Trip deleted"}

    async def get_stats(self, user_id: UUID):
        return await self.repo.get_stats(user_id)
