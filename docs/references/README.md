# References

Vendored reference material for the libraries and tools this project leans on — primarily `<tool>-llms.txt` files (the llms.txt convention: condensed, LLM-ready documentation published by the tool's maintainers).

## Why vendor docs into the repo?

What the agent can't see doesn't exist. Model training data lags releases and APIs drift; a vendored reference pins the version of the truth this repo builds against, offline and grep-able.

## Conventions

- Name files `<tool>-llms.txt` (e.g. `uv-llms.txt`, `nixpacks-llms.txt`).
- Prefer the official llms.txt when the project publishes one; otherwise a hand-curated extract is fine — note the source URL and date in the first line.
- Refresh when upgrading the tool, not on a schedule.
