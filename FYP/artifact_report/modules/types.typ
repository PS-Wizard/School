= Types Crate

#figure(
  image("../images/types/diagram.pdf", width: 100%),
  caption: "Class Diagram For The `types` crate",
)

== Introduction

=== Purpose
This section specifies the software requirements for the `types` crate of the chess engine. The `types` crate provides fundamental data structures and type definitions used throughout the engine.

=== Scope
The `types` crate serves as the foundational layer, defining core chess concepts including bitboard representation, move encoding, piece types, and move collection structures optimized for performance.

== Functional Requirements

#table(
  columns: (auto, 3fr, auto, auto),
  align: (left, left, center, center),
  [*ID*], [*Description*], [*Type*], [*Status*],
  [TYPES-F-001],
  [Bitboard must represent 64 squares as u64 with bit manipulation operations (set, remove, OR, AND)],
  [Functional],
  [ Complete],

  [TYPES-F-002],
  [Color enumeration must represent White and Black with toggle operations (NOT operator and flip method)],
  [Functional],
  [ Complete],

  [TYPES-F-003],
  [Piece enumeration must define all six piece types (Pawn, Knight, Bishop, Rook, Queen, King) mapped to internal representation],
  [Functional],
  [ Complete],

  [TYPES-F-004],
  [CastleRights must store 4-bit flags for White/Black kingside/queenside with query and removal methods],
  [Functional],
  [ Complete],

  [TYPES-F-005],
  [Move must encode source square (6 bits), destination square (6 bits), and move type (4 bits) in 16-bit value],
  [Functional],
  [ Complete],

  [TYPES-F-006],
  [Move must support extraction of from square, to square, and move type through bit masking],
  [Functional],
  [ Complete],

  [TYPES-F-007],
  [MoveType enumeration must define all move types: Quiet, DoublePush, Castle, EnPassant, Capture, and 8 promotion variants],
  [Functional],
  [ Complete],

  [TYPES-F-008],
  [Move must identify captures and promotions through bit flag checking (bit 2 for capture, bit 3 for promotion)],
  [Functional],
  [ Complete],

  [TYPES-F-009],
  [Move must identify special moves (EnPassant, Castle, DoublePush) and extract promotion piece type],
  [Functional],
  [ Complete],

  [TYPES-F-010],
  [Move must format to UCI string notation (e.g., "e2e4", "e7e8q") via Display trait],
  [Functional],
  [ Complete],

  [TYPES-F-011],
  [MoveCollector must maintain separate arrays for captures (128 slots) and quiet moves (128 slots)],
  [Functional],
  [ Complete],

  [TYPES-F-012],
  [MoveCollector must automatically route pushed moves to captures or quiets array based on move type],
  [Functional],
  [ Complete],

  [TYPES-F-013],
  [MoveCollector must provide count queries (total, captures, quiets) and emptiness check],
  [Functional],
  [ Complete],

  [TYPES-F-014],
  [MoveCollector must support move lookup by index (captures first, then quiets) and containment checking],
  [Functional],
  [ Complete],

  [TYPES-F-015],
  [MoveCollector must provide ordered iteration (all captures before any quiets) for move ordering optimization],
  [Functional],
  [ Complete],

  [TYPES-F-016],
  [System must convert square indices (0-63) to algebraic notation strings (e.g., 0 → "a1", 63 → "h8")],
  [Functional],
  [ Complete],
)

== Non-Functional Requirements

#table(
  columns: (auto, 3fr, auto, auto),
  align: (left, left, center, center),
  [*ID*], [*Description*], [*Type*], [*Status*],

  [TYPES-NF-001],
  [All critical operations (move encoding/decoding, bit operations) must be inlined (inline(always)) for zero-overhead abstraction],
  [Non-Functional],
  [ Complete],

  [TYPES-NF-002],
  [Memory layout must be optimal: Bitboard (8B), Move (2B), Color/Piece/MoveType (1B each), CastleRights (1B)],
  [Non-Functional],
  [ Complete],

  [TYPES-NF-003],
  [MoveCollector must use MaybeUninit for uninitialized memory to avoid zeroing overhead on allocation],
  [Non-Functional],
  [ Complete],

  [TYPES-NF-004],
  [All enums must use repr(u8) for guaranteed layout and FFI compatibility; Bitboard uses repr(transparent)],
  [Non-Functional],
  [ Complete],
)

== Dependencies

- `std::mem::MaybeUninit` - Uninitialized memory management for performance
- `std::ops` - Operator overloading traits (BitOr, BitAnd, Not, Index)
- `crate::others::Piece` - Internal piece type dependency

== Test Plan: Types Crate
This test plan covers unit and integration testing for all types defined in the `types` crate, including Bitboard, Color, Piece, CastleRights, Move, MoveType, and MoveCollector.

=== Test Cases

==== TC-001: Bitboard Operations

#table(
  columns: (auto, 2fr, 2fr),
  align: left,
  [*Test*], [*Input*], [*Expected Output*],
  [Empty bitboard], [`Bitboard::new()`], [`0x0`],
  [Set bit 0], [`bb.set_bit(0)`], [`0x1`],
  [Set bit 63], [`bb.set_bit(63)`], [`0x8000000000000000`],
  [Remove bit], [`bb.set_bit(5); bb.remove_bit(5)`], [`0x0`],
  [OR operation], [`Bitboard(0x5) | Bitboard(0x3)`], [`Bitboard(0x7)`],
  [AND operation], [`Bitboard(0x5) & Bitboard(0x3)`], [`Bitboard(0x1)`],
)

==== TC-002: Color Operations

#table(
  columns: (auto, 2fr, 2fr),
  align: left,
  [*Test*], [*Input*], [*Expected Output*],
  [NOT operator], [`!Color::White`], [`Color::Black`],
  [NOT operator], [`!Color::Black`], [`Color::White`],
  [Flip white], [`Color::White.flip()`], [`Color::Black`],
  [Flip black], [`Color::Black.flip()`], [`Color::White`],
)

==== TC-003: Move Encoding

#table(
  columns: (auto, 2fr, 2fr),
  align: left,
  [*Test*], [*Input*], [*Expected Output*],
  [Quiet move], [`Move::new(12, 20, MoveType::Quiet)`], [`from=12, to=20, type=Quiet`],
  [Capture move], [`Move::new(35, 44, MoveType::Capture)`], [`from=35, to=44, is_capture=true`],
  [Promotion], [`Move::new(48, 56, MoveType::PromotionQueen)`], [`is_promotion=true, piece=Queen`],
  [En passant], [`Move::new(33, 42, MoveType::EnPassant)`], [`is_special=true`],
  [Castle], [`Move::new(4, 6, MoveType::Castle)`], [`is_special=true`],
)

==== TC-004: Move Type Detection

#table(
  columns: (auto, 4fr, 1fr),
  align: left,
  [*Test*], [*Input*], [*Expected Output*],
  [Is capture check], [`MoveType::Capture.is_capture()`], [`true`],
  [Is capture check], [`MoveType::Quiet.is_capture()`], [`false`],
  [Is promotion check], [`MoveType::PromotionQueen.is_promotion()`], [`true`],
  [Capture promotion], [`MoveType::CapturePromotionKnight.is_capture()`], [`true`],
  [Capture promotion], [`MoveType::CapturePromotionKnight.is_promotion()`], [`true`],
)

==== TC-005: UCI String Formatting

#table(
  columns: (auto, 3fr, 1fr),
  align: left,
  [*Test*], [*Input*], [*Expected Output*],
  [Quiet move], [`Move::new(12, 20, MoveType::Quiet)`], [`"e2e3"`],
  [Long move], [`Move::new(0, 63, MoveType::Quiet)`], [`"a1h8"`],
  [Promotion], [`Move::new(48, 56, MoveType::PromotionQueen)`], [`"a7a8q"`],
  [Knight promo], [`Move::new(51, 59, MoveType::PromotionKnight)`], [`"d7d8n"`],
  [Square to string], [`square_to_string(0)`], [`"a1"`],
  [Square to string], [`square_to_string(63)`], [`"h8"`],
)

==== TC-006: MoveCollector Basic Operations

#table(
  columns: (auto, 2fr, 2fr),
  align: left,
  [*Test*], [*Input*], [*Expected Output*],
  [New collector], [`MoveCollector::new()`], [`len=0, is_empty=true`],
  [Push quiet], [`mc.push(quiet_move)`], [`quiet_count=1, capture_count=0`],
  [Push capture], [`mc.push(capture_move)`], [`capture_count=1`],
  [Mixed moves], [`push 3 captures, 5 quiets`], [`len=8, capture_count=3`],
  [Clear], [`mc.clear()`], [`len=0, is_empty=true`],
)

==== TC-007: MoveCollector Indexing and Iteration
#table(
  columns: (auto, 2fr, 2fr),
  align: left,
  [*Test*], [*Input*], [*Expected Output*],
  [Get capture], [`mc.get(0)` with captures], [First capture move],
  [Get quiet], [`mc.get(capture_count)` ], [First quiet move],
  [Index operator], [`mc[0]`], [First capture if exists],
  [Contains check], [`mc.contains(move)`], [`true` if move exists],
  [Ordered iteration], [`mc.iter_ordered()`], [Captures first, then quiets],
)

=== Environment
- Rust toolchain: stable
- Test framework: Built-in `cargo test`
