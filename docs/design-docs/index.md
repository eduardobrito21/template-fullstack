# Design Docs

One-line index of recorded decisions. Add an entry when adding a decision record. Records carry lifecycle frontmatter (`status: accepted | superseded`, `date:`, `superseded-by:` when superseded); substance freezes on merge — supersede, don't rewrite (0005).

- [0001 — The template ships a harness, not a stack](0001-stack-agnostic-harness.md)
- [0002 — The template dogfoods its own harness; instantiation resets it](0002-dogfood-and-reset.md)
- [0003 — No Makefile ships; the contract is prose, the harness check is a script](0003-no-makefile-until-instantiation.md)
- [0004 — A rules tier between the map and the docs](0004-rules-tier.md)
- [0005 — Substance freezes; lifecycle metadata lives](0005-substance-freezes-metadata-lives.md)
- [0006 — product-specs is a knowledge base, not a PRD archive](0006-product-specs-is-a-knowledge-base.md)
