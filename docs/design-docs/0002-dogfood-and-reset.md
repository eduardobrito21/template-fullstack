---
status: accepted
date: 2026-06-07
---

# The template dogfoods its own harness; instantiation resets it

The template's own design decisions, exec plans, and glossary live in the very `docs/` schema it ships (this file is proof). Since the template has no stack, dogfooding is its only demonstration that the harness works. At instantiation, `/init-project` applies an explicit keep/clear list: **keep** the transferable layer (`PLANS.md`, `core-beliefs.md`, format definitions, index skeletons, domain files), **clear** the template-specific layer (numbered design-docs about the template itself, template exec plans, template glossary entries), and **seed** the instance's first exec plan ("wire the Makefile contract to <chosen stack>").

## Considered Options

- **Separate meta area** (`.template/docs/`) — rejected: cleaner stamping, but the template would no longer dogfood the schema it ships.
- **Dogfood + keep** (instances inherit template design history) — rejected: every project would start with noise about a repo it no longer is.
