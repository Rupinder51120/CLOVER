import json
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from uuid import UUID
from fastapi import HTTPException
import ollama
from app.models.itinerary import CloverItinerary
from app.schemas.itinerary import ItineraryRequest

FALLBACK_ITINERARY = {
    "destination": "Your Destination",
    "days": 3,
    "overview": "A wonderful trip awaits you.",
    "day_plans": [
        {
            "day": 1,
            "theme": "Arrival & Exploration",
            "activities": [
                {"time": "10:00 AM", "activity": "Check in and freshen up", "duration": "1 hour", "cost": 0},
                {"time": "12:00 PM", "activity": "Local lunch", "duration": "1 hour", "cost": 300},
                {"time": "2:00 PM", "activity": "Explore local market", "duration": "2 hours", "cost": 200},
            ],
            "food_suggestions": ["Local cuisine", "Street food"],
            "estimated_cost": 1500,
            "tips": ["Carry cash", "Stay hydrated"]
        }
    ],
    "packing_list": ["Comfortable shoes", "Sunscreen", "Camera", "Power bank"],
    "total_estimated_cost": 5000,
    "best_time_to_visit": "October to March"
}


class ItineraryService:
    def __init__(self, db: AsyncSession):
        self.db = db

    async def generate(self, user_id: UUID, data: ItineraryRequest) -> CloverItinerary:
        existing = await self.db.execute(
            select(CloverItinerary).where(
                CloverItinerary.destination == data.destination,
                CloverItinerary.days == data.days,
                CloverItinerary.is_cached == True
            )
        )
        cached = existing.scalar_one_or_none()
        if cached:
            new = CloverItinerary(
                user_id=user_id,
                destination=data.destination,
                days=data.days,
                budget=data.budget,
                interests=data.interests,
                content=cached.content,
                is_cached=True
            )
            self.db.add(new)
            await self.db.flush()
            return new

        content = await self._call_qwen(data)
        itinerary = CloverItinerary(
            user_id=user_id,
            destination=data.destination,
            days=data.days,
            budget=data.budget,
            interests=data.interests,
            content=content,
            is_cached=False
        )
        self.db.add(itinerary)
        await self.db.flush()
        return itinerary

    async def _call_qwen(self, data: ItineraryRequest) -> dict:
        try:
            prompt = f"""
Create a detailed travel itinerary for {data.destination} for {data.days} days.
Budget: {data.budget or 'flexible'} INR total.
Interests: {', '.join(data.interests or ['general sightseeing'])}.

Return ONLY a valid JSON object with this exact structure:
{{
    "destination": "{data.destination}",
    "days": {data.days},
    "overview": "2-3 sentence overview",
    "day_plans": [
        {{
            "day": 1,
            "theme": "Day theme",
            "activities": [
                {{"time": "9:00 AM", "activity": "Activity name", "duration": "2 hours", "cost": 500}}
            ],
            "food_suggestions": ["Restaurant or dish name"],
            "estimated_cost": 2000,
            "tips": ["Useful tip"]
        }}
    ],
    "packing_list": ["item1", "item2"],
    "total_estimated_cost": 10000,
    "best_time_to_visit": "Month range"
}}

Return only the JSON, no markdown, no explanation.
"""
            response = ollama.chat(
                model="qwen2.5:7b",
                messages=[{"role": "user", "content": prompt}]
            )
            text = response["message"]["content"].strip()
            if text.startswith("```"):
                text = text.split("```")[1]
                if text.startswith("json"):
                    text = text[4:]
            return json.loads(text.strip())
        except Exception as e:
            print(f"Qwen error: {e}")
            fallback = FALLBACK_ITINERARY.copy()
            fallback["destination"] = data.destination
            fallback["days"] = data.days
            return fallback

    async def get_all(self, user_id: UUID) -> list[CloverItinerary]:
        result = await self.db.execute(
            select(CloverItinerary).where(CloverItinerary.user_id == user_id)
        )
        return result.scalars().all()

    async def get_by_id(self, itinerary_id: UUID, user_id: UUID) -> CloverItinerary:
        result = await self.db.execute(
            select(CloverItinerary).where(
                CloverItinerary.id == itinerary_id,
                CloverItinerary.user_id == user_id
            )
        )
        itinerary = result.scalar_one_or_none()
        if not itinerary:
            raise HTTPException(status_code=404, detail="Itinerary not found")
        return itinerary

    async def delete(self, itinerary_id: UUID, user_id: UUID):
        itinerary = await self.get_by_id(itinerary_id, user_id)
        await self.db.delete(itinerary)
        return {"message": "Itinerary deleted"}
