from pydantic import BaseModel
from uuid import UUID
from typing import Optional


class CloverDNAResponse(BaseModel):
    id: UUID
    user_id: UUID
    adventure_score: float
    nature_score: float
    food_score: float
    culture_score: float
    photography_score: float
    relaxation_score: float
    luxury_score: float
    personality_type: Optional[str]
    total_trips: int
    total_countries: int
    total_distance_km: float

    class Config:
        from_attributes = True
