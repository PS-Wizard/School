#import "common.typ": diag

#let overview_section() = [
== Overall Architecture Overview

=== System Architecture View

#diag(
  "../artefact-diagrams/overview/architecture-overview.svg",
  "System-wide overview of OopsMate, nnuebie, strikes, and utilities",
)

=== Dependency View

#diag(
  "../artefact-diagrams/overview/dependency-graph.svg",
  "Dependency graph of engine and support crates",
)

- `oops_mate` directly depends on `strikes` and `utilities`.
- `strikes` provides attack/path tables consumed by move generation. 
- `utilities` provides notation and board helpers used by supporting logic and tests.
- `nnuebie` is maintained as a separate crate outside OopsMate's workspace.
]
