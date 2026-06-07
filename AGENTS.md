# {{PROJECT_NAME}} — Agent Map

This file is a **map, not a manual**. It tells you where things live and which rules are load-bearing. Depth lives in `docs/` — read on demand, not upfront. (Line budget: 120, mechanically enforced.)

> **Template state.** This repo is currently the harness template itself, not an instance. To stamp out a project, run the `init-project` skill (`.claude/skills/init-project/`). It chooses a stack, wires the Makefile contract, and resets template-specific docs.

## Where things live

| Path | What it is |
|---|---|
| `CONTEXT.md` | Domain glossary — the canonical vocabulary, organized by section (product, tech, infra, business logic, …). Use these terms; flag conflicts. |
| `ARCHITECTURE.md` | Code map: layers, dependency directions, structural invariants. |
| `docs/PLANS.md` | The ExecPlan standard — how work is specified. **Read before writing any plan.** |
| `docs/exec-plans/` | Units of work: `active/`, `completed/`, `tech-debt-tracker.md`. |
| `docs/design-docs/` | Numbered decision records + `index.md` + `core-beliefs.md` (principles). |
| `docs/product-specs/` | PRDs — the *what/why* of features, indexed in `index.md`. |
| `docs/references/` | Vendored `<tool>-llms.txt` docs — check here before relying on training data. |
| `docs/generated/` | Machine-owned; never hand-edit. |
| `docs/DESIGN.md` | Visual/UX principles (instances with a UI). |
| `docs/SECURITY.md` | Secrets handling, authz model, threat notes. |
| `scripts/check_harness.sh` | Mechanical validation of everything above (no runtime needed). |
| `.claude/rules/` | Conduct rules — when to plan, boundaries, code shape, docstrings, finish checklist (design-doc 0004). |

## The Makefile contract

Every instance exposes exactly these targets — names are permanent, wiring is per-stack:

```
make check       # lint + typecheck + test + harness check — THE done signal
make test        # tests only
make lint        # linters only
make typecheck   # type checkers only
make dev         # run the app locally
```

`make check` green is the only definition of done. Until a stack is wired (template state), run `scripts/check_harness.sh` directly.

## Working rules

1. **The unit of work is an exec plan.** Non-trivial work (triggers: `.claude/rules/00-project-contract.md`) starts as a plan in `docs/exec-plans/active/` per `docs/PLANS.md`; move it to `completed/` when validation passes.
2. **Decisions get recorded where they're made.** A real trade-off resolved → numbered file in `docs/design-docs/` + index entry, cited by number thereafter.
3. **Glossary discipline.** `CONTEXT.md` terms are canonical. Encounter a conflict or a fuzzy term → sharpen the glossary, don't work around it.
4. **Nothing is done unverified.** If you can't observe your change working (command, test, rendered page), build the capability to observe it first.
5. **A repeated rule becomes a check.** Caught violating a convention twice → add it to `scripts/check_harness.sh` or a linter; don't add prose.
6. **Deferrals are tracked.** Skipping something deliberately → row in `tech-debt-tracker.md` with an exit condition.

## Git

- Never commit to `main` — every change rides a feature branch into a PR.
- Imperative, concise commit messages; one logical change per commit.
