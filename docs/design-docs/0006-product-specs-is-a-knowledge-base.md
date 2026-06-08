---
status: accepted
date: 2026-06-07
---

# 0006 — product-specs is a knowledge base, not a PRD archive

## Decision

`docs/product-specs/` is the **product knowledge base** (product KB): the
living, materialized view of what the product *is* — the PM's brain,
externalized. It holds three note types, distinguished only by index
section — never by folder, never by frontmatter:

- **Area specs** — one per product surface: its current intended behavior,
  PRD-shaped (problem / solution / stories / decisions / out-of-scope),
  amended in place as the surface evolves.
- **Knowledge** — domain facts: the math, the sources, external reality —
  and why they are trusted. Operational data stays in code; the note
  documents the knowledge *about* it and points at the code holding it.
- **Principles** — the laws the product must obey; the instinct, written
  down. Short.

PRD-shaped specs are one note type inside the vault, not the whole of it.

This rests on a two-layer view of the repo's documents. The **frozen
layer** — design docs and completed exec plans — is the event log:
append-only, superseded never rewritten, marked by lifecycle frontmatter
(0005). The **living layer** — AGENTS.md, CONTEXT.md, ARCHITECTURE.md, and
the product KB — is the set of materialized views: edited in place. The
symmetry with 0005 is exact: lifecycle frontmatter is the frozen layer's
mark, so **vault notes carry none**. Presence in the vault is the status,
git is the history, and the *why* behind a shape cites design docs by
number.

Structure: flat directory — folders only past roughly 25 notes, and then
partitioned by product area, never by note type. Noun-phrase filenames
without versions or dates: a living view has a git log, not a version.
Standard relative markdown links only; Obsidian wiki-link syntax is banned
and mechanically checked, because it silently escapes the harness link
checker and breaks GitHub rendering. Admission test: a sentence belongs if
it would survive a full rewrite in another stack. Growth by extraction —
the third re-explanation of a fact is a note announcing itself; death by
orphanhood — a note nothing links to is deleted.

Maintenance is by trigger, never goodwill. The vault is written at three
existing ritual moments: grilling (a product fact crystallizes → it lands
in the owning note immediately), spec work (amend the owning area note
instead of spawning siblings), and plan close (behavior actually changed →
"did this change what the product is?" — update the owning note in the
same PR). No fourth trigger, no scheduled gardening.

## Why

Living docs rot when maintained by goodwill and survive when maintained by
trigger and kept load-bearing. Rule 00 already forces every behavior
change through `docs/product-specs/`, and agents are obnoxiously literal
readers — an agent acting on a stale note produces visible wrongness
within a session, not a quarter. A vault read on every change and written
at every close stays true the way help-center docs do: its users punish
drift.

## Alternatives rejected

- **One giant spec file** (the source instance's model): no per-surface
  ownership, a merge conflict on every product change, and no home for
  knowledge or principles that span surfaces.
- **A frozen PRD archive** (the default corp disease): specs describe what
  surfaces were at proposal time, the current product lives only in heads,
  and every new PRD re-litigates ground truth.

## Consequences

- `docs/product-specs/index.md` is the vault's map of content: a
  definition header plus three type sections of one-line annotated
  entries.
- `scripts/check_harness.sh` rejects wiki-link syntax anywhere under
  `docs/product-specs/`; index-sync and link integrity were already
  enforced and are not duplicated.
- The write triggers are named where each ritual is defined: the close
  step in `docs/PLANS.md`, the finish checklist (rule 06), and the
  harness-first contract (rule 00).
- AGENTS.md, README.md, CONTEXT.md, and the init-project reset list
  describe the directory as the product KB.
