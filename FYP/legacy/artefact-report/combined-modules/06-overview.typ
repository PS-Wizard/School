#import "common.typ": diag

#let overview_section() = [
== Cross-Cutting Architecture

This section consolidates subsystem relationships and build-time dependencies across the project.

=== System Architecture View

#diag(
  "../artefact-diagrams/overview/architecture-overview.svg",
  "System-wide architecture across OopsMate, nnuebie, strikes, and utilities",
)

=== Dependency View

#diag(
  "../artefact-diagrams/overview/dependency-graph.svg",
  "Dependency graph of engine and support crates",
)

From the current codebase:

- `oops_mate` directly depends on `strikes` and `utilities`.
- `strikes` provides attack/path tables consumed by move generation.
- `utilities` provides notation and board helpers used by supporting logic and tests.
- `nnuebie` is maintained as a separate crate intended for engine-side evaluation integration through piece-square feature interfaces.
]
