#import "common.typ": diag

#let oopsmate_section() = [
== OopsMate ( Engine's Crate )

`OopsMate` is the primary engine crate (`oops_mate`) that handles UCI I/O, position state management, move generation, search and evaluation.

=== Engine Structure

#diag(
  "../artefact-diagrams/oopsmate/component-diagram-engine.svg",
  "Component architecture of the OopsMate engine",
)

=== Core Domain Types and Position State

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

The `Position` struct represents the game state (pieces, side to move, castling, en passant, and counters). This enables passing the state to the other components such as the evaluation, search and move generation.

=== Search and Caching

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

=== Runtime Control Flow

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

At runtime, `main.rs` initializes attack-table warmup and search parameters, then enters the UCI loop. 
]
