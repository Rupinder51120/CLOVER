# Clover 🍀

AI-powered travel companion that learns user travel personality, recommends destinations, generates itineraries using local LLMs, tracks travel achievements, and creates yearly travel wrapped summaries.

## Features

- JWT Authentication
- Trip Management
- Clover DNA Personality Engine
- Destination Recommendations
- AI Itinerary Generation (Qwen 2.5)
- Challenges & Badges
- Clover Wrapped Analytics
- Redis Caching
- Dockerized Infrastructure

## Tech Stack

- FastAPI
- PostgreSQL
- SQLAlchemy Async
- Redis
- Docker
- Alembic
- Ollama
- Qwen 2.5:7b

## Run Locally

```bash
docker compose up -d

source venv/bin/activate

python -m uvicorn app.main:app --reload --port 8000