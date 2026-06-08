# Product KB

The **product knowledge base** — the living view of what the product *is*.
This file is its map of content: every note gets a one-line annotated entry
in its type's section below (sync mechanically enforced).

Everything in the vault is current truth, edited in place. History is git;
the *why* behind a shape lives in [the design docs](../design-docs/index.md)
and is cited by number. Notes carry **no frontmatter** — lifecycle metadata
is the frozen layer's mark; presence in the vault is the status
(design-doc 0006).

Structure (0006):

- Flat directory; folders only past ~25 notes, partitioned by product
  area, never by note type.
- Noun-phrase filenames, no versions or dates: `progress-pipeline.md`,
  never `v2-progress-pipeline.md` — a living view has a git log, not a
  version.
- Standard relative markdown links only; Obsidian wiki-link syntax is
  banned (mechanically enforced).
- Admission test: would the sentence survive a rewrite in another stack?
  Operational data stays in code — a note documents the knowledge *about*
  it and points at the code holding it.
- Growth by extraction: the third time a fact gets re-explained, it is a
  note announcing itself. Death by orphanhood: a note nothing links to
  gets deleted.
- Writes ride three rituals — grilling, spec work, and plan close
  ([PLANS.md](../PLANS.md)) — never scheduled gardening.

## Area specs

One per product surface: its current intended behavior. PRD-shaped —
problem, solution, stories, decisions, out-of-scope — amended in place as
the surface evolves.

_None yet._

## Knowledge

Domain facts: the math, the sources, external reality — and why we trust
them.

_None yet._

## Principles

The laws the product must obey. Short.

_None yet._
