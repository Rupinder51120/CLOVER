from pydantic import BaseModel
from uuid import UUID
from typing import Optional


class ItineraryRequest(BaseModel):
    destination: str
    days: int
    budget: Optional[float] = None
    interests: Optional[list[str]] = []


class ItineraryResponse(BaseModel):
    id: UUID
    user_id: UUID
    destination: str
    days: int
    budget: Optional[float]
    interests: Optional[list]
    content: dict
    is_cached: bool

    class Config:
        from_attributes = True
