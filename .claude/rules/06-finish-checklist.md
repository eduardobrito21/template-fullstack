# 06 — Finish checklist

**Enforced by:** `make check` for the verification half (template
state: `scripts/check_harness.sh`); the rest is prose-only — enforced
by review.

Run this short pass before handing off non-trivial work.

## Contract

- Behavior traces to a product spec or the active exec plan (rule 00).
- New decisions, commands, and compromises are recorded in the right
  harness file (design-doc, plan, tech-debt-tracker, rule, or
  AGENTS.md).
- No completed exec plan or design-doc had its substance rewritten in
  place — lifecycle frontmatter and decision-log entries are fine
  (design-doc 0005).
- The completed plan moved to `completed/` in this same PR.

## Boundaries and types

- External input is validated at the boundary (rule 01).
- Shared shapes have one canonical definition; nothing got duplicated
  across modules or packages.
- No new unjustified type-system escape hatches (rule 02).

## Runtime

- Errors use the canonical envelope; logs are structured and carry
  the correlation id (rules 01, 03).
- Config is read from the boot-time validated object, not the
  environment directly.
- Layering respects `ARCHITECTURE.md` and its structural check.

## Verification

`make check` passes (template state: `scripts/check_harness.sh`).
That is the only definition of done. State clearly if verification
was skipped and why.

## Do not

- Hand off with a red or unrun `make check` without saying so.
- Declare work done from reasoning alone when the change is
  observable — run it, render it, or test it (AGENTS.md rule 4).
- Treat this checklist as a substitute for the rules it summarizes.
