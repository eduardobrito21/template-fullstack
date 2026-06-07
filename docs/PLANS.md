# PLANS.md — The ExecPlan Standard

Exec plans are the **unit of work** in this repo. Not issues, not tickets, not chat history — a markdown file in `docs/exec-plans/` is how work is specified, tracked, and remembered.

## The bar

An exec plan is **self-contained**: a beginner — human or agent, with no access to the conversation that produced it — could read it and implement the feature end to end. If executing the plan requires asking its author something, the plan is not done being written.

## Lifecycle

```
docs/exec-plans/
├── active/        ← being written or being executed
├── completed/     ← done; moved here verbatim, never rewritten
└── tech-debt-tracker.md
```

1. **Draft** the plan in `active/` as `NNNN-slug.md` (scan for the highest existing number across both directories, increment).
2. **Execute** against it. If reality contradicts the plan, update the plan first, then the code — the plan stays truthful throughout.
3. **Complete**: when validation passes, move the file to `completed/` unchanged. It is now the historical record.
4. Anything deliberately deferred during execution gets a row in `tech-debt-tracker.md` with an exit condition.

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

Optional sections when they earn their place: `## Out of scope`, `## Risks`.

## Rules

- **Plans reference docs, not the reverse.** A plan cites design-docs and product-specs; it never becomes the place where decisions or specs live. Decision made mid-execution → `docs/design-docs/` + index entry, then cite it.
- **No file paths in Goal/Context** unless structural — paths rot; vocabulary doesn't.
- **One plan, one outcome.** If the Goal needs "and," it's two plans.
