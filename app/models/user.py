from sqlalchemy import String, Boolean, DateTime
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.models.base import CloverBase


class User(CloverBase):
    __tablename__ = "clover_users"

    email: Mapped[str] = mapped_column(String(255), unique=True, index=True, nullable=False)
    hashed_password: Mapped[str | None] = mapped_column(String(255), nullable=True)
    full_name: Mapped[str | None] = mapped_column(String(255), nullable=True)
    avatar_url: Mapped[str | None] = mapped_column(String(500), nullable=True)
    google_id: Mapped[str | None] = mapped_column(String(255), unique=True, nullable=True)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    is_verified: Mapped[bool] = mapped_column(Boolean, default=False)
    deleted_at: Mapped[DateTime | None] = mapped_column(DateTime(timezone=True), nullable=True)

    trips: Mapped[list["CloverTrip"]] = relationship(back_populates="user")
    clover_dna: Mapped["CloverDNA"] = relationship(back_populates="user")
    clover_wrapped: Mapped[list["CloverWrapped"]] = relationship(back_populates="user")
    user_challenges: Mapped[list["CloverUserChallenge"]] = relationship(back_populates="user")
