from sqlalchemy.ext.asyncio import AsyncSession
from app.models.destination import CloverDestination


DESTINATIONS = [
    {"name": "Manali", "city": "Manali", "country": "India", "region": "Asia",
     "description": "Mountain paradise in Himachal Pradesh", "tags": ["mountains", "snow", "adventure"],
     "categories": ["adventure", "nature"], "avg_cost_per_day": 3000,
     "adventure_score": 90, "nature_score": 95, "food_score": 40,
     "culture_score": 30, "photography_score": 85, "relaxation_score": 50, "luxury_score": 20,
     "latitude": 32.2432, "longitude": 77.1892, "visitor_count": 100},

    {"name": "Goa", "city": "Panaji", "country": "India", "region": "Asia",
     "description": "Beach paradise on the Arabian Sea", "tags": ["beach", "party", "relaxation"],
     "categories": ["leisure", "nature"], "avg_cost_per_day": 4000,
     "adventure_score": 30, "nature_score": 60, "food_score": 70,
     "culture_score": 50, "photography_score": 75, "relaxation_score": 90, "luxury_score": 60,
     "latitude": 15.2993, "longitude": 74.1240, "visitor_count": 200},

    {"name": "Varanasi", "city": "Varanasi", "country": "India", "region": "Asia",
     "description": "Spiritual capital of India", "tags": ["culture", "heritage", "spiritual"],
     "categories": ["cultural"], "avg_cost_per_day": 2000,
     "adventure_score": 20, "nature_score": 30, "food_score": 60,
     "culture_score": 95, "photography_score": 90, "relaxation_score": 20, "luxury_score": 10,
     "latitude": 25.3176, "longitude": 82.9739, "visitor_count": 150},

    {"name": "Leh", "city": "Leh", "country": "India", "region": "Asia",
     "description": "High altitude desert of Ladakh", "tags": ["mountains", "adventure", "photography"],
     "categories": ["adventure", "nature"], "avg_cost_per_day": 4000,
     "adventure_score": 95, "nature_score": 90, "food_score": 20,
     "culture_score": 40, "photography_score": 95, "relaxation_score": 30, "luxury_score": 10,
     "latitude": 34.1526, "longitude": 77.5771, "visitor_count": 3},

    {"name": "Udaipur", "city": "Udaipur", "country": "India", "region": "Asia",
     "description": "City of Lakes and palaces", "tags": ["luxury", "culture", "heritage"],
     "categories": ["cultural", "leisure"], "avg_cost_per_day": 5000,
     "adventure_score": 20, "nature_score": 40, "food_score": 60,
     "culture_score": 85, "photography_score": 80, "relaxation_score": 70, "luxury_score": 85,
     "latitude": 24.5854, "longitude": 73.7125, "visitor_count": 80},

    {"name": "Coorg", "city": "Madikeri", "country": "India", "region": "Asia",
     "description": "Scotland of India - coffee and forests", "tags": ["nature", "forest", "relaxation"],
     "categories": ["nature", "leisure"], "avg_cost_per_day": 3500,
     "adventure_score": 40, "nature_score": 85, "food_score": 50,
     "culture_score": 30, "photography_score": 70, "relaxation_score": 85, "luxury_score": 40,
     "latitude": 12.3375, "longitude": 75.8069, "visitor_count": 2},

    {"name": "Rishikesh", "city": "Rishikesh", "country": "India", "region": "Asia",
     "description": "Adventure and yoga capital of India", "tags": ["adventure", "yoga", "river"],
     "categories": ["adventure", "nature"], "avg_cost_per_day": 2500,
     "adventure_score": 85, "nature_score": 75, "food_score": 40,
     "culture_score": 50, "photography_score": 70, "relaxation_score": 60, "luxury_score": 20,
     "latitude": 30.0869, "longitude": 78.2676, "visitor_count": 120},

    {"name": "Jaipur", "city": "Jaipur", "country": "India", "region": "Asia",
     "description": "The Pink City of Rajasthan", "tags": ["culture", "heritage", "food"],
     "categories": ["cultural"], "avg_cost_per_day": 3000,
     "adventure_score": 15, "nature_score": 20, "food_score": 80,
     "culture_score": 90, "photography_score": 85, "relaxation_score": 40, "luxury_score": 60,
     "latitude": 26.9124, "longitude": 75.7873, "visitor_count": 180},

    {"name": "Andaman Islands", "city": "Port Blair", "country": "India", "region": "Asia",
     "description": "Pristine beaches and coral reefs", "tags": ["beach", "nature", "diving"],
     "categories": ["nature", "adventure"], "avg_cost_per_day": 6000,
     "adventure_score": 70, "nature_score": 90, "food_score": 50,
     "culture_score": 30, "photography_score": 85, "relaxation_score": 80, "luxury_score": 50,
     "latitude": 11.7401, "longitude": 92.6586, "visitor_count": 4},

    {"name": "Spiti Valley", "city": "Kaza", "country": "India", "region": "Asia",
     "description": "Remote cold desert mountain valley", "tags": ["mountains", "adventure", "offbeat"],
     "categories": ["adventure", "nature"], "avg_cost_per_day": 2000,
     "adventure_score": 95, "nature_score": 95, "food_score": 10,
     "culture_score": 30, "photography_score": 90, "relaxation_score": 20, "luxury_score": 5,
     "latitude": 32.2318, "longitude": 78.0413, "visitor_count": 1},
]


async def seed_destinations(db: AsyncSession):
    for d in DESTINATIONS:
        dest = CloverDestination(**d)
        db.add(dest)
    await db.commit()
    print(f"Seeded {len(DESTINATIONS)} destinations")
