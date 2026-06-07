from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from uuid import UUID
from app.models.destination import CloverDestination


class DestinationRepository:
    def __init__(self, db: AsyncSession):
        self.db = db

    async def get_all(self) -> list[CloverDestination]:
        result = await self.db.execute(select(CloverDestination))
        return result.scalars().all()

    async def get_by_id(self, dest_id: UUID) -> CloverDestination | None:
        result = await self.db.execute(
            select(CloverDestination).where(CloverDestination.id == dest_id)
        )
        return result.scalar_one_or_none()

    async def get_hidden_gems(self, threshold: int = 5) -> list[CloverDestination]:
        result = await self.db.execute(
            select(CloverDestination).where(
                CloverDestination.visitor_count < threshold
            )
        )
        return result.scalars().all()

    async def search(self, query: str) -> list[CloverDestination]:
        result = await self.db.execute(
            select(CloverDestination).where(
                CloverDestination.name.ilike(f"%{query}%") |
                CloverDestination.city.ilike(f"%{query}%") |
                CloverDestination.country.ilike(f"%{query}%")
            )
        )
        return result.scalars().all()
