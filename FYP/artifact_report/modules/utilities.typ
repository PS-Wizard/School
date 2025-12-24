= Utilities Crate
#figure(
  block(
    clip: true,
    inset: (bottom: -290pt),
    image("../images/utilities/utilities_class_relationship.pdf"),
  ),
  caption: "Class Diagram For The `utilities` crate",
)


== Introduction

=== Purpose
This section specifies the software requirements for the `utilities` crate of the chess engine. The `utilities` crate provides helper functions and traits for working with algebraic notation and board visualization.

=== Scope
The `utilities` crate serves as a utility layer, providing convenient conversion functions between algebraic chess notation and bitboard representations, as well as debugging visualization tools.

== Functional Requirements

#table(
  columns: (auto, 3fr, auto, auto),
  align: (left, left, center, center),
  [*ID*], [*Description*], [*Type*], [*Status*],

  [UTIL-F-001],
  [Algebraic trait must parse comma-separated square notation strings (e.g., "g2,g4,g5") and return u64 bitboard with corresponding bits set],
  [Functional],
  [ Complete],

  [UTIL-F-002],
  [`place()` method must validate and skip invalid square notations (wrong file/rank format, out of bounds)],
  [Functional],
  [ Complete],

  [UTIL-F-003],
  [`place()` method must handle whitespace in input strings and empty comma-separated values gracefully],
  [Functional],
  [ Complete],

  [UTIL-F-004],
  [`idx()` method must convert single algebraic notation square (e.g., "g2") to 0-63 board index],
  [Functional],
  [ Complete],

  [UTIL-F-005], [`idx()` method must support case-insensitive file letters (a-h or A-H)], [Functional], [ Complete],

  [UTIL-F-006],
  [`notation()` method must convert u64 bitboard to comma-separated algebraic notation string of set bits],
  [Functional],
  [ Complete],

  [UTIL-F-007],
  [`notation()` method must iterate through bitboard using `trailing_zeros()` optimization for sparse boards],
  [Functional],
  [ Complete],

  [UTIL-F-008], [`notation()` method must be implemented for both u64 and usize types], [Functional], [ Complete],

  [UTIL-F-009], [`PrintAsBoard` trait must render u64 bitboard as visual 8x8 ASCII chessboard], [Functional], [ Complete],

  [UTIL-F-010],
  [`print()` method must display set bits as 'X' and unset bits as '.' with rank/file labels],
  [Functional],
  [Complete],

  [UTIL-F-011],
  [ `print()` method must display board with ranks 8-1 (top to bottom) and files a-h (left to right)],
  [Functional],
  [ Complete],

  [UTIL-F-012],
  [`print()` method must only compile in debug builds `(cfg(debug_assertions))` to avoid bloat in release],
  [Functional],
  [ Complete],

  [UTIL-F-013],
  [Algebraic trait must be implemented for str type with `place()` and `idx()` methods],
  [Functional],
  [ Complete],

  [UTIL-F-014],
  [Algebraic trait must be implemented for u64 and usize types with `notation()` method],
  [Functional],
  [ Complete],

  [UTIL-F-015],
  [ `place()` must correctly map algebraic squares to bitboard indices: a1=0, h1=7, a8=56, h8=63],
  [Functional],
  [Complete],

  [UTIL-F-016],
  [System must provide test suite validating `place()`, `idx()`, and `notation()` conversions],
  [Functional],
  [ Complete],
)

== Non-Functional Requirements

#table(
  columns: (auto, 3fr, auto, auto),
  align: (left, left, center, center),
  [*ID*], [*Description*], [*Type*], [*Status*],

  [UTIL-NF-001],
  [`place()` parsing must be resilient to malformed input without panicking],
  [Non-Functional],
  [ Complete],

  [UTIL-NF-002],
  [`print()` method must be zero-cost in release builds through conditional compilation],
  [Non-Functional],
  [ Complete],
)

== Dependencies
- `std::string::String` - String building for notation() output
- Internal module structure: `algebraic` and `board` submodules
