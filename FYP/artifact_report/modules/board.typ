= Board Crate

=== Class Relationship 
#block(
  clip: true,
  stack(
    spacing: 0pt,
    image("../images/board/class_relationship.pdf", page: 1),
  ),
)
#v(-380pt)
#align(center)[
  Figure: Sequence Diagram For The Board Crate
]

=== Position Initialization From FEN Sequence
\
#block(
  clip: true,
  stack(
    spacing: 0pt,
    image("../images/board/board_fen_sequence.pdf", page: 2),
    image("../images/board/board_fen_sequence.pdf", page: 3),
  ),
)
#v(-170pt)
#align(center)[
  _Figure: Sequence Diagram For The Board Crate, Parsing FEN_
]

=== Move Generation Sequence
\
#block(
  stack(
    spacing: 0pt,
    image("../images/board/board_movegen_sequence.pdf", page: 2),
    image("../images/board/board_movegen_sequence.pdf", page: 3),
    image("../images/board/board_movegen_sequence.pdf", page: 4),
  ),
)
#v(-320pt)
#align(center)[
  Figure: Sequence Diagram For The Board Crate, Make/Unmake
]

=== Make/ Unmake Sequence
\
#block(
  stack(
    spacing: 0pt,
    image("../images/board/make_unmake_sequence.pdf", page: 2),
    image("../images/board/make_unmake_sequence.pdf", page: 3),
    image("../images/board/make_unmake_sequence.pdf", page: 4),
    image("../images/board/make_unmake_sequence.pdf", page: 5),
    image("../images/board/make_unmake_sequence.pdf", page: 6),
  ),
)
#v(-10pt)
#align(center)[
  _Figure: Sequence Diagram For The Board Crate, Move Generation_
]

== Introduction
=== Purpose
This section specifies the software requirements for the `board` crate of the chess engine. The `board` crate provides the core Position representation and move generation functionality for legal chess moves.

=== Scope
The `board` crate implements a bitboard-based chess position representation with efficient move generation for all piece types, FEN parsing, Zobrist hashing integration, and legality checking including pins, checks, and special moves.

== Functional Requirements
#table(
  columns: (auto, 3fr, auto, auto),
  align: (left, left, center, center),
  [*ID*], [*Description*], [*Type*], [*Status*],
  
  [BOARD-F-001],
  [Position must maintain 6 bitboards for piece types (Pawn, Knight, Bishop, Rook, Queen, King) and 2 bitboards for colors],
  [Functional],
  [Complete],
  
  [BOARD-F-002],
  [Position must maintain piece_map array for O(1) piece identification at any square (0-63)],
  [Functional],
  [Complete],
  
  [BOARD-F-003],
  [from_fen() must parse standard FEN strings with 6 parts: piece placement, side to move, castling rights, en passant, halfmove clock, fullmove number],
  [Functional],
  [Complete],
  
  [BOARD-F-004],
  [FEN parser must validate rank count (8 ranks), file count (8 files per rank), and piece characters (PNBRQKpnbrqk)],
  [Functional],
  [Complete],
  
  [BOARD-F-005],
  [Move generation must handle pin masks to restrict pinned piece movement along pin rays using THROUGH lookup table],
  [Functional],
  [Complete],
  
  [BOARD-F-006],
  [Move generation must apply check masks to ensure moves block or capture checking pieces],
  [Functional],
  [Complete],
  
  [BOARD-F-007],
  [Pawn move generation must handle single push, double push, captures, promotions (4 types), and en passant with horizontal discovered check detection],
  [Functional],
  [Complete],
  
  [BOARD-F-008],
  [Knight move generation must exclude pinned knights entirely (knights cannot move when pinned)],
  [Functional],
  [Complete],
  
  [BOARD-F-009],
  [Sliding piece move generation (Bishop, Rook, Queen) must use PEXT-based magic bitboard lookups with BISHOP_ATTACKS and ROOK_ATTACKS tables],
  [Functional],
  [Complete],
  
  [BOARD-F-010],
  [King move generation must verify target squares are not under attack using is_square_under_attack_with_blockers() with king removed from board],
  [Functional],
  [Complete],
  
  [BOARD-F-011],
  [Castling move generation must verify: castling rights, empty squares between king and rook, king not in check, intermediate squares not attacked],
  [Functional],
  [Complete],
  
  [BOARD-F-012],
  [System must provide add_piece() and remove_piece() methods that update bitboards, piece_map, and Zobrist hash atomically],
  [Functional],
  [Complete],
  
  [BOARD-F-013],
  [System must provide silent variants (add_piece_silent, remove_piece_silent) for unmake_move that skip hash updates],
  [Functional],
  [Complete],
  
  [BOARD-F-014],
  [compute_hash() must calculate full Zobrist hash from current position: pieces, castling rights, en passant file, side to move],
  [Functional],
  [Complete],
  
  [BOARD-F-015],
  [is_in_check() must detect if current side's king is under attack, is_enemy_in_check() must check opponent's king],
  [Functional],
  [Complete],
)

== Non-Functional Requirements
#table(
  columns: (auto, 3fr, auto, auto),
  align: (left, left, center, center),
  [*ID*], [*Description*], [*Type*], [*Status*],
  
  [BOARD-NF-001],
  [All move generation and board query methods must be inlined for zero-overhead access],
  [Non-Functional],
  [Complete],
  
  [BOARD-NF-002],
  [Sliding piece attack generation must use PEXT instruction `(_pext_u64)` for optimal performance on modern x86_64 CPUs],
  [Non-Functional],
  [Complete],
  
  [BOARD-NF-003],
  [Move generation must use bitboard iteration (trailing_zeros, LSB pop) for efficient square enumeration],
  [Non-Functional],
  [Complete],
  
  [BOARD-NF-004],
  [Position struct must be Clone and PartialEq for transposition table usage and position comparison],
  [Non-Functional],
  [Complete],
  
  [BOARD-NF-005],
  [Memory footprint must be minimal: 6×8 (pieces) + 2×8 (colors) + 64×3 (piece_map) + 18 (metadata) ≈ 274 bytes per position],
  [Non-Functional],
  [Complete],
)

== Dependencies
- `zobrist` - Zobrist hashing tables 
- `raw` - Precomputed attack tables (PAWN_ATTACKS, KNIGHT_ATTACKS, KING_ATTACKS, BISHOP_ATTACKS/MASKS, ROOK_ATTACKS/MASKS, THROUGH)
- `types::bitboard::Bitboard` - Bitboard wrapper type
- `types::others::{CastleRights, Color, Piece}` - Core type definitions
- `types::moves::{Move, MoveCollector, MoveType}` - Move representation
- `std::arch::x86_64::_pext_u64` - PEXT instruction for magic bitboards

== Test Plan: Board Crate

Unit and integration testing for the Position struct including FEN parsing, move generation, make/unmake, perft validation, and legality checking.

=== Test Cases

==== TC-001: FEN Parsing
*Requirements:* Position initialization from FEN

#table(
  columns: (auto, 3fr, 1fr),
  align: left,
  [*Test*], [*Input FEN*], [*Expected*],
  [Starting position], [Standard FEN], [All pieces correct],
  [Missing parts], [4-part FEN], [Error],
  [Invalid pieces], [FEN with 'X'], [Error],
  [Castling rights], [`KQkq`, `Kq`, `-`], [Parsed correctly],
  [En passant], [`e3`, `-`], [Parsed correctly],
)

==== TC-002: Move Generation - Pawns
*Requirements:* Legal pawn moves including promotions and en passant

#table(
  columns: (auto, 2fr, 2fr),
  align: left,
  [*Test*], [*Position*], [*Expected Moves*],
  [Starting position], [Initial FEN], [16 moves],
  [En passant], [Valid EP square], [EP move included],
  [Promotion], [Pawn on 7th rank], [4 promotion types],
  [Capture promotion], [Capture on 8th], [4 capture promos],
  [Diagonal pin], [Pawn pinned diagonally], [0 moves],
)

==== TC-003: Move Generation - Knights
*Requirements:* Legal knight moves respecting pins

#table(
  columns: (auto, 2fr, 2fr),
  align: left,
  [*Test*], [*Position*], [*Expected*],
  [Starting position], [Initial FEN], [4 moves (b1/g1)],
  [Center knight], [Knight on e4], [Up to 8 moves],
  [Pinned knight], [Knight pinned to king], [0 moves],
  [Check evasion], [In check], [Blocking moves only],
)

==== TC-004: Move Generation - Bishops
*Requirements:* Legal bishop moves with blocker interaction

#table(
  columns: (auto, 2fr, 2fr),
  align: left,
  [*Test*], [*Position*], [*Expected*],
  [Starting position], [Initial FEN], [0 moves],
  [Open diagonals], [Bishops on d5,e3], [17 moves],
  [Both pinned], [Bishops pinned], [0 moves],
  [Pin ray movement], [Bishop on pin ray], [Moves along ray only],
)

==== TC-005: Move Generation - Rooks
*Requirements:* Legal rook moves with PEXT lookup

#table(
  columns: (auto, 2fr, 2fr),
  align: left,
  [*Test*], [*Position*], [*Expected*],
  [Starting position], [Initial FEN], [0 moves],
  [Open files], [Rook on a1 clear], [15 moves],
  [Pinned rooks], [Multiple pins], [Moves along pin ray],
  [Capture + quiet], [Mixed targets], [Separated correctly],
)

==== TC-006: Move Generation - Queens
*Requirements:* Combined rook + bishop attacks

#table(
  columns: (auto, 2fr, 2fr),
  align: left,
  [*Test*], [*Position*], [*Expected*],
  [Starting position], [Initial FEN], [0 moves],
  [Open board], [Queen on d1], [10 moves],
  [Pinned queen], [Queen pinned], [Ray moves only],
  [Multiple queens], [Several queens], [All moves correct],
)

==== TC-007: Move Generation - Kings
*Requirements:* King moves and castling

#table(
  columns: (auto, 2fr, 2fr),
  align: left,
  [*Test*], [*Position*], [*Expected*],
  [Starting position], [Initial FEN], [0 moves],
  [Kingside castle], [Rights + clear], [Castle move],
  [Attacked squares], [f1 under attack], [No castle],
  [In check], [King in check], [No castle allowed],
  [Blockers removed], [Clear path], [King moves valid],
)

==== TC-008: Make/Unmake Moves
*Requirements:* Reversible move execution

#table(
  columns: (auto, 2fr, 2fr),
  align: left,
  [*Test*], [*Scenario*], [*Expected*],
  [Quiet move], [Make then unmake], [Position restored],
  [Capture], [Make then unmake], [Captured piece restored],
  [Castle], [Make then unmake], [Rook + king restored],
  [En passant], [Make then unmake], [Captured pawn restored],
  [Promotion], [Make then unmake], [Pawn restored],
  [Hash consistency], [All move types], [Hash matches],
)

==== TC-009: Attack Detection
*Requirements:* is_square_attacked correctness

#table(
  columns: (auto, 2fr, 2fr),
  align: left,
  [*Test*], [*Scenario*], [*Expected*],
  [Rook attack], [Rook on file], [Attacked=true],
  [Blocked attack], [Piece blocking], [Attacked=false],
  [Knight attack], [Knight L-shape], [Attacked=true],
  [Pawn attack], [Diagonal squares], [Attacked=true],
  [Multiple attackers], [Several pieces], [Attacked=true],
)

==== TC-010: Pin and Check Detection
*Requirements:* get_attack_constraints accuracy

#table(
  columns: (auto, 2fr, 2fr),
  align: left,
  [*Test*], [*Scenario*], [*Expected*],
  [No pins/checks], [Starting position], [Full check_mask],
  [Single pin], [One pinned piece], [Pin mask set],
  [Single check], [One checker], [Check mask path],
  [Double check], [Two checkers], [check_mask=0],
  [Pin + check], [Both conditions], [Both masks set],
)

==== TC-011: Perft Validation
*Requirements:* Move generation correctness via node count

#table(
  columns: (auto, 3fr, 1fr),
  align: left,
  [*Position*], [*Depth*], [*Expected Nodes*],
  [Starting], [5], [4,865,609],
  [Kiwipete], [5], [193,690,690],
  [Position 3], [6], [11,030,083],
  [Position 4], [5], [15,833,292],
  [Position 6], [6], [71,179,139],
)

==== TC-012: Zobrist Hashing
*Requirements:* Hash consistency and uniqueness

#table(
  columns: (auto, 2fr, 2fr),
  align: left,
  [*Test*], [*Scenario*], [*Expected*],
  [Initial hash], [compute_hash()], [Non-zero value],
  [Incremental], [Make move], [Hash updated],
  [Make/unmake], [Full cycle], [Hash restored],
  [Same position], [Different paths], [Same hash],
)

=== Environment
- Rust toolchain: stable with BMI2 support
- Test framework: built-in `cargo test --lib board`
- Perft tests: `cargo test --release --ignored`
