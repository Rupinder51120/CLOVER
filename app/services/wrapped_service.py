import secrets
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from uuid import UUID
from app.models.wrapped import CloverWrapped
from app.models.trip import CloverTrip
from app.repositories.clover_dna_repository import CloverDNARepository
from datetime import datetime


class WrappedService:
    def __init__(self, db: AsyncSession):
        self.db = db
        self.dna_repo = CloverDNARepository(db)

    async def generate_yearly(self, user_id: UUID, year: int) -> CloverWrapped:
        existing = await self.db.execute(
            select(CloverWrapped).where(
                CloverWrapped.user_id == user_id,
                CloverWrapped.year == year,
                CloverWrapped.month == None
            )
        )
        wrapped = existing.scalar_one_or_none()

        stats = await self._compute_stats(user_id, year, None)
        share_token = secrets.token_urlsafe(16)

        if wrapped:
            wrapped.stats = stats
            wrapped.share_token = share_token
            await self.db.flush()
            return wrapped

        wrapped = CloverWrapped(
            user_id=user_id,
            year=year,
            month=None,
            stats=stats,
            share_token=share_token
        )
        self.db.add(wrapped)
        await self.db.flush()
        return wrapped

    async def generate_monthly(self, user_id: UUID, year: int, month: int) -> CloverWrapped:
        existing = await self.db.execute(
            select(CloverWrapped).where(
                CloverWrapped.user_id == user_id,
                CloverWrapped.year == year,
                CloverWrapped.month == month
            )
        )
        wrapped = existing.scalar_one_or_none()

        stats = await self._compute_stats(user_id, year, month)
        share_token = secrets.token_urlsafe(16)

        if wrapped:
            wrapped.stats = stats
            wrapped.share_token = share_token
            await self.db.flush()
            return wrapped

        wrapped = CloverWrapped(
            user_id=user_id,
            year=year,
            month=month,
            stats=stats,
            share_token=share_token
        )
        self.db.add(wrapped)
        await self.db.flush()
        return wrapped

    async def _compute_stats(self, user_id: UUID, year: int, month: int | None) -> dict:
        result = await self.db.execute(
            select(CloverTrip).where(
                CloverTrip.user_id == user_id,
                CloverTrip.is_deleted == False
            )
        )
        all_trips = result.scalars().all()

        trips = []
        for t in all_trips:
            trip_year = t.start_date.year
            trip_month = t.start_date.month
            if month is None and trip_year == year:
                trips.append(t)
            elif month is not None and trip_year == year and trip_month == month:
                trips.append(t)

        if not trips:
            return {
                "total_trips": 0,
                "cities_visited": [],
                "countries_visited": [],
                "total_spend": 0,
                "favorite_trip_type": None,
                "avg_rating": 0,
                "longest_trip_days": 0,
                "most_visited_country": None,
                "personality_type": None,
                "year": year,
                "month": month
            }

        cities = list(set(t.city for t in trips))
        countries = list(set(t.country for t in trips))
        total_spend = sum(t.total_cost or 0 for t in trips)
        ratings = [t.rating for t in trips if t.rating]
        trip_types = [t.trip_type.value for t in trips]
        durations = [(t.end_date - t.start_date).days for t in trips]

        dna = await self.dna_repo.get_by_user(user_id)

        return {
            "total_trips": len(trips),
            "cities_visited": cities,
            "countries_visited": countries,
            "total_cities": len(cities),
            "total_countries": len(countries),
            "total_spend": total_spend,
            "favorite_trip_type": max(set(trip_types), key=trip_types.count) if trip_types else None,
            "avg_rating": round(sum(ratings) / len(ratings), 1) if ratings else 0,
            "longest_trip_days": max(durations) if durations else 0,
            "most_visited_country": max(set(countries), key=countries.count) if countries else None,
            "personality_type": dna.personality_type if dna else None,
            "year": year,
            "month": month
        }

    async def get_by_share_token(self, token: str) -> CloverWrapped:
        result = await self.db.execute(
            select(CloverWrapped).where(CloverWrapped.share_token == token)
        )
        return result.scalar_one_or_none()

    async def get_all(self, user_id: UUID) -> list[CloverWrapped]:
        result = await self.db.execute(
            select(CloverWrapped).where(CloverWrapped.user_id == user_id)
        )
        return result.scalars().all()
