# Harness Template

A repo template whose value is the harness — the scaffolding that lets agents operate a repo end-to-end — rather than any application stack.

## Language

**Harness**:
The scaffolding that lets agents operate a repo end-to-end: the context map (AGENTS.md), docs schema, verification contract, and .claude setup.
_Avoid_: agentic scaffolding, agent setup, AI config

**Stack**:
The application technology a stamped-out project actually runs (e.g. FastAPI + Next.js). Chosen per-project at instantiation; never part of this template.
_Avoid_: boilerplate, app code

**Makefile contract**:
The fixed set of make targets every stamped project must expose (`check`, `test`, `lint`, `typecheck`, `dev`). A written requirement, not a shipped file — the template has no Makefile; `/init-project` creates it when the stack arrives.
_Avoid_: build scripts, dev commands

**Harness check**:
The template's only mechanical verification: `scripts/check_harness.sh` (POSIX tools only — no language runtime), validating the harness's own invariants (index/file sync, exec-plan structure, lifecycle frontmatter, AGENTS.md line budget, link integrity). Direct-invoked by CI until instantiation folds it under `make check`.
_Avoid_: docs lint, structure test

**Instantiation**:
The act of stamping a project out of this template — choosing a stack, wiring the Makefile contract, and resetting template meta-docs.
_Avoid_: setup, bootstrap, init (as a noun)

**Exec plan**:
A self-contained design document in `docs/exec-plans/` written so a beginner could implement the feature end to end. The unit of work. Standard defined in `docs/PLANS.md`.
_Avoid_: ticket, issue, task

**Product KB**:
The living view of what the product *is*: `docs/product-specs/` — area specs, knowledge notes, and principles, edited in place and indexed by a map of content. History is git; the *why* is design docs (0006).
_Avoid_: PRD archive, specs folder, product docs
