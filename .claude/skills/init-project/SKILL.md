---
name: init-project
description: Instantiate a project from this harness template — choose a stack, wire the Makefile contract, reset template meta-docs, and seed the first exec plan. Use once, right after cloning the template into a new repo.
---

Instantiation turns the harness template into a project instance. Follow the stages in order; each ends with verification.

## 1. Interview (short — don't grill)

Ask, one at a time, with recommendations:

1. **Project name** — replaces `{{PROJECT_NAME}}` everywhere.
2. **One-sentence purpose** — seeds README and AGENTS.md header.
3. **Stack** — backend language/framework, database, frontend (if any).
   - Frontend rule: **TypeScript (strict) is required; the framework is a free choice.** Next.js, Vite+React, SvelteKit, Astro — pick what fits the project. Do not default to Next.js out of habit.
4. **Surfaces** — has a UI? has a DB? is a product (vs. library/CLI)?

## 2. Reset template meta-docs (keep/clear list — design-doc 0002)

**Keep (transferable layer):**
- `docs/PLANS.md`, `docs/design-docs/core-beliefs.md` — unchanged
- `docs/design-docs/index.md`, `docs/product-specs/index.md` — reset to empty index (keep header)
- `docs/exec-plans/tech-debt-tracker.md` — keep header, clear rows
- `ARCHITECTURE.md`, `docs/SECURITY.md`, `docs/DESIGN.md` — keep skeletons, fill during stage 3
- `scripts/check_harness.sh`, `.github/workflows/ci.yml` — keep
- `.claude/rules/` — keep; concretized in stage 4 (design-doc 0004)

**Clear (template-specific layer):**
- `docs/design-docs/0*.md` — numbered decisions about the template itself
- `docs/exec-plans/active/*`, `docs/exec-plans/completed/*` — template exec plans
- `CONTEXT.md` — replace with an empty glossary (title + purpose sentence) seeded with section headings — Product, Tech, Infra, Business logic — add or drop sections as the domain demands; terms accrete from real work
- The "Template state" callouts in `AGENTS.md` and `ARCHITECTURE.md`

**Prune (if not applicable):**
- `docs/DESIGN.md` — delete if no UI
- This skill itself (`.claude/skills/init-project/`) — delete as the last step

## 3. Scaffold the stack

Scaffold the chosen stack with its own official tooling (e.g. `uv init`, `npm create vite@latest`). Update `ARCHITECTURE.md` (system shape, layers, entry points), `docs/SECURITY.md` (secrets locations), and `.gitignore` for the stack. Replace `{{PROJECT_NAME}}` everywhere. Rewrite `README.md` for the project (the harness explanation no longer belongs there).

## 4. Concretize the rules

The rules in `.claude/rules/` state stack-agnostic principles with stack idioms fenced in marker blocks:

```
<!-- init-project: replace this block with the chosen stack's idiom, then delete the markers -->
...illustration from the source instance...
<!-- /init-project -->
```

For each rule, replace every marker block with the chosen stack's idiom — validation library (rule 01), exhaustiveness/derived-shape idioms (02), structured-logging call (03), branded/typed ids (04), docstring convention (05) — then delete the markers. Update each rule's **Enforced by** line where the stack now enforces it mechanically (e.g. an exhaustiveness lint).

Then generate stack-specific rules for surfaces the interview surfaced (e.g. `07-frontend.md`, `08-shared-package.md`), each following the same shape: current state → the trigger for graduating to heavier tooling → `## Do not`.

Verify: `grep -rn 'init-project' .claude/rules/` is empty — zero markers remain.

## 5. Wire the Makefile contract

Create `Makefile` with exactly these targets, wired to real stack commands:

```make
check: lint typecheck test harness   # THE done signal
harness:
	bash scripts/check_harness.sh
test:
lint:
typecheck:
dev:
```

Update `.github/workflows/ci.yml` to run `make check`. Add formatting hooks to `.claude/settings.json` if the stack has formatters.

## 6. Seed the first exec plan

Write `docs/exec-plans/active/0001-wire-verification.md` per `docs/PLANS.md`: goal = every Makefile target runs real checks and `make check` fails on a seeded error (prove it catches a type error, a lint error, and a failing test — then remove the seeds).

## 7. Validate

`make check` passes; `scripts/check_harness.sh` passes; no `{{PROJECT_NAME}}` placeholders remain (`grep -r "{{PROJECT_NAME}}" .` is empty); git state is a reviewable working tree (do not commit — the human reviews and opens the PR).
