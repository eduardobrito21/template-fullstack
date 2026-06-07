---
status: accepted
date: 2026-06-07
---

# The template ships a harness, not a stack

This repo was a FastAPI + Next.js fullstack template; we tore that down. It is now stack-agnostic: no application code ships with it. The value is the harness — AGENTS.md map, docs schema, Makefile contract, .claude setup, CI. The stack is chosen per-project at instantiation, where `/init-project` wires the Makefile contract (`check`, `test`, `lint`, `typecheck`, `dev` — names permanent, wiring per-project) to real commands as the instance's first exec plan.

## Considered Options

- **Vestigial stack** (keep FastAPI skeleton as reference implementation) — rejected: becomes a Python template with extra steps, reintroduces stack-opinion maintenance.
- **Two-repo split** (harness template + separate fullstack template) — rejected: more repos to maintain, and the fullstack half wasn't wanted at all.
