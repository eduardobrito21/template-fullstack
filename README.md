# {{PROJECT_NAME}}

Fullstack monorepo template: **FastAPI** (Python) + **Next.js** (TypeScript).

## Stack

| Layer    | Tech                                                |
| -------- | --------------------------------------------------- |
| Backend  | Python 3.12, FastAPI, SQLAlchemy 2, Alembic, Pydantic v2 |
| Frontend | Next.js 16 (App Router), TypeScript, Tailwind v4    |
| Database | PostgreSQL 16                                       |
| Cache    | Redis 7                                             |
| Proxy    | Nginx                                               |
| Tooling  | uv (Python), npm (Node), Docker Compose             |

## Quick Start

```bash
# 1. Clone and enter
git clone <repo-url> && cd <project>

# 2. Copy env files
cp .env.example .env
cp backend/.env.example backend/.env
cp frontend/.env.example frontend/.env

# 3. Start everything
make dev

# 4. Or run backend/frontend separately for local dev
make dev-backend   # http://localhost:8000
make dev-frontend  # http://localhost:3000
```

## Project Structure

```
.
├── backend/          # FastAPI + SQLAlchemy + Alembic
│   ├── src/
│   │   ├── apps/api/ # FastAPI app, routers
│   │   ├── libs/     # DAL, settings, clients, utils
│   │   ├── schemas/  # Pydantic schemas
│   │   └── tasks/    # Background tasks
│   ├── Dockerfile
│   └── pyproject.toml
├── frontend/         # Next.js + Tailwind
│   ├── src/
│   │   ├── app/      # App Router pages
│   │   └── lib/      # API client, utils
│   ├── Dockerfile
│   └── package.json
├── infra/            # nginx, postgres init scripts
├── compose.yml       # Docker orchestration
├── Makefile          # Dev commands
└── AGENTS.md         # AI agent guidelines
```

## Commands

```bash
make help          # Show all commands
make dev           # Start all services (Docker Compose)
make stop          # Stop all services
make dev-backend   # Backend only (hot reload)
make dev-frontend  # Frontend only (hot reload)
make test          # Run all tests
make lint          # Lint everything
make format        # Format backend code
make migrate       # Run DB migrations
make migration     # Create new migration
make codegen       # Generate TS types from OpenAPI
```

## Setup for Local Dev (without Docker)

**Backend:**
```bash
cd backend
uv sync          # Install dependencies
uv run uvicorn src.apps.api.main:app --reload --port 8000
```

**Frontend:**
```bash
cd frontend
npm install
npm run dev
```

## License

MIT
