== Implementation

=== Development Environment
- Rust toolchain (Stable channel, version 1.93.0)
  ```bash
    [wizard@archbtw ~/Projects/School/FYP/finalized] -> cargo --version
    cargo 1.93.0 (083ac5135 2025-12-15)
    [wizard@archbtw ~/Projects/School/FYP/finalized] ->
    [wizard@archbtw ~/Projects/School/FYP/finalized] -> rustc --version
    rustc 1.93.0 (254b59607 2026-01-19)
    [wizard@archbtw ~/Projects/School/FYP/finalized] ->
  ```

=== Implemented Features

The following search and evaluation techniques have been implemented and benchmarked across 16 released versions:

*Search:*
- *Alpha-Beta Pruning*: Fundamental minimax enhancement that eliminates irrelevant branches in the game tree.
- *Iterative Deepening*: Repeatedly searches to increasing depths, improving move ordering and enabling time management.
- *Transposition Table with Zobrist Hashing*: Enables detection of previously evaluated positions, avoiding redundant search.
- *Quiescence Search*: Extends search to capture sequences, preventing horizon effects from obscuring tactical positions.
- *Principal Variation Search (PVS)*: Optimizes search by assuming a best move exists and exploiting this assumption.
- *Null Move Pruning*: Exploits the intuition that having an extra move provides positional advantage.
- *Late Move Reductions (LMR)*: Reduces search depth for moves likely to be poor, focusing computation on promising lines.
- *Futility Pruning*: Prunes moves that cannot improve the search result based on positional evaluation.
- *Reverse Futility Pruning*: Prunes positions that are clearly winning, allowing deeper search in winning branches.
- *Razoring*: Reduces search depth when a position appears worse than a shallow search threshold.
- *Check Extension*: Extends search depth when checking moves are found, improving tactical accuracy.
- *Aspiration Windows*: Narrows alpha-beta bounds based on previous search results, improving efficiency.
- *Internal Iterative Deepening (IID)*: Performs shallow searches to improve move ordering in principal variation nodes.
- *ProbCut*: A probabilistic enhancement to futility pruning based on shallow search results.
- *Singular Extensions*: Extends moves that are significantly better than alternatives.
- *Dynamic Null Move Pruning*: Adaptive null move pruning based on remaining depth and position characteristics.
- *Lazy SMP (Symmetric Multi-Processing)*: Parallel search using multiple threads with shared transposition table.
\
*Evaluation:*
- *Tapered Evaluation*: Smooth interpolation between middlegame and endgame evaluation values.
- *Piece-Square Tables (PeSTO Values)*: Position-dependent evaluation using empirically tuned piece-square tables.
- *Static Exchange Evaluation (SEE)*: Evaluates the material outcome of capture sequences without performing full search.
- *History Heuristic*: Records move history to improve move ordering based on previous search successes.
- *Killer Move Heuristic*: Preserves good capture and check moves for potential reuse.
- *Transposition Table Move Ordering*: Prioritizes moves that have previously produced good results.
\
*Move Generation:*
- *PEXT Boards*: Efficient sliding piece attack calculation using pre-computed tables for `O(1)` access.
- *Pre-computed Lookup Tables*: Tables for kings, knights, and pawns are precomputed for `O(1)` access.
- *Constraint-Based Move Generation*: Efficient legal move generation.
- *MVV-LVA (Most Valuable Victim - Least Valuable Attacker)*: Captures ordering based on material trade calculations.
- *Make/Unmake Architecture*: Efficient way to update the `Position` struct, without having to do a full copy.

*Interface:*
- *UCI (Universal Chess Interface)*: Standard protocol for communication with chess GUIs.

=== Testing

Testing methodology employed multiple complementary approaches:

1. *PERFT (Performance Test)*: Validation of move generation by comparing computed node counts against known values at various depths. This is the standard way to verify move generation correctness. OopsMate's values were tested against: https://www.chessprogramming.org/Perft_Results

2. *Position Validation*: Testing against established test suites including:
   - Start Position (standard opening)
   - KiwiPete (tactical positions)
   - Giuoco Piano (middlegame structure)
   - Rook+Pawn endgame scenarios
   - WAC-2 (Win at Chess) tactical puzzles

3. *Self-Play Testing*: Each new version is tested against previous versions to measure Elo improvement.

4. *Engine vs. Engine Matching*: Competitive testing against established engines including:
   - Stockfish with UCI Elo limiting (calibrated to FIDE scale)
   - Sayuri (1807 CCRL rated)

5. *Performance Profiling*: Using `perf` to identify CPU hotspots and optimize critical code paths.

=== Tools Used

- *Programming Language*: Rust (no external dependencies)
- *Project Management*: Trello
- *Development Tools*:
  - Neovim (text editor)
  - Tmux (terminal multiplexer)
  - Clippy (linting)
  - Rust Analyzer (LSP)
  - Perf (Linux profiling)
  - Git (version control)
- *Testing Infrastructure*:
  - CuteChess (GUI wrapper for engine communication)
  - CuteChess-CLI (automated match execution)
  - Ordo (Elo rating calculation with anchored ratings)
  - Modern.pgn (opening book for standardized test positions)
