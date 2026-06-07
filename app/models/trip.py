import uuid
import enum
from sqlalchemy import String, Float, Date, Integer, ForeignKey, ARRAY, Text, Enum
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.models.base import CloverBase


class TripType(str, enum.Enum):
    adventure = "adventure"
    leisure = "leisure"
    business = "business"
    cultural = "cultural"
    nature = "nature"


class CloverTrip(CloverBase):
    __tablename__ = "clover_trips"

    user_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("clover_users.id"), index=True, nullable=False)
    destination: Mapped[str] = mapped_column(String(255), nullable=False)
    city: Mapped[str] = mapped_column(String(255), nullable=False)
    country: Mapped[str] = mapped_column(String(255), nullable=False)
    start_date: Mapped[Date] = mapped_column(Date, nullable=False)
    end_date: Mapped[Date] = mapped_column(Date, nullable=False)
    total_cost: Mapped[float | None] = mapped_column(Float, nullable=True)
    trip_type: Mapped[TripType] = mapped_column(Enum(TripType), nullable=False)
    attractions: Mapped[list | None] = mapped_column(ARRAY(String), nullable=True)
    photos: Mapped[list | None] = mapped_column(ARRAY(String), nullable=True)
    tags: Mapped[list | None] = mapped_column(ARRAY(String), nullable=True)
    notes: Mapped[str | None] = mapped_column(Text, nullable=True)
    rating: Mapped[int | None] = mapped_column(Integer, nullable=True)
    is_deleted: Mapped[bool] = mapped_column(default=False)

    user: Mapped["User"] = relationship(back_populates="trips")
