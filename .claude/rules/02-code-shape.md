# 02 — Code shape

**Enforced by:** the stack's linter/type checker via `make check` where
possible (exhaustiveness, floating async, explicit public types);
shape limits are prose-only — enforced by review.

After a boundary has been validated (rule 01), write ordinary code and
let the compiler or type checker protect the domain model.

## Functions are small and shallow

- About 40 lines or less.
- About 3 nesting levels or less.
- One job per function; decision and side effect rarely share one.
- Early returns over `else` pyramids.
- Three or fewer positional parameters; past that, a named options
  object (or the stack's keyword-argument equivalent).

## Closed sets are handled exhaustively

Branching over a closed set covers every member, checked by the
compiler or linter where the stack allows; an unhandled member is a
build failure, not a runtime surprise.

<!-- init-project: replace this block with the chosen stack's idiom, then delete the markers -->
```ts
switch (state) {
  case 'todo': /* ... */ break;
  case 'done': /* ... */ break;
  default: {
    const _exhaustive: never = state; // compile error on new member
    throw new Error(`unhandled state: ${String(_exhaustive)}`);
  }
}
```
<!-- /init-project -->

## Failures: values for the expected, exceptions for the exceptional

Model expected failures (not found, invalid input, conflict) as return
values or tagged variants the caller must handle. Throw/raise only for
truly exceptional conditions.

## A module's exports are its public API

Export only what another module needs. No wildcard barrels. Do not
export a helper just so tests can reach it — test through public
behavior, or promote the helper to its own public unit deliberately.

## Derive variants from the canonical shape

Subsets, partials, and request/response variants of an entity derive
from the canonical definition instead of copying field lists — copied
lists drift silently.

<!-- init-project: replace this block with the chosen stack's idiom, then delete the markers -->
```ts
export type IssueSummary = Pick<Issue, 'id' | 'title' | 'state'>;
export const UpdateIssueRequest = IssueSchema.pick({ title: true }).partial();
// Bad: interface IssueSummary { id: string; title: string; state: string }
```
<!-- /init-project -->

## Escape hatches are justified in place

Any type-system escape hatch (cast, ignore-directive, dynamic typing
in typed code) requires a nearby comment explaining why it is sound.
The default fix is to validate, narrow, or improve the upstream type.

## Do not

- Duplicate field lists for the same entity when a derived shape
  would stay tied to the canonical one.
- Cast away a compiler/checker error you have not understood.
- Mutate caller-owned data when a copy would keep ownership clear.
- Leave floating/unawaited async work.
- Add commented-out code or TODOs without an exec plan or
  tech-debt-tracker entry.
