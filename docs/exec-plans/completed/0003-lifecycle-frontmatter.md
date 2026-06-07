---
status: completed
created: 2026-06-07
completed: 2026-06-07
---

# 0003 — Lifecycle frontmatter for plans and design docs

## Goal

Exec plans and design docs carry lifecycle frontmatter — status, dates, supersession — that stays editable after close, while their substance freezes; the harness check enforces the status↔directory sync mechanically.

## Context

The harness said "immutable" and "moved verbatim, never rewritten" about closed documents (rule 00, the ExecPlan standard), conflating rewriting history with recording it: status flips, date stamps, supersession pointers, and decision-log entries are normal late edits. Decision 0005 records the policy split — substance freezes, lifecycle metadata lives. Constraints: 0004 (rules name their enforcing check), core-beliefs 3 (mechanical enforcement over documentation — hence a check, not just prose).

## Plan

1. Record decision 0005 and index it. Verify: index links resolve.
2. Add the frontmatter standard (status closed set, dates, `superseded-by`) and an explicit close step to the ExecPlan standard; reword rules 00 and 06 from "immutable"/"unchanged" to substance-freeze. Verify: read-through leaves no contradicting wording.
3. Backfill frontmatter on existing design docs (`status: accepted`, `date:`) and completed plans (`status: completed`, `created:`, `completed:`), dates from git history. Verify: every numbered doc starts with `---`.
4. Extend the harness check: status membership and directory↔status sync for plans, required date formats, `superseded-by` when superseded, frontmatter on numbered design docs, and no `## Open questions` section in completed plans. Verify: the check passes on the final tree and fails when a violation is seeded.

## Validation

- `scripts/check_harness.sh` exits 0 on the final tree.
- Seeding `status: draft` into a completed plan makes the check fail; reverting restores green.
- AGENTS.md stays within its line budget; all index links resolve.

## Decision log

- 2026-06-07 — Plan `status:` is canonical in frontmatter; the directory mirrors it. Chosen over directory-only so status is visible inside the file, accepting the dual-source risk with a mechanical sync check (0005).
- 2026-06-07 — No `proposed` status for design docs: a record is written when the decision is made; `accepted | superseded` is the whole set.
