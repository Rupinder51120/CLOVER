import uuid
from sqlalchemy import String, Float, ForeignKey, Boolean
from sqlalchemy.orm import Mapped, mapped_column
from app.models.base import CloverBase


class CloverRecommendation(CloverBase):
    __tablename__ = "clover_recommendations"

    user_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("clover_users.id"), index=True)
    destination_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("clover_destinations.id"), index=True)
    score: Mapped[float] = mapped_column(Float, default=0.0)
    reason: Mapped[str | None] = mapped_column(String(500), nullable=True)
    is_hidden_gem: Mapped[bool] = mapped_column(Boolean, default=False)
    feedback: Mapped[str | None] = mapped_column(String(50), nullable=True)
