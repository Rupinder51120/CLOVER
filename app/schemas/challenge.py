from pydantic import BaseModel
from uuid import UUID
from typing import Optional
from datetime import datetime


class ChallengeResponse(BaseModel):
    id: UUID
    title: str
    description: str
    category: str
    target_count: int
    badge_name: str
    badge_icon: str

    class Config:
        from_attributes = True


class UserChallengeResponse(BaseModel):
    id: UUID
    user_id: UUID
    challenge_id: UUID
    progress: int
    is_completed: bool
    completed_at: Optional[datetime]
    challenge: ChallengeResponse

    class Config:
        from_attributes = True
