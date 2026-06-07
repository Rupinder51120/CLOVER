from sqlalchemy.ext.asyncio import AsyncSession
from uuid import UUID
from app.repositories.clover_dna_repository import CloverDNARepository
from app.repositories.trip_repository import TripRepository
from app.models.trip import TripType


TAG_SCORES = {
    "adventure": {"adventure": 20, "nature": 10},
    "mountains": {"adventure": 15, "nature": 20, "photography": 10},
    "snow": {"adventure": 15, "nature": 15},
    "beach": {"relaxation": 20, "nature": 15, "photography": 10},
    "hiking": {"adventure": 20, "nature": 15},
    "food": {"food": 25},
    "street food": {"food": 20},
    "culture": {"culture": 25},
    "heritage": {"culture": 20, "photography": 10},
    "history": {"culture": 20},
    "luxury": {"luxury": 25, "relaxation": 10},
    "resort": {"luxury": 20, "relaxation": 15},
    "spa": {"relaxation": 25, "luxury": 10},
    "wildlife": {"nature": 25, "photography": 15},
    "photography": {"photography": 25},
    "art": {"culture": 15, "photography": 10},
    "music": {"culture": 15},
    "festival": {"culture": 20, "food": 10},
    "solo": {"adventure": 10},
    "backpacking": {"adventure": 15, "nature": 10},
    "camping": {"adventure": 20, "nature": 20},
    "road trip": {"adventure": 15},
}

TRIP_TYPE_SCORES = {
    TripType.adventure: {"adventure": 20, "nature": 10},
    TripType.leisure: {"relaxation": 20, "luxury": 10},
    TripType.business: {"luxury": 10},
    TripType.cultural: {"culture": 20, "photography": 10},
    TripType.nature: {"nature": 20, "adventure": 10, "photography": 10},
}

ATTRACTION_SCORES = {
    "pass": {"adventure": 15, "nature": 15},
    "valley": {"nature": 20, "photography": 10},
    "lake": {"nature": 20, "photography": 15, "relaxation": 10},
    "temple": {"culture": 20, "photography": 10},
    "museum": {"culture": 25},
    "fort": {"culture": 20, "photography": 10},
    "palace": {"culture": 15, "luxury": 10, "photography": 10},
    "market": {"food": 15, "culture": 10},
    "beach": {"relaxation": 20, "nature": 15},
    "waterfall": {"nature": 20, "photography": 15},
    "forest": {"nature": 25},
    "resort": {"luxury": 20, "relaxation": 15},
    "cafe": {"food": 10, "relaxation": 5},
    "restaurant": {"food": 15},
}

PERSONALITY_TYPES = [
    {
        "name": "Mountain Explorer",
        "requires": {"adventure": 60, "nature": 50},
    },
    {
        "name": "Adventure Nomad",
        "requires": {"adventure": 70},
    },
    {
        "name": "Food Voyager",
        "requires": {"food": 60},
    },
    {
        "name": "Culture Hunter",
        "requires": {"culture": 60},
    },
    {
        "name": "Weekend Escapist",
        "requires": {"relaxation": 60},
    },
    {
        "name": "Luxury Traveler",
        "requires": {"luxury": 60},
    },
    {
        "name": "Nature Wanderer",
        "requires": {"nature": 60},
    },
]


def _normalize(score: float, count: int) -> float:
    if count == 0:
        return 0.0
    raw = score / count
    return min(round(raw, 2), 100.0)


def _determine_personality(scores: dict) -> str:
    for p in PERSONALITY_TYPES:
        if all(scores.get(k, 0) >= v for k, v in p["requires"].items()):
            return p["name"]
    dominant = max(scores, key=scores.get)
    return f"{dominant.capitalize()} Traveler"


class CloverDNAService:
    def __init__(self, db: AsyncSession):
        self.db = db
        self.repo = CloverDNARepository(db)
        self.trip_repo = TripRepository(db)

    async def get_dna(self, user_id: UUID):
        dna = await self.repo.get_by_user(user_id)
        if not dna:
            dna = await self.repo.create(user_id)
        return dna

    async def recalculate(self, user_id: UUID):
        trips = await self.trip_repo.get_all(user_id)
        dna = await self.repo.get_by_user(user_id)
        if not dna:
            dna = await self.repo.create(user_id)

        if not trips:
            return dna

        scores = {
            "adventure": 0.0,
            "nature": 0.0,
            "food": 0.0,
            "culture": 0.0,
            "photography": 0.0,
            "relaxation": 0.0,
            "luxury": 0.0,
        }

        for trip in trips:
            # score from trip type
            type_scores = TRIP_TYPE_SCORES.get(trip.trip_type, {})
            for dim, val in type_scores.items():
                scores[dim] += val

            # score from tags
            for tag in (trip.tags or []):
                tag_lower = tag.lower()
                for key, val_map in TAG_SCORES.items():
                    if key in tag_lower:
                        for dim, val in val_map.items():
                            scores[dim] += val

            # score from attractions
            for attraction in (trip.attractions or []):
                attr_lower = attraction.lower()
                for key, val_map in ATTRACTION_SCORES.items():
                    if key in attr_lower:
                        for dim, val in val_map.items():
                            scores[dim] += val

            # bonus for high rating
            if trip.rating and trip.rating >= 4:
                type_scores = TRIP_TYPE_SCORES.get(trip.trip_type, {})
                for dim, val in type_scores.items():
                    scores[dim] += val * 0.5

        count = len(trips)
        normalized = {k: _normalize(v, count) for k, v in scores.items()}
        personality = _determine_personality(normalized)

        countries = set(t.country for t in trips)

        await self.repo.update(dna, {
            "adventure_score": normalized["adventure"],
            "nature_score": normalized["nature"],
            "food_score": normalized["food"],
            "culture_score": normalized["culture"],
            "photography_score": normalized["photography"],
            "relaxation_score": normalized["relaxation"],
            "luxury_score": normalized["luxury"],
            "personality_type": personality,
            "total_trips": count,
            "total_countries": len(countries),
        })

        return dna
