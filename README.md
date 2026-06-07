# Harness Template

A repo template whose value is the **harness** — the scaffolding that lets agents operate a repo end-to-end — not a stack. No application code ships here; the stack is chosen per-project at instantiation.

Built on the harness-engineering principles ([OpenAI, 2026](https://openai.com/index/harness-engineering/)): everything in the repo as markdown, a map not a manual, mechanical enforcement over documentation, agents that can verify their own work.

## What ships

```
AGENTS.md                  # ~100-line map — the agent's entry point (line budget enforced)
ARCHITECTURE.md            # code map skeleton: layers, invariants, entry points
CONTEXT.md                 # domain glossary (template's own, reset at instantiation)
docs/
├── PLANS.md               # the ExecPlan standard — the unit of work
├── design-docs/           # numbered decisions + index + core-beliefs.md
├── exec-plans/            # active/ → completed/, tech-debt-tracker.md
├── product-specs/         # PRDs, indexed
├── references/            # vendored <tool>-llms.txt docs
├── generated/             # machine-owned
├── DESIGN.md              # UI principles skeleton
└── SECURITY.md            # security skeleton
scripts/check_harness.sh   # the harness verifies itself (POSIX shell, no runtime)
.claude/rules/             # conduct rules — stack principles, concretized at instantiation
.claude/skills/init-project/  # the instantiation procedure
.github/workflows/ci.yml   # runs the harness check on every PR
```

## Usage

1. Create a repo from this template (`gh repo create my-project --template <this-repo>`).
2. Open it with your agent and run the **init-project** skill: it interviews you for name/stack/surfaces, scaffolds the stack, wires the Makefile contract (`check` / `test` / `lint` / `typecheck` / `dev`), resets the template's meta-docs, and seeds the first exec plan.
3. From then on: work arrives as exec plans, decisions land in design-docs, and `make check` is the only definition of done.

## The contract

Every instance exposes the same five make targets — agents never need per-repo knowledge to verify their work. Until a stack is wired, the harness verifies itself: `scripts/check_harness.sh`.

## License

MIT
