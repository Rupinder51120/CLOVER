import uuid
from sqlalchemy import String, Integer, JSON, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.models.base import CloverBase


class CloverWrapped(CloverBase):
    __tablename__ = "clover_wrapped"

    user_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("clover_users.id"), index=True)
    year: Mapped[int] = mapped_column(Integer, nullable=False)
    month: Mapped[int | None] = mapped_column(Integer, nullable=True)
    stats: Mapped[dict] = mapped_column(JSON, nullable=False)
    card_url: Mapped[str | None] = mapped_column(String(500), nullable=True)
    share_token: Mapped[str | None] = mapped_column(String(100), unique=True, nullable=True)

    user: Mapped["User"] = relationship(back_populates="clover_wrapped")
