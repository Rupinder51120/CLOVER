from pydantic import BaseModel
from uuid import UUID
from typing import Optional


class DestinationResponse(BaseModel):
    id: UUID
    name: str
    city: str
    country: str
    region: str
    description: Optional[str]
    tags: Optional[list[str]]
    categories: Optional[list[str]]
    avg_cost_per_day: Optional[float]
    adventure_score: float
    nature_score: float
    food_score: float
    culture_score: float
    photography_score: float
    relaxation_score: float
    luxury_score: float
    latitude: Optional[float]
    longitude: Optional[float]
    image_url: Optional[str]

    class Config:
        from_attributes = True


class RecommendationResponse(BaseModel):
    destination: DestinationResponse
    score: float
    reason: str
    is_hidden_gem: bool

    class Config:
        from_attributes = True


class FeedbackRequest(BaseModel):
    destination_id: UUID
    feedback: str
