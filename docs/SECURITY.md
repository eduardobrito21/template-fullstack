# Security

> Filled at instantiation; the section structure is the contract.

## Secrets

_Where secrets live (env files, manager), what is never committed, and the mechanical check that enforces it. `.env*` files are gitignored from day one._

## Authentication & authorization

_Who can do what, where it's enforced (middleware/dependency layer), and the rule that authz checks live at one layer only._

## Data handling

_What is PII here, where it's stored, what must be redacted from logs._

## Threat notes

_Known exposure surfaces and accepted risks, each with a design-doc or tech-debt reference._
