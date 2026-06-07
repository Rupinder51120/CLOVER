import uuid
from sqlalchemy import String, Integer, JSON, ForeignKey, Float
from sqlalchemy.orm import Mapped, mapped_column
from app.models.base import CloverBase


class CloverItinerary(CloverBase):
    __tablename__ = "clover_itineraries"

    user_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("clover_users.id"), index=True)
    destination: Mapped[str] = mapped_column(String(255), nullable=False)
    days: Mapped[int] = mapped_column(Integer, nullable=False)
    budget: Mapped[float | None] = mapped_column(Float, nullable=True)
    interests: Mapped[list | None] = mapped_column(JSON, nullable=True)
    content: Mapped[dict] = mapped_column(JSON, nullable=False)
    is_cached: Mapped[bool] = mapped_column(default=False)
