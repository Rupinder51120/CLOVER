from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
from uuid import UUID
from app.models.trip import CloverTrip


class TripRepository:
    def __init__(self, db: AsyncSession):
        self.db = db

    async def create(self, user_id: UUID, data: dict) -> CloverTrip:
        trip = CloverTrip(user_id=user_id, **data)
        self.db.add(trip)
        await self.db.flush()
        return trip

    async def get_by_id(self, trip_id: UUID, user_id: UUID) -> CloverTrip | None:
        result = await self.db.execute(
            select(CloverTrip).where(
                CloverTrip.id == trip_id,
                CloverTrip.user_id == user_id,
                CloverTrip.is_deleted == False
            )
        )
        return result.scalar_one_or_none()

    async def get_all(self, user_id: UUID) -> list[CloverTrip]:
        result = await self.db.execute(
            select(CloverTrip).where(
                CloverTrip.user_id == user_id,
                CloverTrip.is_deleted == False
            ).order_by(CloverTrip.start_date.desc())
        )
        return result.scalars().all()

    async def update(self, trip: CloverTrip, data: dict) -> CloverTrip:
        for key, value in data.items():
            if value is not None:
                setattr(trip, key, value)
        await self.db.flush()
        return trip

    async def delete(self, trip: CloverTrip) -> None:
        trip.is_deleted = True
        await self.db.flush()

    async def get_stats(self, user_id: UUID) -> dict:
        result = await self.db.execute(
            select(CloverTrip).where(
                CloverTrip.user_id == user_id,
                CloverTrip.is_deleted == False
            )
        )
        trips = result.scalars().all()

        if not trips:
            return {
                "total_trips": 0,
                "total_countries": 0,
                "total_cities": 0,
                "total_spend": 0.0,
                "avg_rating": 0.0,
                "most_visited_country": None,
                "favorite_trip_type": None
            }

        countries = [t.country for t in trips]
        cities = [t.city for t in trips]
        spend = sum(t.total_cost or 0 for t in trips)
        ratings = [t.rating for t in trips if t.rating]
        trip_types = [t.trip_type for t in trips]

        return {
            "total_trips": len(trips),
            "total_countries": len(set(countries)),
            "total_cities": len(set(cities)),
            "total_spend": spend,
            "avg_rating": sum(ratings) / len(ratings) if ratings else 0.0,
            "most_visited_country": max(set(countries), key=countries.count),
            "favorite_trip_type": max(set(trip_types), key=trip_types.count).value
        }
