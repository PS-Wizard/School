= NNUE FFI
=== Sequence
\
#block(
  stack(
    spacing: 0pt,
    image("../images/nnueFFI/nnue_ffi.pdf", page: 2),
    image("../images/nnueFFI/nnue_ffi.pdf", page: 3),
  ),
)
#v(-300pt)
#align(center)[
  Figure: Sequence Diagram For The nnue-ffi Crate
]

=== Class Relationship
\
#block(
  stack(
    spacing: 0pt,
    image("../images/nnueFFI/class_relationship.pdf", page: 1),
  ),
)
#v(-80pt)
#align(center)[
  Figure: Class Diagram For The nnue-ffi Crate
]

== Introduction
=== Purpose
This section specifies the software requirements for the `nnue-probe` crate of the chess engine. The `nnue-probe` crate provides Foreign Function Interface (FFI) bindings to an external NNUE (Efficiently Updatable Neural Network) evaluation library for position scoring.

=== Scope
The `nnue-probe` crate implements safe Rust wrappers around a precompiled NNUE library, providing chess position evaluation using neural network inference with support for both standard and incremental evaluation modes.

== Functional Requirements
#table(
  columns: (auto, 3fr, auto, auto),
  align: (left, left, center, center),
  [*ID*], [*Description*], [*Type*], [*Status*],
  
  [NNUE-F-001],
  [NNUEProbe must initialize library exactly once per process using Once synchronization primitive],
  [Functional],
  [Complete],
  
  [NNUE-F-002],
  [init() must load NNUE evaluation file (.nnue format) from provided path],
  [Functional],
  [Complete],
  
  [NNUE-F-003],
  [evaluate_fen() must accept FEN string and return evaluation score in centipawns relative to side to move],
  [Functional],
  [Complete],
  
  [NNUE-F-004],
  [evaluate() must accept piece array, square array (A1=0...H8=63), and CColor, returning centipawns score],
  [Functional],
  [Complete],
  
  [NNUE-F-005],
  [Piece arrays must follow format: pieces[0]=white king, pieces[1]=black king, pieces[n+1]=0 as terminator],
  [Functional],
  [Complete],
  
  [NNUE-F-006],
  [evaluate_incremental() must accept NNUEData history array [current, ply-1, ply-2] for differential evaluation],
  [Functional],
  [Complete],
  
  [NNUE-F-007],
  [NNUEData must contain 64-byte aligned Accumulator with 2×256 int16 accumulations and computed_accumulation flag],
  [Functional],
  [Complete],
  
  [NNUE-F-008],
  [DirtyPiece must track moved pieces with dirty_num count and arrays for piece codes, from squares, to squares (max 3 entries)],
  [Functional],
  [Complete],
  
  [NNUE-F-009],
  [CPiece enum must define piece codes: WKing=1, WQueen=2, WRook=3, WBishop=4, WKnight=5, WPawn=6, BKing=7...BPawn=12, Blank=0],
  [Functional],
  [Complete],
  
  [NNUE-F-010],
  [CColor enum must define colors: White=0, Black=1],
  [Functional],
  [Complete],
  
  [NNUE-F-011],
  [All evaluation methods must return Err if library not initialized via init()],
  [Functional],
  [Complete],
  
  [NNUE-F-012],
  [FFI interface must handle CString conversions safely and validate array length consistency],
  [Functional],
  [Complete],
  
  [NNUE-F-013],
  [Build script must set RPATH to embed library path for runtime loading without LD_LIBRARY_PATH environment variable],
  [Functional],
  [Complete],
  
  [NNUE-F-014],
  [Build script must link libnnueprobe.so dynamically from assets/nnue-probe/src with absolute path resolution],
  [Functional],
  [Complete],
)

== Non-Functional Requirements
#table(
  columns: (auto, 3fr, auto, auto),
  align: (left, left, center, center),
  [*ID*], [*Description*], [*Type*], [*Status*],
  
  [NNUE-NF-001],
  [Accumulator struct must use #[repr(C, align(64))] for FFI compatibility and alignment guarantees],
  [Non-Functional],
  [Complete],
  
  [NNUE-NF-002],
  [All FFI structs (NNUEData, Accumulator, DirtyPiece) must use #[repr(C)] for memory layout compatibility],
  [Non-Functional],
  [Complete],
  
  [NNUE-NF-003],
  [Incremental evaluation must support 3-ply history to enable efficient differential updates],
  [Non-Functional],
  [Complete],
  
  [NNUE-NF-004],
  [Build script must invalidate cache when library or source files change via cargo:rerun-if-changed directives],
  [Non-Functional],
  [Complete],
  
  [NNUE-NF-005],
  [NNUEProbe and NNUEData must implement Default trait for convenient initialization],
  [Non-Functional],
  [Complete],
)

== Dependencies
- `std::ffi::CString` - C string conversion for FFI
- `std::os::raw::{c_char, c_int}` - C type mappings for FFI compatibility
- `std::sync::Once` - One-time initialization synchronization
- External: `libnnueprobe.so` - Precompiled NNUE evaluation library
- Build: Rust build.rs with dynamic linking and RPATH configuration
