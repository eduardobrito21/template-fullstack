---
status: completed
created: 2026-06-07
completed: 2026-06-07
---

# 0002 — Port the rules tier from the symphony instance

## Goal

The template ships a `.claude/rules/` tier: short, stack-agnostic rule files that carry the depth AGENTS.md's line budget can't — when work needs an exec plan, boundary discipline, code shape, runtime hygiene, data invariants, docstring policy, and a finish checklist — each with stack-idiom placeholders that instantiation concretizes.

## Context

A production instance of the harness style exists at `~/Developer/personal/my-own-symphony` (github.com/eduardobrito21/my-own-symphony). Its `.claude/rules/` (10 files, ~1,100 lines) is the most battle-tested part of that repo and the template currently has no equivalent: AGENTS.md carries six working rules in ~10 lines and stops there. Notably, the template says "non-trivial work starts as a plan" but never defines non-trivial — the instance's rule 00 defines it with four mechanical triggers.

The instance's rules split into three buckets:

- **A — stack-agnostic, port nearly verbatim**: `00-project-contract`, `08-docstrings`, `06-finish-checklist`.
- **B — stack-agnostic principles in TypeScript clothing**: `01-boundaries-and-contracts` (parse-don't-trust via zod), `02-typescript-core` (code shape via branded types), `03-http-and-logs`, `04-data-and-migrations` (via Prisma). The principles transfer; the idioms are per-stack.
- **C — instance-specific, do not port**: `05-frontend`, `07-shared-package`, `graphite.md`. Their *shape* (current state → graduation trigger → do-not list) informs what init-project should generate per stack.

Constraints from existing decisions: 0001 (template ships a harness, not a stack — so no zod/pnpm/Prisma specifics may survive in template rules), 0002 (dogfood-and-reset — the rules must be valid for the template repo itself, then concretized at instantiation), core-beliefs (mechanical enforcement over documentation — every rule names its enforcing check or admits it is prose; rules stay short).

Two source patterns to preserve throughout: every rule ends with a **"Do not"** section (explicit negative space), and history lives in design-docs/exec-plans, never in the rules themselves.

## Plan

1. **Record the decision.** Write `docs/design-docs/0004-rules-tier.md`: a `.claude/rules/` tier sits between the AGENTS.md map and `docs/` depth — always-loaded conduct rules, ≤120 lines each, stack principles in the template with `<!-- init-project: ... -->` markers concretized at instantiation; the trade-off accepted vs. the mechanical-enforcement belief is that conduct rules (when to plan, what a docstring is for) cannot all be linted, so each rule must name its enforcing check or explicitly state "prose-only". Add the entry to `docs/design-docs/index.md`. Verify: `scripts/check_harness.sh` exits 0.

2. **Write the seven template rules** in `.claude/rules/`, named `NN-slug.md`, each ≤120 lines, each ending with `## Do not`. Source material is the instance's rules; the table below is the content contract. Stack idioms appear only inside `<!-- init-project: concretize for stack -->` HTML-comment blocks containing the instance's TypeScript examples as *illustrations to be replaced*, never as requirements.

   | File | Carries (from source) | Generalization moves |
   |---|---|---|
   | `00-project-contract.md` | Harness-first: check AGENTS.md/product-specs before changing behavior. The exec-plan trigger list: touches multiple layers; introduces a module, dependency, public API, or external contract; makes a load-bearing data/protocol/layout choice; likely >1 hour. Trivial-edit carve-outs (typos, lockfile bumps, single-file non-behavioral refactors, tests for existing behavior). Immutable design-docs; debt rows need exit conditions; new commands go in the Makefile, not tribal knowledge; completed plans/index updates travel in the same PR. | Re-point paths to this repo's schema (`docs/PLANS.md`, `docs/design-docs/`, tech-debt-tracker). Drop the source's frontmatter block — `docs/PLANS.md` owns plan format; reference it. |
   | `01-boundaries-and-contracts.md` | Every value crossing a boundary is parsed at that boundary; inside the validated core, trust the types. Boundary inventory: HTTP, config/env, files, subprocess stdio, third-party API responses. Config parsed once at boot into a typed object — no scattered env reads. One canonical error envelope for all non-2xx responses, carrying a correlation/trace id. Closed sets defined once, canonically; derived everywhere else. | "zod" → "the stack's schema/validation library, chosen at instantiation". Envelope field names become a marker (the *one-shape* rule is the invariant, not the fields). |
   | `02-code-shape.md` | Small shallow functions: ~40 lines, ≤3 nesting levels, one job, early returns over else-pyramids, options object past 3 positional params. Exhaustive handling of closed sets (compiler- or linter-checked where the stack allows). Expected failures as return values; exceptions for the exceptional. A module's exports are its public API: export only what others need, no wildcard barrels, don't export helpers just for tests. Type-system escape hatches require a nearby justifying comment. Derive entity variants from the canonical shape instead of copying field lists. | Branded-ID / `Pick`/`Omit` / `never`-check examples go inside markers as illustrations. |
   | `03-runtime-and-logs.md` | Read/observability paths make no decisions — behavior lives in the owning layer; if a read path needs data, add a public getter, don't bypass. Structured logs: fields as fields, not interpolated strings; every request-scoped line carries the correlation id; one id correlates response header, error body, and log lines. Never log secrets, tokens, or raw third-party payloads — redaction is a backstop, not permission. Network exposure is loopback/private by default; widening it requires a design-doc and an auth story. | `node:http`/pino specifics → markers. "Framework adoption needs a design-doc once the surface grows" stays as the general anti-drift rule. |
   | `04-data.md` | IDs are prefixed, centrally minted; the type system distinguishes entity IDs where the stack allows. Timestamps UTC in storage, ISO 8601 with `Z` on the wire; calendar dates as `YYYY-MM-DD`. Schema encodes the domain (nullability, uniqueness, FKs, checks) — backfill bad data rather than loosening; the database is the last line of defense. Migrations are forward-only once pushed; undo with a new migration. Recursion has an explicit depth budget; prefer the database's recursive query over N-query loops. | Prisma/Postgres snippets → markers. State plainly that the rule binds *when* persistent storage exists. |
   | `05-docstrings.md` | Docstrings describe the code as it stands today — never its history. History's homes: design-docs, exec plans, tech-debt-tracker, git. Inline comments differ: a reference justifying a specific guard stays, judged by the test "does removing the reference make the next reader more likely to delete or break the code?". Don't restate signatures the type system already states; don't keep old docstrings "for reference". | s/JSDoc/the stack's docstring convention/ via one marker; otherwise near-verbatim. |
   | `06-finish-checklist.md` | Pre-handoff pass in four groups: contract (behavior traces to a spec or active plan; decisions/commands/compromises recorded in the right harness file; nothing completed was rewritten), boundaries (external input validated; no new unjustified escape hatches), runtime (shared error envelope; structured logs; config from the boot-time object), verification. State clearly if verification was skipped and why. | The source's four `pnpm` commands collapse to `make check` (template state: `scripts/check_harness.sh`). |

   Each rule's header names its enforcing check (`make check` component, harness check, or "prose-only — enforced by review"). Verify: 7 files exist; `grep -rE 'zod|pnpm|tsconfig|Prisma|Fastify' .claude/rules/` matches only inside `<!-- init-project` marker blocks.

3. **Surface the tier in the maps.** AGENTS.md: add a `.claude/rules/` row to "Where things live" and fold the exec-plan trigger into working rule 1 by reference ("non-trivial per `00-project-contract`"); stay within the 120-line budget. README.md: add `.claude/rules/` to "What ships". Verify: `scripts/check_harness.sh` exits 0 (budget + links).

4. **Teach init-project to concretize.** In `.claude/skills/init-project/SKILL.md`, add a step after "Scaffold the stack": for each rule, replace every `<!-- init-project -->` marker with the chosen stack's idiom (validation library, docstring convention, migration tool) and delete the marker; then generate stack-specific rules for surfaces the interview surfaced (e.g. a frontend rule, a shared-package rule) following the instance's shape — current state, the trigger for graduating to heavier tooling, a "Do not" list. Verify: the skill file reads coherently end-to-end and the step lists the marker-grep from stage 2 as its own done-signal (zero markers remain).

5. **Extend the harness check.** In `scripts/check_harness.sh` add: `.claude/rules` exists and is non-empty; every `.claude/rules/*.md` is named `NN-slug.md`; every rule file contains a `^## Do not` heading. (Do **not** check for markers — instances legitimately have none.) Verify: seed a temporary rule without a "Do not" section, confirm the check fails, remove it, confirm exit 0.

## Validation

- `scripts/check_harness.sh` exits 0 on the final tree, and fails when stage 5's seeded violation is present.
- `grep -rEn 'zod|pnpm|tsconfig|Prisma|Fastify|React' .claude/rules/` yields hits only within `<!-- init-project` marker blocks.
- AGENTS.md remains ≤120 lines.
- Read-through: each rule ≤120 lines, ends with `## Do not`, names its enforcing check, and contains no history (per its own rule 05).

## Out of scope

- Porting the instance's `settings.json` PreToolUse hook, permission allowlist, dependency-cruiser config, or `graphite.md` — separate plans if wanted.
- Writing any instance-specific rule content (frontend, shared-package) — that is init-project output, only its *procedure* lands here.
- CI changes — `ci.yml` already runs the harness check; stage 5 rides along.
