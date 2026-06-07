from pydantic import BaseModel
from typing import Optional
from datetime import date
from uuid import UUID
from app.models.trip import TripType


class TripCreate(BaseModel):
    destination: str
    city: str
    country: str
    start_date: date
    end_date: date
    total_cost: Optional[float] = None
    trip_type: TripType
    attractions: Optional[list[str]] = []
    tags: Optional[list[str]] = []
    notes: Optional[str] = None
    rating: Optional[int] = None


class TripUpdate(BaseModel):
    destination: Optional[str] = None
    city: Optional[str] = None
    country: Optional[str] = None
    start_date: Optional[date] = None
    end_date: Optional[date] = None
    total_cost: Optional[float] = None
    trip_type: Optional[TripType] = None
    attractions: Optional[list[str]] = None
    tags: Optional[list[str]] = None
    notes: Optional[str] = None
    rating: Optional[int] = None


class TripResponse(BaseModel):
    id: UUID
    user_id: UUID
    destination: str
    city: str
    country: str
    start_date: date
    end_date: date
    total_cost: Optional[float]
    trip_type: TripType
    attractions: Optional[list[str]]
    photos: Optional[list[str]]
    tags: Optional[list[str]]
    notes: Optional[str]
    rating: Optional[int]

    class Config:
        from_attributes = True


class TripStats(BaseModel):
    total_trips: int
    total_countries: int
    total_cities: int
    total_spend: float
    avg_rating: float
    most_visited_country: Optional[str]
    favorite_trip_type: Optional[str]
