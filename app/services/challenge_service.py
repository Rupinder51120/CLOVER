from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from uuid import UUID
from datetime import datetime, timezone
from app.models.challenge import CloverChallenge, CloverUserChallenge
from app.models.trip import CloverTrip


PREDEFINED_CHALLENGES = [
    {
        "title": "Mountain Seeker",
        "description": "Visit 3 mountain destinations",
        "category": "Nature",
        "target_count": 3,
        "badge_name": "Mountain Seeker",
        "badge_icon": "🏔️"
    },
    {
        "title": "Culture Vulture",
        "description": "Visit 5 heritage or cultural sites",
        "category": "Culture",
        "target_count": 5,
        "badge_name": "Culture Vulture",
        "badge_icon": "🏛️"
    },
    {
        "title": "Frequent Flyer",
        "description": "Log 10 trips total",
        "category": "Milestone",
        "target_count": 10,
        "badge_name": "Frequent Flyer",
        "badge_icon": "✈️"
    },
    {
        "title": "India Explorer",
        "description": "Visit 5 different states in India",
        "category": "Adventure",
        "target_count": 5,
        "badge_name": "India Explorer",
        "badge_icon": "🇮🇳"
    },
    {
        "title": "Adventure Junkie",
        "description": "Complete 5 adventure trips",
        "category": "Adventure",
        "target_count": 5,
        "badge_name": "Adventure Junkie",
        "badge_icon": "🧗"
    },
    {
        "title": "Foodie Traveler",
        "description": "Log 3 trips with food tag",
        "category": "Food",
        "target_count": 3,
        "badge_name": "Foodie Traveler",
        "badge_icon": "🍜"
    },
    {
        "title": "Globe Trotter",
        "description": "Visit 3 different countries",
        "category": "Milestone",
        "target_count": 3,
        "badge_name": "Globe Trotter",
        "badge_icon": "🌍"
    },
    {
        "title": "Nature Lover",
        "description": "Complete 5 nature trips",
        "category": "Nature",
        "target_count": 5,
        "badge_name": "Nature Lover",
        "badge_icon": "🌿"
    },
]


def _compute_progress(challenge: CloverChallenge, trips: list[CloverTrip]) -> int:
    title = challenge.title

    if title == "Mountain Seeker":
        return sum(1 for t in trips if any(
            tag in ["mountains", "snow", "hiking"] for tag in (t.tags or [])
        ))
    elif title == "Culture Vulture":
        return sum(1 for t in trips if any(
            tag in ["culture", "heritage", "history"] for tag in (t.tags or [])
        ))
    elif title == "Frequent Flyer":
        return len(trips)
    elif title == "India Explorer":
        indian_cities = set(t.city for t in trips if t.country == "India")
        return len(indian_cities)
    elif title == "Adventure Junkie":
        return sum(1 for t in trips if t.trip_type.value == "adventure")
    elif title == "Foodie Traveler":
        return sum(1 for t in trips if any(
            tag in ["food", "street food", "foodie"] for tag in (t.tags or [])
        ))
    elif title == "Globe Trotter":
        return len(set(t.country for t in trips))
    elif title == "Nature Lover":
        return sum(1 for t in trips if t.trip_type.value == "nature")
    return 0


class ChallengeService:
    def __init__(self, db: AsyncSession):
        self.db = db

    async def seed_challenges(self):
        existing = await self.db.execute(select(CloverChallenge))
        if existing.scalars().first():
            return
        for c in PREDEFINED_CHALLENGES:
            self.db.add(CloverChallenge(**c))
        await self.db.flush()

    async def get_all_challenges(self) -> list[CloverChallenge]:
        result = await self.db.execute(select(CloverChallenge))
        return result.scalars().all()

    async def get_user_challenges(self, user_id: UUID) -> list[CloverUserChallenge]:
        await self._sync_progress(user_id)
        result = await self.db.execute(
            select(CloverUserChallenge).where(
                CloverUserChallenge.user_id == user_id
            )
        )
        return result.scalars().all()

    async def _sync_progress(self, user_id: UUID):
        trips_result = await self.db.execute(
            select(CloverTrip).where(
                CloverTrip.user_id == user_id,
                CloverTrip.is_deleted == False
            )
        )
        trips = trips_result.scalars().all()

        challenges_result = await self.db.execute(select(CloverChallenge))
        challenges = challenges_result.scalars().all()

        for challenge in challenges:
            uc_result = await self.db.execute(
                select(CloverUserChallenge).where(
                    CloverUserChallenge.user_id == user_id,
                    CloverUserChallenge.challenge_id == challenge.id
                )
            )
            uc = uc_result.scalar_one_or_none()

            progress = _compute_progress(challenge, trips)
            is_completed = progress >= challenge.target_count

            if uc:
                uc.progress = progress
                if is_completed and not uc.is_completed:
                    uc.is_completed = True
                    uc.completed_at = datetime.now(timezone.utc)
            else:
                uc = CloverUserChallenge(
                    user_id=user_id,
                    challenge_id=challenge.id,
                    progress=progress,
                    is_completed=is_completed,
                    completed_at=datetime.now(timezone.utc) if is_completed else None
                )
                self.db.add(uc)

        await self.db.flush()

    async def get_badges(self, user_id: UUID) -> list[dict]:
        await self._sync_progress(user_id)
        result = await self.db.execute(
            select(CloverUserChallenge).where(
                CloverUserChallenge.user_id == user_id,
                CloverUserChallenge.is_completed == True
            )
        )
        completed = result.scalars().all()

        badges = []
        for uc in completed:
            challenge_result = await self.db.execute(
                select(CloverChallenge).where(CloverChallenge.id == uc.challenge_id)
            )
            challenge = challenge_result.scalar_one_or_none()
            if challenge:
                badges.append({
                    "badge_name": challenge.badge_name,
                    "badge_icon": challenge.badge_icon,
                    "category": challenge.category,
                    "completed_at": uc.completed_at
                })
        return badges
