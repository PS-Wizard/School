#import "layout.typ": *

#show: academic-theme.with(
  title: "Chess Engines and Artificial Intelligence: A Literature Review",
  author: "Swoyam Pokharel",
  date: "October 15, 2025",
  abstract: [
    Covers the research roadmap
  ],
)


== Recommended Literature Review Structure

=== 1. Introduction & Historical Context (2-3 pages)
Papers: Shannon (1949)
- The chess programming problem and its significance for AI
- Type A vs Type B strategies: from brute force to selective search
- Shannon's prescient insights: quiescence, evaluation functions, selective search
- Bridge to modern engines: what remains, what evolved

=== 2. Theoretical Foundations of Search (3-4 pages)
Papers: Knuth & Moore, Shannon
- 2.1 Minimax and Negamax Framework
  - Mathematical formulation
  - Optimal play assumption
  - Negamax simplification for implementation
- 2.2 Alpha-Beta Pruning Optimality
  - Knuth & Moore's proof of optimality
  - Best-case complexity: $W^{\lceil D/2 \rceil} + W^{\lfloor D/2 \rfloor} - 1$
  - Node types (PV-nodes, Cut-nodes, All-nodes)
  - Why move ordering matters critically
- 2.3 The Horizon Effect Problem
  - Shannon's original observation
  - Marsland's discussion of persistent challenges
  - Leads naturally to quiescence search

=== 3. Board Representation & Data Structures (4-5 pages)
Papers: Bijl & Tiet, Fiekas, Tesseract
- 3.1 Evolution of Board Representations
  - Array-based (2D, 1D, 0x88, mailbox)
  - Bitboard revolution (1970s concept, modern realization)
  - Hybrid approaches (Tesseract)
  - Performance comparison from Bijl: evaluation is the bottleneck, not move gen
- 3.2 Sliding Piece Move Generation
  - The lookup table approach
  - Magic bitboards (Fiekas): multiplicative hashing, search space reduction
  - PEXT bitboards: hardware acceleration (BMI2)
  - Comparative performance: Fiekas (0.7% difference), Bijl (negligible in practice)
- 3.3 Zobrist Hashing
  - Incremental hash updates for transposition tables
  - XOR-based efficiency

Key Insight to Emphasize: Bijl showed that bitboards' real advantage is in evaluation speed (34% vs 41-43% of time), not raw move generation speed. This challenges conventional wisdom.

=== 4. Move Generation Pipeline (2-3 pages)
Papers: Bijl & Tiet, Tesseract
- 4.1 Pseudo-legal vs Legal Moves
  - Definitions and trade-offs
  - Tesseract: legal move generator with pinned piece detection
  - Top engines: pseudo-legal + lazy legality checking (Bijl observation)
- 4.2 Move Representation
  - Tesseract: 16-bit packed move encoding
  - Memory efficiency vs clarity trade-offs
  - Bit-packing impact: 50% speed improvement (Tesseract finding)
- 4.3 Performance Optimization
  - Branchless code (Tesseract)
  - Pre-generated attack tables (king, knight)
  - PEXT/Magic for sliding pieces
  - Perft testing for correctness validation

=== 5. Search Algorithms & Enhancements (6-7 pages)
Papers: Shannon, Knuth & Moore, Marsland, Bijl & Tiet, Tesseract, Brange

5.1 Core Alpha-Beta Framework
- Negamax with alpha-beta (Knuth's optimality)
- Fail-soft vs fail-hard windows

5.2 Iterative Deepening
- Marsland: only 5% overhead
- Benefits: time control, move ordering, anytime algorithm
- Brange: 28.7% speedup through TT hit rate increase

5.3 Principal Variation Search (PVS)
- Marsland: superior to aspiration search with iterative deepening
- Null window re-searches
- Implementation in modern engines

5.4 Transposition Tables
- Zobrist hashing (Bijl, Tesseract, Brange)
- Replacement schemes
- Brange: 39.8% speedup
- Alpha-beta vs MCTS usage (Marsland vs AlphaZero)

5.5 Move Ordering Heuristics
- Critical importance (Knuth: All-nodes ordering doesn't matter, but Cut-nodes do!)
- TT moves first
- MVV-LVA for captures (Brange: 68.5% speedup - largest single impact!)
- Killer heuristic
- History heuristic (Marsland: dynamic, context-free)
- Tesseract: combined ordering strategy

5.6 Quiescence Search
- Shannon's Type B strategy: search "forceful variations"
- Marsland: resolving the horizon effect
- Tesseract: 7307→8520 score improvement, EBF 4.23
- Capture-only search until "quiet" position

5.7 Pruning Techniques
- Null Move Pruning (Tesseract: biggest speedup, EBF→3.31)
- Late Move Reductions (mixed results: Tesseract blunders, good in theory)
- Futility pruning (Marsland)
- Forward pruning dangers (Marsland: "error prone")

5.8 Extensions
- Check extensions (Tesseract)
- Singular extensions (Bijl)
- Recapture extensions

Key Findings Table: Create a comparative table of technique impacts from Tesseract, Brange showing % speedups

=== 6. Classical Evaluation Functions (5-6 pages)
Papers: Shannon, Bijl & Tiet, Tesseract

6.1 Shannon's Foundation
- Material, pawn structure, mobility, king safety
- The f(P) function concept
- Continuous quality range

6.2 Material Evaluation
- Standard piece values (centipawns)
- Bijl: Q=8.9, R=4.3, B=2.9, N=2.7, P=1.0

6.3 Piece-Square Tables (PST)
- Tesseract: 5640→8255 score jump (biggest evaluation impact)
- Middlegame vs endgame tables
- Tapered evaluation (Bijl, Tesseract): interpolation based on game phase

6.4 Positional Factors
- Mobility (Bijl, Tesseract: legal move counting)
- King safety: pawn shield, pawn storm, open files
- Minor pieces: outposts, king distance
- Rooks: open files, 7th rank, stacking (Bijl tuning: increased every iteration!)
- Bishop pair bonus

6.5 Pawn Structure
- Pawn hash tables (Bijl, Tesseract)
- Doubled, isolated, backward, passed pawns
- Computational efficiency through hashing

6.6 Parameter Tuning Results
- Bijl: sequential tuning, 15% average win rate increase
- Depth-dependent insights:
  - Knight value decreases with depth (490→385)
  - Bishop pair value increases with depth
  - Rook stacking consistently valued

=== 7. Modern Evaluation: Neural Networks (6-7 pages)
Papers: NNUE (Nasu), AlphaZero (Silver), MCTS Review

7.1 Limitations of Classical Evaluation
- Linear models (Sankoma-Kankei in Shogi)
- Cannot capture non-linear relationships
- NNUE: bridge between classical and deep learning

7.2 NNUE Architecture
- Efficiently updatable neural networks
- CPU-optimized design (vs GPU requirement of deep networks)
- HalfKP feature encoding
- Incremental calculation (difference computation)
- Integer arithmetic + SIMD (AVX2)
- ClippedReLU activation
- Network sizing: speed parity with classical evaluation

7.3 AlphaZero Paradigm Shift
- Tabula rasa reinforcement learning
- Dual network: policy (p) + value (v)
- Self-play training (4 hours to beat Stockfish in chess)
- Expected outcome: accounting for draws

7.4 Performance Comparison: Search Depth vs Selectivity
- Stockfish: 70M pos/sec
- AlphaZero: 80K pos/sec (1000x fewer!)
- Compensates through selective focus (neural network guided)
- More "human-like" approach (Shannon's Type B vindicated)

7.5 MCTS Integration
- Monte Carlo Tree Search fundamentals (4 phases)
- UCT selection policy
- Averaging over approximation errors (vs alpha-beta error propagation)
- Better scaling with thinking time than alpha-beta (Silver et al. finding)
- MCTS modifications for chess (from MCTS review):
  - Hybrid MCTS-Minimax
  - Sufficiency threshold for optimistic actions
  - Early termination with NN evaluation

Critical Analysis Section: Why hasn't NNUE/AlphaZero completely replaced classical engines?
- NNUE adopted by Stockfish (12+)
- Computational requirements
- Training data needs
- Speed vs strength trade-offs

=== 8. Parallel Search (3-4 pages)
Papers: Tesseract, Brange, MCTS Review

8.1 Parallelization Strategies
- Lazy SMP (Brange, Tesseract)
- YBWC (Young Brothers Wait Concept)
- Root, Leaf, Tree parallelization (MCTS review)

8.2 Empirical Results
- Brange: 33.1% speedup with 4 threads, but 2528% TT hit increase
- Tesseract: performance decline (synchronization overhead)
- Garbage collection penalties (Brange: 24.5% JVM overhead)

8.3 Challenges
- Shared data structure contention
- TT write conflicts
- Optimal thread count
- Virtual loss technique (MCTS)

=== 9. Rating Systems & Benchmarking (3-4 pages)
Papers: Elo Model paper, Bijl & Tiet, Tesseract, Brange, Marsland

9.1 Elo Rating System
- Bradley-Terry model foundation
- Logistic function: alpha beta 
- K-factor and rating updates
- Gaussian distribution validation (R²=0.98-0.99)
- Negative skew observation: new players enter below average
- Variance grows logarithmically: 

9.2 Alternative Systems
- Bayesian Elo (mention, but you don't have the Coulom paper)
- Glicko, TrueSkill (uncertainty modeling)

9.3 Performance Metrics
- Nodes per second (NPS)
- Effective Branching Factor (EBF) - Tesseract uses extensively
- Time to depth
- Perft (move generation correctness)

9.4 Test Suites
- Strategic Test Suite (STS) - Tesseract uses at depth 7
- Bratko-Kopec positions - Marsland uses
- CCRL ratings - Tesseract benchmarks against

9.5 Benchmarking Results from Papers
- Bijl: 1400 ELO at depth 8
- Tesseract: 2400-2450 ELO
- AlphaZero: 28-0-72 vs Stockfish

=== 10. Real-World Engine Case Studies (4-5 pages)
Papers: All papers reference these engines

10.1 Stockfish (Classical Alpha-Beta)
- Architecture overview (from AlphaZero paper's critique)
- NNUE integration (from NNUE paper)
- Techniques used: all from sections 4-6
- Strength: ~3500 ELO (reference from papers)
- Open source, continuously developed

10.2 Leela Chess Zero (MCTS + NN)
- AlphaZero-inspired
- Community-driven training
- MCTS with NN evaluation
- GPU-dependent
- Comparison to Stockfish

10.3 Implementation Comparison Table
Create comprehensive table:
| Feature | Stockfish | Leela C0 | Student Engines (Bijl, Tesseract) |
|---------|-----------|----------|-----------------------------------|
| Search | Alpha-Beta + PVS | MCTS | Alpha-Beta + PVS |
| Evaluation | NNUE (modern), Classical (legacy) | Deep NN | Classical |
| Board Rep | Bitboards | Bitboards | Bitboards (PEXT/Magic) |
| Parallel | Lazy SMP | Root parallelization | Attempted Lazy SMP |
| Strength | ~3500 | ~3500 | 1400-2450 |
| Pos/sec | 70M | 80K | 405M (move gen only) |

10.4 Design Philosophy Comparison
- Stockfish: Human knowledge + search efficiency
- Leela: Self-play + neural networks
- Hybrid approaches emerging

=== 11. Synthesis & Comparative Analysis (3-4 pages)

11.1 Classical vs Neural Evaluation
- Speed: Classical faster (NNUE slower than classical, faster than deep NN)
- Strength: NNUE/Deep NN stronger at high depth
- Interpretability: Classical wins
- Training requirements: Classical = human knowledge, NN = computational resources

11.2 Alpha-Beta vs MCTS
- Search efficiency: Alpha-Beta searches deeper
- Selectivity: MCTS more selective
- Error handling: MCTS averages errors, Alpha-Beta propagates worst
- Scalability: MCTS scales better with time (AlphaZero finding)
- Domain: Alpha-Beta dominant in chess, MCTS in Go

11.3 Implementation Complexity vs Strength Gains
Create impact table from your papers:
| Technique | Implementation Complexity | Strength Gain | Source |
|-----------|--------------------------|---------------|--------|
| MVV-LVA | Low | 68.5% speedup | Brange |
| Transposition Table | Medium | 39.8% speedup | Brange |
| Null Move Pruning | Low | Largest speedup, EBF→3.31 | Tesseract |
| Quiescence Search | Medium | Score 7307→8520 | Tesseract |
| PST | Low | Score 5640→8255 | Tesseract |
| Iterative Deepening | Low | 5% overhead, 28.7% speedup | Marsland, Brange |
| Late Move Reductions | Medium | Mixed/negative | Tesseract |
| Lazy SMP | High | Mixed (33% vs negative) | Brange, Tesseract |

11.4 The Diminishing Returns Pattern
- Basic techniques (MVV-LVA, TT, NMP): huge gains
- Advanced techniques (LMR, Lazy SMP): diminishing/negative returns
- Why? Poor implementation, or technique limitations?

=== 12. Research Gaps & Future Directions (2-3 pages)

12.1 Identified Gaps from Your Papers
- Tesseract: three-fold repetition detection
- Tesseract: Lazy SMP instability
- Bijl: formal move generator correctness proof
- Bijl: NNUE impact on bitboard representation choice
- Fiekas: shift 8 bishops impossible on d5

12.2 Emerging Trends
- NNUE dominance in classical engines
- Hybrid MCTS-minimax approaches
- Efficient training methods
- Hardware-specific optimizations (PEXT, AVX-512)

12.3 Your Research Contribution
- Benchmarking common techniques
- ELO measurement of individual contributions
- Reproducible methodology
- Gap: systematic comparison across implementations

12.4 Open Questions
- Optimal evaluation function balance (speed vs accuracy)
- Best parallel search approach
- Neural network architecture evolution
- Hardware acceleration future (TPU, specialized chips)

---

== Additional Structural Elements

=== Cross-Cutting Themes to Weave Throughout
1. Speed vs Strength Trade-off: Appears in every section
2. Empirical vs Theoretical: Knuth provides theory, others provide practice
3. Human Knowledge vs Machine Learning: Classical → NNUE → AlphaZero progression
4. Implementation Matters: Same technique, different results (LMR, Lazy SMP)

=== Visual Elements to Include
1. Figure 1: Shannon Type A vs Type B strategy comparison
2. Figure 2: Search tree with node types (PV, Cut, All)
3. Figure 3: Bitboard representation examples
4. Figure 4: Evaluation function component breakdown (pie chart from Bijl)
5. Figure 5: NNUE architecture diagram
6. Figure 6: AlphaZero vs Stockfish pos/sec comparison
7. Figure 7: Technique impact bar chart (from synthesis table)
8. Figure 8: ELO progression of engines over time

=== Writing Flow Tips
- Start each major section with: "Building on [previous concept], this section examines..."
- End each major section with: "These findings lead naturally to [next concept]..."
- Use transition paragraphs between sections to maintain narrative flow
- Cite multiple papers when they agree/disagree on a point

=== Papers-to-Sections Quick Reference
- Shannon: Sections 1, 2, 5.6, 6.1
- Knuth & Moore: Sections 2.2, 5.1
- Marsland: Sections 2.3, 5.3-5.7
- Bijl & Tiet: Sections 3, 4, 5, 6, 9
- Tesseract: Sections 3, 4, 5, 6, 8, 9
- Fiekas: Section 3.2
- Brange: Sections 5, 8, 9
- NNUE: Section 7.2
- AlphaZero: Sections 7.3, 7.4, 10
- MCTS Review: Sections 7.5, 8
- Elo Model: Section 9.1

---

This structure gives you:
- Clear progression from historical → theoretical → practical → modern
- Natural transitions between sections
- Comparative analysis woven throughout
- Real-world validation in section 10
- Synthesis bringing it all together
- Your papers are well-utilized without redundancy

You're ready to start writing tomorrow. Each section has clear papers to cite, clear themes, and clear contribution to your overall narrative.
