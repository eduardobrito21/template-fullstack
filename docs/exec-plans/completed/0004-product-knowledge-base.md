---
status: completed
created: 2026-06-07
completed: 2026-06-07
---

# 0004 — product-specs becomes the product knowledge base

## Goal

`docs/product-specs/` means one thing everywhere the harness speaks of it:
the product KB — the living view of what the product *is* — not a stack of
frozen PRDs. The index defines the vault, the harness check enforces its
link discipline, and the write triggers are wired where each ritual is
defined.

## Context

Instances outgrew the implicit meaning of `docs/product-specs/` as a PRD
archive. An archive rots: specs describe what surfaces *were* at proposal
time, and the current product ends up living only in heads. The fix splits
the repo's documents into two layers — frozen records (design docs,
completed exec plans: the event log, superseded never rewritten, 0005) and
living views (AGENTS.md, CONTEXT.md, ARCHITECTURE.md: edited in place).
`docs/product-specs/` belongs to the living layer, and PRD-shaped specs
are one note type inside it, not the whole of it. The decision and its
alternatives are recorded as design-doc 0006; this plan wires it through
the harness.

## Plan

1. Record design-doc 0006 ("product-specs is a knowledge base, not a PRD
   archive") with an index entry. Verify: index-sync section of the
   harness check is green.
2. Rewrite `docs/product-specs/index.md` as the vault's map of content:
   a header defining the product KB and its structural rules, then three
   sections (area specs, knowledge, principles) for one-line annotated
   entries. Verify: the file states the no-frontmatter rule, the link
   discipline, the admission test, and the three write triggers.
3. Extend `scripts/check_harness.sh`: no file under `docs/product-specs/`
   may contain Obsidian wiki-link syntax (two consecutive opening square
   brackets). Verify: a seeded wiki-link in a scratch note makes the check
   fail; removing it makes the check pass.
4. Wire the write triggers where each ritual is defined: the close step in
   `docs/PLANS.md`, the contract section of rule 06, the harness-first
   paragraph of rule 00. Verify: each names the vault duty in one line,
   citing 0006.
5. Update the living views that describe the directory: the AGENTS.md
   "Where things live" row, the README tree comment, a CONTEXT.md glossary
   entry for "Product KB", and the init-project reset list (the vault
   definition survives instantiation). Verify: AGENTS.md stays within its
   line budget.

## Validation

`scripts/check_harness.sh` exits 0. A seeded wiki-link inside any
`docs/product-specs/*.md` makes it exit 1 — observed during stage 3, then
removed. This plan closes per the lifecycle standard and moves to
`completed/` in the same change.

## Out of scope

- Renaming the directory — instances and global skills write to
  `docs/product-specs/` by path.
- Seeding example notes — instances grow their own by extraction.
- Note templates or frontmatter schemas for vault notes — the
  no-frontmatter rule is the point.
- Patching global skills (`to-prd`, `grill-with-docs`) — they live outside
  this repo and are patched from the session that owns them.

## Decision log

- 2026-06-07 — A mechanical no-frontmatter check on vault notes was
  considered alongside the wiki-link ban and deferred: the convention has
  never been violated, and working rule 5 (AGENTS.md) adds checks when a
  convention is caught broken, not speculatively. The wiki-link ban ships
  now because a wiki-link silently escapes the link-integrity check —
  corruption, not style.
