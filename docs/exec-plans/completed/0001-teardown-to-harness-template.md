---
status: completed
created: 2026-06-07
completed: 2026-06-07
---

# 0001 — Teardown to harness template

## Goal

This repo is a stack-agnostic harness template: all application stack code removed, the full harness (map files, docs schema, harness check, instantiation skill, CI) in place and self-verifying.

## Context

The repo was a FastAPI + Next.js fullstack template. Design-docs 0001–0003 record the redesign decisions: the template ships a harness not a stack (0001), dogfoods its own schema with reset-at-instantiation (0002), and ships no Makefile — the contract is prose, the harness check is a script (0003). This plan executes those decisions.

## Plan

1. Delete the stack: `backend/`, `frontend/`, `infra/`, `compose.yml`, `Makefile`, `.cursor/`, `template.code-workspace`, `.env.example`. Verify: `git status` shows only deletions plus harness additions.
2. Build the docs schema: `docs/PLANS.md` (ExecPlan standard), `design-docs/` (core-beliefs + numbered decisions + index), `exec-plans/` (active, completed, tech-debt tracker), `product-specs/index.md`, `references/README.md`, `generated/README.md`, `DESIGN.md` and `SECURITY.md` skeletons. Verify: every path required by the harness check exists.
3. Rewrite the maps: `AGENTS.md` as a ≤120-line map with the Makefile contract and working rules; `ARCHITECTURE.md` as a code-map skeleton; `README.md` for the template's new identity. Verify: AGENTS.md within line budget.
4. Build the executable half: `scripts/check_harness.sh` (required paths, index/file sync, exec-plan sections, AGENTS.md budget, link integrity — POSIX tools only, no language runtime assumed), `.claude/skills/init-project/SKILL.md` (interview → reset per 0002 → scaffold → wire contract per 0003 → seed first exec plan), `.github/workflows/ci.yml` invoking the harness check. Verify: script runs, reports, and fails on a seeded violation.

## Validation

`scripts/check_harness.sh` exits 0 on the final tree. The working tree is left uncommitted for human review; CI will run the same check on the eventual PR.

## Out of scope

Repo rename (`template-fullstack` → something harness-shaped) — GitHub-side action, human's call.
