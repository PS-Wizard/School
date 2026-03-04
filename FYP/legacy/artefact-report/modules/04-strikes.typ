#import "common.typ": diag

#let strikes_section() = [
= 4. Strikes Attack-Generation Crate

`strikes` provides precomputed attack and path lookup infrastructure for efficient bitboard move generation. The crate includes fixed tables for non-sliding pieces and generated lookup tables for sliding pieces.

== 4.1 Attack-Generation Design

#diag(
  "../artefact-diagrams/strikes/class-diagram-attack-generation.svg",
  "High-level attack-generation architecture in strikes",
  w: 88%,
)

#diag(
  "../artefact-diagrams/strikes/class-diagram-attack-tables.svg",
  "Attack-table and mask ownership for piece move lookups",
  w: 88%,
)

The implementation exposes static attack resources and lazy-initialized slider tables, supporting fast repeated lookups in search-heavy contexts.

== 4.2 Rays, Paths, and Lookup Pipeline

#diag(
  "../artefact-diagrams/strikes/class-diagram-paths.svg",
  "Path and ray abstractions used for between/through queries",
  w: 74%,
)

#diag(
  "../artefact-diagrams/strikes/sequence-diagram-pext-lookup.svg",
  "Sliding-piece lookup flow using mask extraction and index mapping",
  w: 88%,
)

Path queries (`between` / `through`) support legality checks and pin-related logic, while the lookup sequence captures the optimized flow used for sliding attacks.

== 4.3 Initialization Strategy

#diag(
  "../artefact-diagrams/strikes/activity-diagram-warmup.svg",
  "Warmup activity for initializing and touching attack tables",
  w: 52%,
)

`warmup_attack_tables()` is called during engine startup to force lazy table materialization and reduce first-search latency.
]
