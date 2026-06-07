import uuid
from sqlalchemy import String, Integer, ForeignKey, Boolean, DateTime
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.models.base import CloverBase


class CloverChallenge(CloverBase):
    __tablename__ = "clover_challenges"

    title: Mapped[str] = mapped_column(String(255), nullable=False)
    description: Mapped[str] = mapped_column(String(500), nullable=False)
    category: Mapped[str] = mapped_column(String(100), nullable=False)
    target_count: Mapped[int] = mapped_column(Integer, nullable=False)
    badge_name: Mapped[str] = mapped_column(String(100), nullable=False)
    badge_icon: Mapped[str] = mapped_column(String(255), nullable=False)

    user_challenges: Mapped[list["CloverUserChallenge"]] = relationship(back_populates="challenge")


class CloverUserChallenge(CloverBase):
    __tablename__ = "clover_user_challenges"

    user_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("clover_users.id"), index=True)
    challenge_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("clover_challenges.id"), index=True)
    progress: Mapped[int] = mapped_column(Integer, default=0)
    is_completed: Mapped[bool] = mapped_column(Boolean, default=False)
    completed_at: Mapped[DateTime | None] = mapped_column(DateTime(timezone=True), nullable=True)

    user: Mapped["User"] = relationship(back_populates="user_challenges")
    challenge: Mapped["CloverChallenge"] = relationship(back_populates="user_challenges")
