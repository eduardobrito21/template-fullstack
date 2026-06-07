# Core Beliefs

The principles this harness is built on. Numbered design-docs record *decisions*; this file records the *worldview* that produces them. It transfers unchanged to every instance.

## 1. What the agent can't see doesn't exist

Every decision, spec, plan, and constraint lives in the repo as markdown. If it's in a chat history, a head, or an external tracker, it doesn't exist. Corollary: writing things down *in the standard locations* is part of the work, not overhead after it.

## 2. A map, not a manual

`AGENTS.md` is a table of contents with a hard line budget, not an encyclopedia. Context is scarce; a giant instruction file crowds out the task. Depth lives in `docs/` and is read on demand — progressive disclosure applied to agent context.

## 3. Mechanical enforcement over documentation

A rule that matters becomes a check (`scripts/check_harness.sh`, linters, structural tests), not a paragraph. Prose rules decay; checks don't. When an agent violates a convention, the fix is a new check, not a sterner sentence.

## 4. Give the agent eyes

An agent must be able to observe the consequences of its changes — run the thing, see the output, query the logs. Verification is a capability we build, not a discipline we hope for. `make check` is the floor, never the ceiling.

## 5. Ask what capability is missing, not why the agent failed

When an agent fails, the question is "what would have let it succeed?" — a missing doc, a missing check, a missing tool. Fixing the instance by hand and moving on wastes the failure. The harness compounds; manual fixes don't.

## 6. Humans steer; agents execute

Human attention goes into decisions (design-docs), specifications (product-specs), and plans (exec-plans) — then agents execute against mechanical verification. Reviewing a diff is steering; writing the diff is not.
