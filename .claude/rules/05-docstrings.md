# 05 — Docstrings

**Enforced by:** prose-only — enforced by review.

Docstrings — file-level headers and documentation on exported
functions, classes, and types — describe the code as it stands
**today**. They do not log the history of how the code got here.

The audience is someone (human or agent) who just opened the file and
needs to know what it IS — not which exec plan added which paragraph
or which library version introduced which field.

<!-- init-project: name the stack's docstring convention here (JSDoc, PEP 257, rustdoc, …), then delete the markers -->
Source instance used JSDoc on every public export.
<!-- /init-project -->

## Where history goes instead

- `docs/design-docs/` — durable decisions ("why X over Y").
- `docs/exec-plans/` — what a batch of work changed, with context.
- `docs/exec-plans/tech-debt-tracker.md` — compromises and exit
  conditions.
- Git history and PR descriptions — line-by-line provenance.

The docstring is none of those. Describe the module's current
features and invariants; no timeline ("plan 04 added X, plan 05
adds Y" is a chronological log, not a docstring).

## Inline comments are different

A comment justifying a specific block — typically a regression guard
or a non-obvious branch — may cite the plan, bug, or spec section
that motivated it. The reference is the *reason* for the line of
code, not historical color.

The test for whether a reference belongs: **does removing it make the
next reader more likely to delete or break the code?** If yes, it's
an inline guard comment and stays. If no, it's historical color and
moves to a design-doc, exec plan, or tech-debt entry.

## Do not

- List exec plans in file headers, or describe what the code USED
  to do.
- Reference library versions in docstrings — that's a manifest fact.
- Restate the signature the type system already states; describe
  behavior, not types.
- Leave the old docstring next to the new one "for reference" — pick
  the final version and delete the old.
