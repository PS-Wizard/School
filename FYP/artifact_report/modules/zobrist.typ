= Zobrist Crate

== Sequence Diagram
#figure(
  block(
    clip: true,
    image("../images/zobrist/sequence_zobrist.pdf"),
  ),
  caption: "Sequence Diagram For The `Zobrist` crate",
)

== Class Relationship Diagram
#figure(
  block(
    clip: true,
    inset: (bottom: -230pt),
    image("../images/zobrist/class_relationship.pdf"),
  ),
  caption: "Class Diagram For The `zobrist` crate",
)

== Introduction

=== Purpose
This section specifies the software requirements for the `zobrist` crate of the chess engine. The `zobrist` crate provides Zobrist hashing functionality for efficient position identification and transposition table lookups.

=== Scope
The `zobrist` crate implements Zobrist hashing, a technique that assigns random numbers to board components and uses XOR operations to create unique hash keys for chess positions, enabling fast position comparison and transposition detection.

\
== Functional Requirements

#table(
  columns: (auto, 3fr, auto, auto),
  align: (left, left, center, center),
  [*ID*], [*Description*], [*Type*], [*Status*],
  
  [ZOBRIST-F-001],
  [ZobristTables must generate random u64 values for all 12 piece types (6 pieces × 2 colors) across 64 squares],
  [Functional],
  [Complete],

  [ZOBRIST-F-002],
  [System must use deterministic random number generation with fixed seed (0x5EED_C0DE_CAFE_BABE; just a fun seed that can be represented in hex) for reproducibility],
  [Functional],
  [Complete],

  [ZOBRIST-F-003],
  [ZobristTables must generate 4 unique random values for castling rights (White King/Queen, Black King/Queen)],
  [Functional],
  [Complete],

  [ZOBRIST-F-004],
  [ZobristTables must generate 8 unique random values for en passant file possibilities (a-h)],
  [Functional],
  [Complete],

  [ZOBRIST-F-005],
  [ZobristTables must generate single random value for side-to-move indicator],
  [Functional],
  [Complete],

  [ZOBRIST-F-006],
  [piece() method must return Zobrist key for given piece type, color, and square index],
  [Functional],
  [Complete],

  [ZOBRIST-F-007],
  [piece_index() must map piece and color to table index: White pieces (0-5), Black pieces (6-11)],
  [Functional],
  [Complete],

  [ZOBRIST-F-008],
  [castling_key() must compute XOR combination of relevant castling rights flags],
  [Functional],
  [Complete],

  [ZOBRIST-F-009],
  [castling_key() must check each of 4 castling rights independently and XOR corresponding values],
  [Functional],
  [Complete],

  [ZOBRIST-F-010],
  [en_passant_key() must return Zobrist value for specified en passant file (0-7)],
  [Functional],
  [Complete],

  [ZOBRIST-F-011],
  [System must provide global static ZOBRIST instance via LazyLock for singleton access],
  [Functional],
  [Complete],

  [ZOBRIST-F-012],
  [ZOBRIST singleton must initialize exactly once on first access using lazy evaluation],
  [Functional],
  [Complete],
)

== Non-Functional Requirements

#table(
  columns: (auto, 3fr, auto, auto),
  align: (left, left, center, center),
  [*ID*], [*Description*], [*Type*], [*Status*],

  [ZOBRIST-NF-001],
  [All lookup methods (piece, castling_key, en_passant_key) must be inlined for zero-overhead access],
  [Non-Functional],
  [Complete],

  [ZOBRIST-NF-002],
  [Random number generation must use ChaCha8Rng for cryptographic quality and reproducibility],
  [Non-Functional],
  [Complete],

  [ZOBRIST-NF-003],
  [Zobrist tables must remain constant after initialization for thread-safe concurrent access],
  [Non-Functional],
  [Complete],

  [ZOBRIST-NF-004],
  [Memory footprint must be minimal: 12×64×8 bytes (pieces) + 4×8 (castling) + 8×8 (en passant) + 8 (side) = 6,216 bytes],
  [Non-Functional],
  [Complete],

  [ZOBRIST-NF-005],
  [System must use LazyLock to defer initialization cost until first use],
  [Non-Functional],
  [Complete],

  [ZOBRIST-NF-006],
  [castling_key() must use bitwise operations for efficient flag checking without branches where possible],
  [Non-Functional],
  [Complete],
)

== Dependencies
- `rand` - Random number generation trait
- `rand_chacha::ChaCha8Rng` - ChaCha8 PRNG implementation
- `std::sync::LazyLock` - Thread-safe lazy initialization
- `types::others::{CastleRights, Color, Piece}` - Core type definitions

