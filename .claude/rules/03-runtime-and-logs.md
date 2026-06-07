# 03 — Runtime and logs

**Enforced by:** prose-only — enforced by review (instances should add
a structural/dependency check for the layering half and reference it
from `ARCHITECTURE.md`).

## Read paths make no decisions

Observability and read surfaces (HTTP getters, dashboards, status
endpoints) adapt internal state for consumers; behavior lives in the
owning layer. If a read path needs data the owning layer doesn't
expose, add a public getter on that layer — don't reach past it into
lower layers.

## Logs are structured

- Event fields as fields, never interpolated into the message string.
- Every request-scoped line carries the correlation id from rule 01 —
  one id correlates response header, error body, and log lines.
- No bare print/console output in service code; everything goes
  through the project's logger.

<!-- init-project: replace this block with the chosen stack's idiom, then delete the markers -->
```ts
reqLog.info('skill started', { issue_id, project_slug, skill: '@coder' });
// Bad: console.log(`issue ${issue_id} starting @coder`);
```
<!-- /init-project -->

## Never log secrets

No secrets, bearer tokens, or raw third-party payloads that may carry
user content in logs. If the logger redacts token-shaped values, treat
that as a backstop — not permission to log raw payloads.

## Exposure is opt-in

Services bind loopback/private interfaces by default. Widening
exposure to a network requires a design-doc and an auth story —
"only our client calls this" is not an auth story, and it doesn't
waive boundary validation (rule 01) either.

## Dependencies grow via decisions

Adopting a framework or infrastructure component for a surface that
doesn't yet need it (a web framework for two endpoints, a logging
framework for one process) is a recorded decision, not a default.
Revisit via a new design-doc when the surface grows.

## Do not

- Put business logic (state transitions, retries, scheduling) in
  read/route handlers.
- Skip validation because "only our own client calls this".
- Log with string interpolation, or log secrets/raw payloads.
- Bind to a non-loopback interface without a design-doc and auth.
- Adopt a framework piecemeal — it comes in via a design-doc, fully,
  or not at all.
