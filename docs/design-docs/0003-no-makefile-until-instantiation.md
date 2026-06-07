# No Makefile ships; the contract is prose, the harness check is a script

The template ships no Makefile — stub targets would either lie (exit 0 while verifying nothing) or be born broken (exit 1). Instead, the Makefile contract (`check`, `test`, `lint`, `typecheck`, `dev`) is a written requirement in AGENTS.md that `/init-project` satisfies by creating the Makefile when the stack is chosen. The template's only mechanical verification, `scripts/check_harness.sh` (POSIX tools only, so it runs in any sandbox — a language runtime can't be assumed before a stack exists), is invoked directly by CI and folded under `make check` at instantiation. The harness verifies itself; the stack verifies itself once it exists.

## Considered Options

- **Ship stub targets exiting 0 with a "not wired" notice** — rejected: `make check` reporting green while checking nothing is green theater.
- **Stubs exit 1 + `UNWIRED` marker file** — rejected: more machinery to express what absence expresses for free.
- **No contract at all** — rejected: a fixed verification entry point across all repos is the highest-value harness invariant.
