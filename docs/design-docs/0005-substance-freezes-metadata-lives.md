---
status: accepted
date: 2026-06-07
---

# 0005 — Substance freezes; lifecycle metadata lives

## Decision

Exec plans and design docs carry YAML frontmatter for lifecycle metadata. For plans, `status:` (`draft | executing | blocked | completed | superseded`) is canonical and the `active/` → `completed/` move mirrors it; for design docs, `status:` is `accepted | superseded`. Both carry dates (`created:`/`completed:` for plans, `date:` for design docs) and `superseded-by: NNNN` when superseded.

"Don't rewrite history" binds the **substance** — a plan's Goal/Context/Plan/Validation, a record's Decision/Why — which freezes at close (plans) or merge (design docs). Lifecycle frontmatter and dated, append-only `## Decision log` entries stay writable forever. Close-out content — resolving open questions, outcomes — is written during the close, as part of the document's life.

## Why

The previous wording ("immutable", "moved verbatim, never rewritten") protected against rewriting history: editing a closed document to make new work look pre-approved. But it also banned edits that *record* history — status flips, date stamps, supersession pointers, decision-log entries — forcing supersession information away from the record it concerns and making the normal close process technically a violation.

## Trade-off accepted

Plan status now lives in two places — frontmatter and directory — which can drift. Accepted for scanability (status is visible in the file and in a directory listing alike); mitigated by a mechanical sync check in `scripts/check_harness.sh`.

## Consequences

- `docs/PLANS.md` gains the frontmatter standard and an explicit close step; `## Open questions` may not survive into `completed/`.
- Rules 00 and 06 reword "immutable"/"unchanged" to substance-freeze.
- Existing plans and design docs are backfilled with frontmatter — itself a metadata edit, normal under this decision.
- The harness check enforces status membership, directory↔status sync, date formats, and `superseded-by` presence.
