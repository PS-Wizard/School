= Raw Crate ( Move Generation Crate; Raw Attack Tables )
#figure(
  block(
    clip: true,
    inset: (bottom: -450pt),
    image("../images/raw/raw_class_relationship.pdf"),
  ),
  caption: "Class Diagram For The `raw` crate",
)

#figure(
  block(
    clip: true,
    inset: (bottom: -120pt),
    image("../images/raw/raw_sequence_diagram.pdf"),
  ),
  caption: "Sequence Diagram For The `raw` crate",
)
#figure(
  image("../images/raw/attack_tables_time_diff.pdf", width: 100%),
  caption: "Comparison of Performance Between Different Move Generation Methods",
)

#align(center)[
  #table(
    columns: 7,
    align: (left, center, center, center, center, center, center),
    table.header([*label*], [*king*], [*knight*], [*rook*], [*bishop*], [*queen*], [*pawn*]),
    [on the fly], [692 n/s], [714 n/s], [811 n/s], [679 n/s], [1759 n/s], [---],
    [magics], [---], [---], [271.59 n/s], [277.13 n/s], [308.78 n/s], [---],
    [pext], [0.47 n/s], [0.47 n/s], [3.35 n/s], [3.40 n/s], [2.96 n/s], [0.23 n/s],
  )
]

== Introduction

=== Purpose
This section specifies the software requirements for the `raw` crate of the chess engine. The `raw` crate provides pre-computed attack tables and movement patterns for all piece types using bitboard representation.
=== Scope
The `raw` crate serves as the lookup layer, generating and storing attack patterns for pawns, knights, bishops, rooks, kings, and queens. It provides efficient move generation through pre-computed tables and PEXT-based indexing for sliding pieces.

== Functional Requirements

#table(
  columns: (auto, 3fr, auto, auto),
  align: (left, left, center, center),
  [*ID*], [*Description*], [*Type*], [*Status*],
  [RAW-F-001],
  [System must generate pawn attack tables for both colors across all 64 squares at compile time],
  [Functional],
  [Complete],

  [RAW-F-002],
  [System must generate king attack tables for all 64 squares with 8-directional movement at compile time],
  [Functional],
  [Complete],

  [RAW-F-003],
  [System must generate knight attack tables for all 64 squares with L-shaped movement at compile time],
  [Functional],
  [Complete],

  [RAW-F-004],
  [System must generate rook mask tables excluding edge squares for PEXT indexing at compile time],
  [Functional],
  [Complete],

  [RAW-F-005],
  [System must generate bishop mask tables excluding edge squares for PEXT indexing at compile time],
  [Functional],
  [Complete],

  [RAW-F-006],
  [System must generate rook attack tables for all blocker configurations using PEXT indexing at runtime via LazyLock],
  [Functional],
  [Complete],

  [RAW-F-007],
  [System must generate bishop attack tables for all blocker configurations using PEXT indexing at runtime via LazyLock],
  [Functional],
  [Complete],

  [RAW-F-008],
  [System must provide line_between function returning exclusive squares between two squares on same rank, file, or diagonal],
  [Functional],
  [Complete],

  [RAW-F-009],
  [System must provide line_through function returning all squares on rank, file, or diagonal containing two given squares],
  [Functional],
  [Complete],

  [RAW-F-010],
  [EnumerateVariations trait must generate all possible variations of a binary pattern using carry-rippler algorithm],
  [Functional],
  [Complete],

  [RAW-F-011],
  [Attack table generator must accept attack generation function and mask array to produce PEXT-indexed attack tables],
  [Functional],
  [Complete],

  [RAW-F-012],
  [Rook attack generation must cast rays in 4 directions until blockers or board edges],
  [Functional],
  [Complete],

  [RAW-F-013],
  [Bishop attack generation must cast rays in 4 diagonal directions until blockers or board edges],
  [Functional],
  [Complete],

  [RAW-F-014],
  [System must provide warmup_attack_tables function to force initialization and CPU cache loading of all attack tables],
  [Functional],
  [Complete],

  [RAW-F-015],
  [Between table must return 0 for squares not on same rank, file, or diagonal],
  [Functional],
  [Complete],
)

== Non-Functional Requirements

#table(
  columns: (auto, 3fr, auto, auto),
  align: (left, left, center, center),
  [*ID*], [*Description*], [*Type*], [*Status*],

  [TABLES-NF-001],
  [All table lookup functions must be inlined for zero-overhead access],
  [Non-Functional],
  [Complete],

  [TABLES-NF-002],
  [Fixed tables for pawns, knights, kings, and masks must be generated at compile time to reduce startup cost],
  [Non-Functional],
  [Complete],

  [TABLES-NF-003],
  [Sliding piece attack tables must use LazyLock for deferred initialization to reduce binary size],
  [Non-Functional],
  [Complete],

  [TABLES-NF-004],
  [Attack table generation must use PEXT instruction for efficient blocker configuration indexing],
  [Non-Functional],
  [Complete],

  [TABLES-NF-005],
  [Warmup function must access all table entries to ensure CPU cache loading before search begins],
  [Non-Functional],
  [Complete],

  [TABLES-NF-006],
  [All const generation functions must be const fn to enable compile-time evaluation],
  [Non-Functional],
  [Complete],
)

== Dependencies

- `std::sync::LazyLock` - Deferred initialization for large attack tables
- `std::arch::x86_64::_pext_u64` - PEXT instruction for efficient indexing
- `utilities::algebraic::Algebraic` - Square notation conversion
- `utilities::board::PrintAsBoard` - Debug visualization

== Test Plan: Raw Crate
Unit and integration testing for attack table generation, including bishops, rooks, kings, knights, pawns, and path calculations (between/through).

=== Test Cases

==== TC-001: Bishop Attacks
*Requirements:* Attack generation with blockers

#table(
  columns: (auto, 2fr, 2fr),
  align: left,
  [*Test*], [*Input*], [*Expected*],
  [Empty board], [sq=e4, blockers=0], [Full diagonal rays],
  [Single blocker], [sq=e4, blockers=g6], [Stops at g6],
  [Multiple blockers], [sq=e4, blockers=d3,f5], [Stops at both],
  [Edge squares], [sq=a1, blockers=0], [Single diagonal],
  [Mask generation], [All 64 squares], [Excludes edges],
)

==== TC-002: Rook Attacks
*Requirements:* Attack generation with blockers

#table(
  columns: (auto, 2fr, 2fr),
  align: left,
  [*Test*], [*Input*], [*Expected*],
  [Empty board], [sq=e4, blockers=0], [Full rank + file],
  [Rank blocker], [sq=e4, blockers=g4], [Stops at g4],
  [File blocker], [sq=e4, blockers=e7], [Stops at e7],
  [Corner square], [sq=a1, blockers=0], [Rank 1 + file a],
  [Mask generation], [All 64 squares], [Excludes edges],
)

==== TC-003: King Attacks
*Requirements:* Fixed attack patterns

#table(
  columns: (auto, 2fr, 2fr),
  align: left,
  [*Test*], [*Input*], [*Expected*],
  [Center square], [sq=e4], [8 surrounding squares],
  [Corner square], [sq=a1], [3 squares (b1,a2,b2)],
  [Edge square], [sq=e1], [5 squares],
  [All squares], [0-63], [Valid patterns only],
)

==== TC-004: Knight Attacks
*Requirements:* Fixed L-shape patterns

#table(
  columns: (auto, 2fr, 2fr),
  align: left,
  [*Test*], [*Input*], [*Expected*],
  [Center square], [sq=e4], [8 knight moves],
  [Corner square], [sq=a1], [2 moves (b3,c2)],
  [Edge square], [sq=e1], [4 moves],
  [All squares], [0-63], [Valid L-shapes only],
)

==== TC-005: Pawn Attacks
*Requirements:* Color-specific diagonal attacks

#table(
  columns: (auto, 2fr, 2fr),
  align: left,
  [*Test*], [*Input*], [*Expected*],
  [White center], [sq=e4, color=White], [d5,f5],
  [Black center], [sq=e5, color=Black], [d4,f4],
  [White edge], [sq=a4, color=White], [b5 only],
  [Promotion rank], [White on rank 7], [2 diagonals],
)

==== TC-006: Between Calculation
*Requirements:* Exclusive range between squares

#table(
  columns: (auto, 2fr, 2fr),
  align: left,
  [*Test*], [*Input*], [*Expected*],
  [Same rank], [e1 to e5], [e2,e3,e4],
  [Diagonal], [a1 to h8], [b2,c3,...,g7],
  [Adjacent squares], [e1 to e2], [Empty (0)],
  [Not aligned], [e1 to c3], [Empty (0)],
)

==== TC-007: Line Through Calculation
*Requirements:* Full line through two squares

#table(
  columns: (auto, 2fr, 2fr),
  align: left,
  [*Test*], [*Input*], [*Expected*],
  [Same rank], [e1 to e5], [Full rank 1],
  [Diagonal], [e1 to c3], [Full a8-h1 diagonal],
  [Adjacent file], [e1 to e2], [Full e-file],
  [Not aligned], [e1 to c4], [Empty (0)],
)

==== TC-008: Attack Table Generation
*Requirements:* PEXT indexing and lazy initialization

#table(
  columns: (auto, 2fr, 2fr),
  align: left,
  [*Test*], [*Input*], [*Expected*],
  [Table size], [ROOK_ATTACKS], [64 vectors],
  [Index validity], [All blocker combos], [Valid attacks],
  [LazyLock init], [First access], [Tables generated],
  [PEXT lookup], [mask + blockers], [Correct attack set],
)

==== TC-009: Memory and Performance
*Requirements:* Size verification and warmup

#table(
  columns: (auto, 2fr, 2fr),
  align: left,
  [*Test*], [*Input*], [*Expected*],
  [Rook table size], [All entries], [`~0.5` MB],
  [Bishop table size], [All entries], [`~0.5` MB],
  [Static tables], [King/Knight/Pawn], [`<2 KB` each],
  [Warmup time], [All tables], [`<50ms` debug],
)

=== Environment
- Rust toolchain: stable with x86_64 target
- Required features: BMI2 (PEXT instruction)
- Test framework: built-in `cargo test`
