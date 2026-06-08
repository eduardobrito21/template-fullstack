# 00 — Project contract

**Enforced by:** `scripts/check_harness.sh` (plan structure, immutable
indexes); the trigger list itself is prose-only — enforced by review.

This repo is harness-first. Before changing behavior, check `AGENTS.md`
and the product KB (`docs/product-specs/` — the living view of what the
product *is*, design-doc 0006). If the behavior is not specified there,
either stop or make the change deliberately through the exec-plan flow.

## Non-trivial work needs a plan

Write an exec plan in `docs/exec-plans/active/` (format: `docs/PLANS.md`)
before coding when a change:

- Touches multiple layers (see `ARCHITECTURE.md`).
- Introduces a module, dependency, public API, or external contract.
- Makes a load-bearing data, protocol, or layout choice.
- Is likely to take more than about an hour.

Trivial edits do not need a plan: typos, lockfile-only dependency
bumps, single-file non-behavioral refactors, and tests for existing
behavior.

When a plan completes, write its close-out (resolve open questions, log
decisions), flip `status:`, and move it from `active/` to `completed/`
in the same PR as the change.

## Keep decisions and debt explicit

- Decision records in `docs/design-docs/` freeze on merge: the
  substance is immutable — supersede with a new numbered record; do not
  rewrite history. Lifecycle frontmatter (`status:`, `date:`,
  `superseded-by:`) stays editable (design-doc 0005).
- Accepted compromises go in `docs/exec-plans/tech-debt-tracker.md`
  with what, where, why accepted, and the exit condition.
- New project commands belong in the Makefile (or, in template state,
  `scripts/`); tribal knowledge is harness drift.
- Glossary conflicts get resolved in `CONTEXT.md`, not worked around.

## Do not

- Add product behavior that is not in a product spec or the active
  exec plan.
- Hide debt in a TODO without a tech-debt-tracker entry.
- Edit a completed exec plan or old design-doc to make new work look
  pre-approved.
- Add a new workflow or convention without documenting it in the
  harness (a rule, AGENTS.md, or a design-doc).
