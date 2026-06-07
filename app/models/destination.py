from sqlalchemy import String, Float, ARRAY, Integer
from sqlalchemy.orm import Mapped, mapped_column
from app.models.base import CloverBase


class CloverDestination(CloverBase):
    __tablename__ = "clover_destinations"

    name: Mapped[str] = mapped_column(String(255), nullable=False)
    city: Mapped[str] = mapped_column(String(255), nullable=False)
    country: Mapped[str] = mapped_column(String(255), nullable=False)
    region: Mapped[str] = mapped_column(String(100), nullable=False)
    description: Mapped[str | None] = mapped_column(String(1000), nullable=True)
    tags: Mapped[list | None] = mapped_column(ARRAY(String), nullable=True)
    categories: Mapped[list | None] = mapped_column(ARRAY(String), nullable=True)
    avg_cost_per_day: Mapped[float | None] = mapped_column(Float, nullable=True)
    adventure_score: Mapped[float] = mapped_column(Float, default=0.0)
    nature_score: Mapped[float] = mapped_column(Float, default=0.0)
    food_score: Mapped[float] = mapped_column(Float, default=0.0)
    culture_score: Mapped[float] = mapped_column(Float, default=0.0)
    photography_score: Mapped[float] = mapped_column(Float, default=0.0)
    relaxation_score: Mapped[float] = mapped_column(Float, default=0.0)
    luxury_score: Mapped[float] = mapped_column(Float, default=0.0)
    latitude: Mapped[float | None] = mapped_column(Float, nullable=True)
    longitude: Mapped[float | None] = mapped_column(Float, nullable=True)
    image_url: Mapped[str | None] = mapped_column(String(500), nullable=True)
    visitor_count: Mapped[int] = mapped_column(Integer, default=0)
