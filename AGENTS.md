# AGENTS.md — AI Agent Guidelines

This file tells AI coding agents how to work on this codebase.

---

## Project Overview

**{{PROJECT_NAME}}** — Monorepo with a Python backend and Next.js frontend.

**Owner context:** Eduardo is a senior Python/backend engineer. He reviews all backend code. He does NOT know frontend — the AI agent is solely responsible for frontend quality, correctness, and best practices.

---

## Architecture

```
frontend/    → Next.js 16, App Router, TypeScript, Tailwind v4, shadcn/ui
backend/     → Python 3.12, FastAPI, SQLAlchemy async, Pydantic v2
infra/       → nginx, postgres config
compose.yml  → orchestration
```

The frontend calls the backend via `/api/*` which is rewritten to `http://localhost:8000/*` by Next.js in dev, and proxied by Nginx in production.

---

## The Golden Rule

**Backend:** Eduardo will review and catch mistakes. Write clean, typed code. Defer to his judgment on Python patterns.

**Frontend:** You are the expert. Eduardo cannot catch your mistakes. Be extra careful:

- Use well-established libraries (shadcn/ui, TanStack Query, nuqs, zod)
- Never use deprecated patterns or experimental APIs
- Always handle loading, error, and empty states
- Type everything — no `any`
- If you're unsure, prefer the boring, well-documented approach

---

## Tech Stack — Do Not Deviate

### Backend


| What            | Library           | Notes                                |
| --------------- | ----------------- | ------------------------------------ |
| API framework   | FastAPI           | Always async                         |
| ORM             | SQLAlchemy 2.x    | Async engine, mapped_column style    |
| Migrations      | Alembic           | Autogenerate from models             |
| Schemas         | Pydantic v2       | All API input/output                 |
| Settings        | pydantic-settings | From .env                            |
| DB driver       | psycopg 3         | `postgresql+psycopg://`              |
| Cache           | Redis             | Via `redis` package                  |
| Pipelines       | Prefect 3         | Flows + tasks                        |
| HTTP client     | httpx             | Async                                |
| Linter          | Ruff              | See ruff.toml                        |
| Type checker    | basedpyright      | See pyrightconfig.json               |
| Observability   | Logfire           |                                      |
| Package manager | uv                | Always `uv add`, `uv sync`, `uv run` |


### Frontend


| What             | Library                | Notes                                         |
| ---------------- | ---------------------- | --------------------------------------------- |
| Framework        | Next.js 16             | App Router only, no Pages Router              |
| Language         | TypeScript             | Strict mode, no `any`                         |
| Styling          | Tailwind CSS v4        | Utility classes, design tokens in globals.css |
| Components       | shadcn/ui              | Copy-paste, lives in `components/ui/`         |
| Data fetching    | TanStack Query v5      | Client components only                        |
| URL state        | nuqs v2                | Filters, search, pagination                   |
| Forms            | react-hook-form + zod  | Via shadcn Form component                     |
| Validation       | Zod                    | Shared schemas in `lib/validations/`          |
| Tables           | TanStack Table v8      | Sorting, filtering, pagination                |
| Icons            | lucide-react           | Consistent with shadcn                        |
| Formatting       | Prettier               | With tailwindcss plugin                       |
| Linting          | ESLint 9               | Flat config                                   |


---

## File Organization

### Backend

```
backend/src/
├── apps/
│   └── api/
│       ├── main.py           # FastAPI app, middleware
│       ├── deps.py           # Dependency injection (get_db, get_current_user)
│       └── routers/          # One file per domain entity
├── libs/
│   ├── dal/                  # Database Access Layer
│   │   ├── base.py           # Engine, async session, Base class
│   │   ├── models/           # SQLAlchemy models (one file per entity)
│   │   └── migrations/       # Alembic
│   ├── clients/              # External API clients
│   ├── settings.py           # Pydantic settings
│   ├── security.py           # JWT creation, password hashing
│   └── utils/
├── schemas/                  # Pydantic schemas — organized per entity
│   ├── auth.py               # Simple entities: single file
│   └── entity/               # Complex entities: subdirectory
│       ├── read.py           # API response schemas
│       ├── write.py          # API request schemas
│       ├── query.py          # Query parameter schemas
│       └── dal.py            # DAL layer schemas
└── tasks/                    # Background tasks / pipelines
```

**Schema naming convention:**

- `read.py` — API response schemas (what the API returns)
- `write.py` — API request schemas (what the client sends)
- `query.py` — Query parameter schemas (URL params for filtering/pagination)
- `dal.py` — DAL layer schemas (internal, for passing data to/from DAL)

Simple entities with only 2-3 schemas can stay as a single file.

### Frontend

```
frontend/src/
├── app/
│   ├── (auth)/               # Route group — no sidebar
│   │   ├── login/page.tsx
│   │   └── layout.tsx
│   ├── (dashboard)/          # Route group — with sidebar
│   │   ├── layout.tsx        # Sidebar + header
│   │   └── page.tsx          # Home page
│   ├── api/auth/[...nextauth]/route.ts
│   ├── layout.tsx            # Root: fonts, metadata
│   └── providers.tsx         # QueryClient, NuqsAdapter, SessionProvider
├── components/
│   ├── ui/                   # shadcn (DO NOT edit these directly)
│   ├── layout/               # sidebar.tsx, header.tsx, nav.tsx
│   └── domain/               # Domain-specific components (flat, not nested)
├── hooks/                    # useQuery wrappers, custom hooks
├── lib/
│   ├── api/
│   │   ├── client.ts         # Fetch wrapper with auth headers
│   │   └── schema.d.ts       # Auto-generated from OpenAPI (make codegen)
│   ├── auth.ts               # NextAuth config
│   ├── query-keys.ts         # Centralized query key factory
│   ├── utils.ts              # cn(), formatCurrency(), formatPercent()
│   └── validations/          # Zod schemas
├── types/                    # TypeScript type definitions
└── config/
    └── site.ts               # Navigation items, site metadata
```

**Frontend component organization:** All domain-specific components live flat in `components/domain/`. They are NOT grouped into nested subdirectories per entity.

---

## Coding Conventions

### Backend (Python)

- All endpoints are `async def`
- Use `Annotated[T, Depends(...)]` for dependency injection
- Models use `mapped_column()` style (SQLAlchemy 2.x)
- Schemas use Pydantic v2 `model_config = ConfigDict(from_attributes=True)`
- One router file per domain entity
- Raise `HTTPException` for error responses, not return
- Use `select()` not `query()` (SQLAlchemy 2.x style)
- Test with pytest + pytest-asyncio
- Line length: 100 (see ruff.toml)

### Frontend (TypeScript/React)

- **Server Components by default.** Only add `"use client"` when you need useState, useEffect, event handlers, or browser APIs.
- **No barrel exports** — import from the specific file, not `index.ts`
- **Named exports** — `export function Component()` not `export default`
- **shadcn/ui components are untouched** — customize by wrapping, not editing `components/ui/`
- **All data fetching through TanStack Query** in client components
- **URL state via nuqs** for anything that should survive refresh (filters, search, page)
- Component filenames: `kebab-case.tsx`
- Type filenames: `kebab-case.ts`

---

## Common Pitfalls to Avoid

### Backend

- Do NOT use `query()` — it's SQLAlchemy 1.x. Use `select()`.
- Do NOT use `psycopg2`. We use `psycopg` (v3).
- Do NOT use `asyncpg`. We use `psycopg` with async support.
- Always use `async with` for database sessions.
- `libs/dal/` NOT `libs/db/` — it's a Database Access Layer.

### Frontend

- Do NOT use Pages Router patterns (`getServerSideProps`, `_app.tsx`).
- Do NOT use `useEffect` for data fetching — use TanStack Query.
- Do NOT install component libraries (Material UI, Ant Design, Chakra). Use shadcn/ui.
- Do NOT use `axios`. Use native `fetch` or the `lib/api/client.ts` wrapper.
- Do NOT use CSS modules or styled-components. Tailwind only.
- Do NOT hardcode API URLs. Always use `/api/...` which gets rewritten.
- Do NOT use `React.FC` — just type props directly.
- Do NOT create `index.ts` barrel files.

---

## Development Commands

```bash
make dev           # Start all services (docker compose)
make stop          # Stop all services
make dev-backend   # Backend only (uvicorn with hot reload)
make dev-frontend  # Frontend only (next dev)
make test          # Run all tests
make lint          # Lint frontend + backend
make format        # Format backend code
make migrate       # Run Alembic migrations
make migration     # Create new Alembic migration
make codegen       # Generate TypeScript types from OpenAPI spec
```
