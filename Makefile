.PHONY: dev test lint format migrate codegen help

help:
	@echo "Available commands:"
	@echo "  make dev        Start frontend + backend (docker compose)"
	@echo "  make test       Run all tests"
	@echo "  make lint       Lint frontend + backend"
	@echo "  make format     Format all code"
	@echo "  make migrate    Run pending Alembic migrations"
	@echo "  make codegen    Generate TypeScript API client from OpenAPI"

dev:
	docker compose up --build --force-recreate --remove-orphans

stop:
	docker compose down

dev-backend:
	cd backend && uv run uvicorn src.apps.api.main:app --reload --port 8000

dev-frontend:
	cd frontend && npm run dev

test:
	cd backend && uv run pytest
	cd frontend && npm run test --if-present

lint:
	cd backend && uv run ruff check .
	cd frontend && npm run lint

format:
	cd backend && uv run ruff format .
	cd backend && uv run ruff check . --fix

migrate:
	cd backend && uv run alembic upgrade head

migration:
	@read -p "Migration name: " name; \
	cd backend && uv run alembic revision --autogenerate -m "$$name"

codegen:
	@echo "Fetching OpenAPI spec from http://localhost:8000/openapi.json..."
	cd frontend && npx openapi-typescript http://localhost:8000/openapi.json -o src/lib/api/schema.d.ts
	@echo "Done. Types written to frontend/src/lib/api/schema.d.ts"
