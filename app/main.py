from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
from app.core.config import settings
from app.core.redis import init_redis, close_redis
from app.api.v1.auth import router as auth_router
from app.api.v1.trips import router as trips_router
from app.api.v1.clover_dna import router as dna_router
from app.api.v1.recommendations import router as recommendations_router
from app.api.v1.itinerary import router as itinerary_router
from app.api.v1.wrapped import router as wrapped_router
from app.api.v1.challenges import router as challenges_router
from app.core.db import AsyncSessionLocal
from app.utils.seed_destinations import seed_destinations
from app.services.challenge_service import ChallengeService


@asynccontextmanager
async def lifespan(app: FastAPI):
    await init_redis()
    async with AsyncSessionLocal() as db:
        await ChallengeService(db).seed_challenges()
        await db.commit()
    yield
    await close_redis()


app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    docs_url="/docs",
    redoc_url="/redoc",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth_router, prefix="/api/v1")
app.include_router(trips_router, prefix="/api/v1")
app.include_router(dna_router, prefix="/api/v1")
app.include_router(recommendations_router, prefix="/api/v1")
app.include_router(itinerary_router, prefix="/api/v1")
app.include_router(wrapped_router, prefix="/api/v1")
app.include_router(challenges_router, prefix="/api/v1")


@app.get("/health")
async def health():
    return {"status": "ok", "app": settings.PROJECT_NAME, "version": settings.VERSION}


@app.post("/admin/seed")
async def seed():
    async with AsyncSessionLocal() as db:
        await seed_destinations(db)
    return {"message": "Seeded successfully"}
