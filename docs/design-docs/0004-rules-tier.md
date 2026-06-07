---
status: accepted
date: 2026-06-07
---

# 0004 — A rules tier between the map and the docs

## Decision

The harness ships `.claude/rules/` — short conduct-rule files (≤120 lines each, named `NN-slug.md`) that sit between the AGENTS.md map and `docs/` depth. AGENTS.md tells an agent *where* things live; rules tell it *how to behave* while working: when work needs an exec plan, boundary discipline, code shape, runtime hygiene, data invariants, docstring policy, and the finish checklist.

Rules state stack-agnostic principles. Stack idioms (validation library, docstring convention, migration tool) appear only inside marker blocks:

```
<!-- init-project: replace this block with the chosen stack's idiom, then delete the markers -->
...illustration from the source instance...
<!-- /init-project -->
```

The `init-project` skill concretizes every marker at instantiation; an instance has zero markers. Unlike numbered design-docs, rules are **kept** at instantiation (concretized, not cleared) — they are part of the transferable layer per 0002.

## Why

A production instance of this harness style (`my-own-symphony`) proved the tier's value: its rules carried the discipline AGENTS.md's line budget cannot — most critically a mechanical definition of "non-trivial work" (the exec-plan trigger list) that the template previously asserted but never defined.

## Trade-off accepted

Core-beliefs prefers mechanical enforcement over documentation, and ~600 lines of rules is documentation. Accepted because conduct rules (when to plan, what a docstring is for) cannot all be linted. Mitigations, both load-bearing:

- Every rule names its enforcing check in an **Enforced by** line, or admits `prose-only — enforced by review`.
- Structure is mechanically checked: `scripts/check_harness.sh` verifies the directory exists, naming, and that every rule ends with a `## Do not` section (explicit negative space — a pattern lifted from the source instance).

## Consequences

- The harness check grows three rules-tier checks (and they survive instantiation).
- `init-project` gains a concretize step and may generate additional instance rules (frontend, shared package) following the shape: current state → graduation trigger → "Do not".
- A repeated rule still becomes a check (AGENTS.md working rule 5) — the rules tier is not an excuse to accrete prose.
