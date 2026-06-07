# 01 — Boundaries and contracts

**Enforced by:** prose-only — enforced by review (instances should add
a lint rule or structural check where the stack allows).

Every value crossing a boundary is parsed and validated at that
boundary with the stack's schema/validation library. Inside the
validated core, trust the types.

A typed core is only as trustworthy as the validation at its edges —
one upstream change can otherwise silently corrupt internal state.
There is no "trust this just this once" escape hatch: if a value
enters the core without being parsed, that's a bug.

Boundaries include HTTP requests and responses, config and environment
variables, files, subprocess stdio, database rows crossing into the
domain, and any third-party API response.

<!-- init-project: replace this block with the chosen stack's idiom, then delete the markers -->
Source-instance illustration (TypeScript + zod):

```ts
// Good — parse at the fetch boundary
const body = OrchestratorStateSchema.parse(await res.json());

// Bad — cast at the boundary
const body = (await res.json()) as OrchestratorStateWire;
```
<!-- /init-project -->

## Config is parsed once, at boot

Each process parses environment variables once at startup through a
schema and exports a typed config object. Application code never reads
the environment directly. Missing or malformed required config fails
startup loudly.

<!-- init-project: replace this block with the chosen stack's idiom, then delete the markers -->
```ts
const EnvSchema = z.object({ API_KEY: z.string().min(1) });
export const env = EnvSchema.parse(process.env);
// Bad: const key = process.env.API_KEY ?? '';
```
<!-- /init-project -->

## One error envelope

Every non-2xx response from this repo's services uses one flat,
canonical error shape carrying a machine code, a human-readable
description, and a per-request correlation id that also appears in a
response header and in log lines — one id ties UI report, wire
response, and logs together.

<!-- init-project: define the envelope's exact fields here at instantiation, then delete the markers -->
Source-instance shape: `{ code: UPPERCASE, description, details?, trace_id }`.
<!-- /init-project -->

## Closed sets are defined once

A finite set of values (states, kinds, priorities) has one canonical
definition; the runtime validator and the static type both derive from
it. Never maintain parallel lists in two modules or two packages —
shared wire shapes live in one shared place, imported by every
consumer.

<!-- init-project: replace this block with the chosen stack's idiom, then delete the markers -->
```ts
export const ISSUE_STATE = ['todo', 'in_progress', 'done'] as const;
export type IssueState = (typeof ISSUE_STATE)[number];
export const IssueStateSchema = z.enum(ISSUE_STATE);
```
<!-- /init-project -->

## Do not

- Cast, coerce, or type-ignore at a boundary to avoid validation.
- Pass unvalidated input into the domain core or the UI.
- Inline ad hoc request/response schemas in handlers — define them
  where the boundary's schemas live.
- Return ad hoc error bodies (`{ message }`, raw stack traces).
- Read secrets or flags from the environment outside boot-time config.
