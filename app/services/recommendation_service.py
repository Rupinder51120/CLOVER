from sqlalchemy.ext.asyncio import AsyncSession
from uuid import UUID
from app.repositories.destination_repository import DestinationRepository
from app.repositories.clover_dna_repository import CloverDNARepository
from app.repositories.trip_repository import TripRepository
from app.models.clover_dna import CloverDNA
from app.models.destination import CloverDestination


def _score_destination(dna: CloverDNA, dest: CloverDestination) -> float:
    score = (
        abs(dna.adventure_score - dest.adventure_score) +
        abs(dna.nature_score - dest.nature_score) +
        abs(dna.food_score - dest.food_score) +
        abs(dna.culture_score - dest.culture_score) +
        abs(dna.photography_score - dest.photography_score) +
        abs(dna.relaxation_score - dest.relaxation_score) +
        abs(dna.luxury_score - dest.luxury_score)
    )
    return round(max(0, 100 - (score / 7)), 2)


def _get_reason(dna: CloverDNA, dest: CloverDestination) -> str:
    scores = {
        "adventure": dna.adventure_score,
        "nature": dna.nature_score,
        "food": dna.food_score,
        "culture": dna.culture_score,
        "photography": dna.photography_score,
        "relaxation": dna.relaxation_score,
        "luxury": dna.luxury_score,
    }
    dominant = max(scores, key=scores.get)
    reasons = {
        "adventure": f"Matches your adventurous spirit with thrilling experiences",
        "nature": f"Perfect for your love of nature and outdoors",
        "food": f"A paradise for food lovers like you",
        "culture": f"Rich cultural experiences that match your travel DNA",
        "photography": f"Stunning visuals perfect for photography enthusiasts",
        "relaxation": f"Ideal for your relaxation-focused travel style",
        "luxury": f"Premium experiences matching your luxury preferences",
    }
    return reasons.get(dominant, "Matches your travel DNA profile")


class RecommendationService:
    def __init__(self, db: AsyncSession):
        self.db = db
        self.dest_repo = DestinationRepository(db)
        self.dna_repo = CloverDNARepository(db)
        self.trip_repo = TripRepository(db)

    async def get_recommendations(self, user_id: UUID) -> list[dict]:
        dna = await self.dna_repo.get_by_user(user_id)
        if not dna:
            return []

        trips = await self.trip_repo.get_all(user_id)
        visited_countries = {t.country for t in trips}
        visited_cities = {t.city for t in trips}

        destinations = await self.dest_repo.get_all()
        if not destinations:
            return []

        scored = []
        for dest in destinations:
            if dest.city in visited_cities:
                continue
            score = _score_destination(dna, dest)
            reason = _get_reason(dna, dest)
            scored.append({
                "destination": dest,
                "score": score,
                "reason": reason,
                "is_hidden_gem": dest.visitor_count < 5
            })

        scored.sort(key=lambda x: x["score"], reverse=True)
        return scored[:10]

    async def get_hidden_gems(self, user_id: UUID) -> list[dict]:
        dna = await self.dna_repo.get_by_user(user_id)
        destinations = await self.dest_repo.get_hidden_gems()

        scored = []
        for dest in destinations:
            score = _score_destination(dna, dest) if dna else 50.0
            scored.append({
                "destination": dest,
                "score": score,
                "reason": "A hidden gem few travelers have discovered",
                "is_hidden_gem": True
            })

        scored.sort(key=lambda x: x["score"], reverse=True)
        return scored[:10]

    async def search_destinations(self, query: str) -> list[CloverDestination]:
        return await self.dest_repo.search(query)
