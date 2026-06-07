import uuid
from sqlalchemy import Float, String, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.models.base import CloverBase


class CloverDNA(CloverBase):
    __tablename__ = "clover_dna"

    user_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("clover_users.id"), unique=True, index=True)
    adventure_score: Mapped[float] = mapped_column(Float, default=0.0)
    nature_score: Mapped[float] = mapped_column(Float, default=0.0)
    food_score: Mapped[float] = mapped_column(Float, default=0.0)
    culture_score: Mapped[float] = mapped_column(Float, default=0.0)
    photography_score: Mapped[float] = mapped_column(Float, default=0.0)
    relaxation_score: Mapped[float] = mapped_column(Float, default=0.0)
    luxury_score: Mapped[float] = mapped_column(Float, default=0.0)
    personality_type: Mapped[str | None] = mapped_column(String(100), nullable=True)
    total_trips: Mapped[int] = mapped_column(default=0)
    total_countries: Mapped[int] = mapped_column(default=0)
    total_distance_km: Mapped[float] = mapped_column(Float, default=0.0)

    user: Mapped["User"] = relationship(back_populates="clover_dna")
