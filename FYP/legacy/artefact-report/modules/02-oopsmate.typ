#import "common.typ": diag

#let oopsmate_section() = [
= 2. OopsMate Engine

`OopsMate` is the primary engine crate (`oops_mate`) that provides UCI I/O, position state management, move generation, search, and transposition-table support.

== 2.1 Engine Structure

#diag(
  "../artefact-diagrams/oopsmate/component-diagram-engine.svg",
  "Component-level architecture of the OopsMate engine",
  w: 94%,
)

The component diagram reflects the modular split in `src/OopsMate/src/`, where protocol, search, movegen, and board-state logic are separate modules that interact through explicit data types.

== 2.2 Core Domain Types and Position State

#diag(
  "../artefact-diagrams/oopsmate/class-diagram-core-types.svg",
  "Core move, piece, and color domain types",
  w: 92%,
)

#diag(
  "../artefact-diagrams/oopsmate/class-diagram-position.svg",
  "Position representation and board-state responsibilities",
  w: 92%,
)

The position model centralizes game state (pieces, side to move, castling, en passant, and counters), enabling deterministic evaluation and reproducible search traversal.

== 2.3 Search and Caching

#diag(
  "../artefact-diagrams/oopsmate/class-diagram-search.svg",
  "Search subsystem classes and interactions",
  w: 74%,
)

#diag(
  "../artefact-diagrams/oopsmate/class-diagram-tpt.svg",
  "TT-table structures and lookup lifecycle",
  w: 64%,
)

The search pipeline combines iterative deepening, alpha-beta style pruning infrastructure, and shared transposition-table access. This supports stronger move ordering and reduced repeated work across similar positions.

== 2.4 Runtime Control Flow

#diag(
  "../artefact-diagrams/oopsmate/sequence-diagram-uci.svg",
  "UCI command handling and engine loop interaction",
  w: 92%,
)

#diag(
  "../artefact-diagrams/oopsmate/sequence-diagram-search-flow.svg",
  "Search invocation flow from input command to best-move output",
  w: 92%,
)

#diag(
  "../artefact-diagrams/oopsmate/activity-diagram-movegen.svg",
  "Move-generation activity from position to legal move list",
  w: 90%,
)

At runtime, `main.rs` initializes attack-table warmup and search parameters, then enters the UCI loop. The resulting flow is suitable for tournament-style integration with GUI frontends and testing harnesses.
]
