from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from app.core.db import get_db
from app.core.deps import get_current_user
from app.models.user import User
from app.schemas.clover_dna import CloverDNAResponse
from app.services.clover_dna_service import CloverDNAService

router = APIRouter(prefix="/clover-dna", tags=["Clover DNA"])


@router.get("", response_model=CloverDNAResponse)
async def get_dna(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return await CloverDNAService(db).get_dna(current_user.id)


@router.post("/recalculate", response_model=CloverDNAResponse)
async def recalculate(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return await CloverDNAService(db).recalculate(current_user.id)
