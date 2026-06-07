from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from uuid import UUID
from app.models.clover_dna import CloverDNA


class CloverDNARepository:
    def __init__(self, db: AsyncSession):
        self.db = db

    async def get_by_user(self, user_id: UUID) -> CloverDNA | None:
        result = await self.db.execute(
            select(CloverDNA).where(CloverDNA.user_id == user_id)
        )
        return result.scalar_one_or_none()

    async def create(self, user_id: UUID) -> CloverDNA:
        dna = CloverDNA(user_id=user_id)
        self.db.add(dna)
        await self.db.flush()
        return dna

    async def update(self, dna: CloverDNA, data: dict) -> CloverDNA:
        for key, value in data.items():
            setattr(dna, key, value)
        await self.db.flush()
        return dna
