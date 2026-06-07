# Architecture

> A **code map, not a code atlas**: this file records the structural shape of the system — layers, dependency directions, invariants — not implementation detail. If a sentence would go stale when a file moves, it doesn't belong here.
>
> **Template state:** no stack exists yet. `/init-project` fills the sections below when the stack is wired; until then they define what an instance must document.

## System shape

_One paragraph: the major components and how they talk. A reader should be able to draw the boxes-and-arrows from this alone._

## Layers and dependency directions

_The layer stack, lowest to highest, and the rule (dependencies point one way). Example shape:_

```
Types → Config → Persistence → Services → Runtime → UI
```

_Violations should be mechanically detectable — when the stack is wired, add a structural check and reference it here._

## Structural invariants

_The rules that survive refactors: what may import what, where side effects are allowed, what is append-only, what is machine-owned. Each invariant names the check that enforces it (or a tech-debt row for why it's unenforced)._

## Entry points

_Where execution starts: binaries, servers, schedulers, CLIs — and the one-line purpose of each._
