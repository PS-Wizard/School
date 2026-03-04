#import "common.typ": diag

#let utils_section() = [
== Utilities Support Crate

`utilities` contains shared helper functionality for square notation and board visualization. Although small in size, it improves readability and consistency across debugging, test, and development workflows.

=== Utility Class Structure

#diag(
  "../artefact-diagrams/utils/class-diagram-utilities.svg",
  "Class-level structure of notation and board utility helpers",
  w: 90%,
)

=== Parsing and Rendering Activities

#diag(
  "../artefact-diagrams/utils/activity-diagram-fen-parsing.svg",
  "Activity flow for FEN parsing into internal board state",
  w: 52%,
)

#diag(
  "../artefact-diagrams/utils/activity-diagram-board-visualization.svg",
  "Activity flow for board-state visualization utilities",
  w: 48%,
)

These utility flows reduce incidental complexity in higher-level modules by keeping parsing and formatting concerns local to dedicated helpers.
]
