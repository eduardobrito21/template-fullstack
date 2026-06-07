# 04 — Data

**Enforced by:** prose-only — enforced by review (the schema itself is
the mechanical half: encode invariants there, not in app checks).

These rules bind wherever persistent storage exists; the identifier
and time rules apply to in-memory entities too. Prefer strict,
domain-correct data structures — correct or backfill bad data instead
of weakening the schema for convenience.

## Identifiers

- Primary keys are prefixed random strings (`issue_<random>`,
  `session_<random>`); the prefix↔entity mapping is centralized, and
  no module mints ids by hand.
- Where the stack allows, the type system distinguishes entity ids —
  passing an issue id where a workspace id is expected should fail
  before runtime.

<!-- init-project: replace this block with the chosen stack's idiom, then delete the markers -->
```ts
export type IssueId = string & { readonly __issueId: unique symbol };
archiveWorkspace(issueId); // compile error — IssueId ≠ WorkspaceId
```
<!-- /init-project -->

## Time

- Storage timestamps are UTC (`TIMESTAMPTZ` or epoch-ms), never naive
  local time.
- Wire timestamps are ISO 8601 with `Z`.
- Calendar dates on the wire are `YYYY-MM-DD` strings.

## The schema encodes the domain

Choose nullability, uniqueness, foreign keys, checks, and enum
membership from the domain, not from convenience. If existing rows
don't fit, write a cleanup or backfill; only loosen a column when the
real domain is loose. The database is the last line of defense — if
the domain has a finite set or a relationship, encode it in the
schema instead of relying only on application checks.

## Migrations are forward-only

Once a migration is committed or applied anywhere beyond your laptop,
it is immutable. To undo or adjust it, write a new migration.
Regenerating an unpushed local migration is fine.

## Recursion has a budget

Recursive traversals carry an explicit depth limit. When the database
can traverse a tree in one query (recursive CTE), prefer that over
N-query application loops.

## Do not

- Use serial integer primary keys.
- Store naive timestamps or emit local-time strings on the wire.
- Make a required field nullable just to avoid a backfill.
- Drop a constraint because cleanup is inconvenient.
- Edit a migration that teammates, staging, or production may have run.
- Write unbounded recursive traversal without an exec plan.
