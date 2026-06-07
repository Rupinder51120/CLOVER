from pydantic import BaseModel
from uuid import UUID
from typing import Optional


class WrappedResponse(BaseModel):
    id: UUID
    user_id: UUID
    year: int
    month: Optional[int]
    stats: dict
    card_url: Optional[str]
    share_token: Optional[str]

    class Config:
        from_attributes = True
