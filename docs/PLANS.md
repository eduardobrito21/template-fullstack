# PLANS.md — The ExecPlan Standard

Exec plans are the **unit of work** in this repo. Not issues, not tickets, not chat history — a markdown file in `docs/exec-plans/` is how work is specified, tracked, and remembered.

## The bar

An exec plan is **self-contained**: a beginner — human or agent, with no access to the conversation that produced it — could read it and implement the feature end to end. If executing the plan requires asking its author something, the plan is not done being written.

## Frontmatter

Every plan starts with a YAML block. `status:` is canonical; the directory mirrors it (the harness check enforces the sync).

```md
---
status: draft
created: 2026-06-07
---
```

- `status:` — `draft`, `executing`, or `blocked` while in `active/`; `completed` or `superseded` once in `completed/`.
- `created:` — `YYYY-MM-DD`, stamped when the plan is drafted.
- `completed:` — `YYYY-MM-DD`, stamped at close; required when status is `completed`.
- `superseded-by: NNNN` — required when status is `superseded`.

## Lifecycle

```
docs/exec-plans/
├── active/        ← status: draft | executing | blocked
├── completed/     ← status: completed | superseded — substance frozen
└── tech-debt-tracker.md
```

1. **Draft** the plan in `active/` as `NNNN-slug.md` (scan for the highest existing number across both directories, increment); `status: draft`, `created:` today.
2. **Execute** against it (`status: executing`). If reality contradicts the plan, update the plan first, then the code — the plan stays truthful throughout. Small decisions made along the way go in the `## Decision log`; real trade-offs graduate to `docs/design-docs/` and get cited by number.
3. **Close**: when validation passes, write the close-out — resolve every open question (a completed plan carries no `## Open questions` section; fold the answers into the body or the decision log), stamp `status: completed` and `completed:` — then move the file to `completed/`. If the work changed what the product *is*, update the owning note in the product KB (`docs/product-specs/`) in the same PR — the close is when behavior actually changed (design-doc 0006).
4. **After close, substance is frozen.** Goal, Context, Plan, and Validation are the historical record — never altered. To change course, write a new plan and flip the old one to `status: superseded` / `superseded-by: NNNN`. Lifecycle frontmatter and dated `## Decision log` entries stay writable (design-doc 0005).
5. Anything deliberately deferred during execution gets a row in `tech-debt-tracker.md` with an exit condition.

## Required sections

Every exec plan has exactly these top-level sections (mechanically enforced by the harness check):

```md
# NNNN — Title

## Goal
What will be true when this is done, in one or two sentences. Written in
CONTEXT.md vocabulary.

## Context
Why now, what exists already, which design-docs constrain this work.
Reference decisions by number (e.g. 0003) — don't restate them.

## Plan
Numbered stages. Each stage ends with how to verify that stage —
a command, an observable behavior, a file that must exist.

## Validation
How we know the whole thing works: the commands to run (`make check` at
minimum) and the observable outcomes that define done.
```

Optional sections when they earn their place: `## Out of scope`, `## Risks`, `## Decision log` (dated, append-only entries), `## Open questions` (active plans only — resolved and removed at close).

## Rules

- **Plans reference docs, not the reverse.** A plan cites design-docs and product-specs; it never becomes the place where decisions or specs live. Decision made mid-execution → `docs/design-docs/` + index entry, then cite it.
- **No file paths in Goal/Context** unless structural — paths rot; vocabulary doesn't.
- **One plan, one outcome.** If the Goal needs "and," it's two plans.
