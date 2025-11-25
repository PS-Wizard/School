#import "layout.typ": *;

#show: academic-theme.with(
  title: "Techniques In Chess Programming: A Comprehensive Review",
  author: "Swoyam Pokharel",
  abstract: [
    This literature review explores the core techniques that have shaped modern chess programming. It begins by covering the mathematical foundations of game tree search, analyzing minimax, negamax, and alpha-beta pruning that form the backbone of traditional engines. After which, it explores the implementation approaches for board representation, different move generation techniques, and memory optimization through transposition tables and Zobrist hashing.

    Furthermore, this paper covers the transition from classical evaluation methods to the recent shift toward neural networks. It examines search optimizations like iterative deepening, quiescence search, null move pruning, and move ordering heuristics, that enable engines to search deeper while maintaining efficiency. Finally, the paper evaluates the classical alpha-beta paradigm (Stockfish) with neural network-guided Monte Carlo Tree Search approaches (AlphaZero, Leela Chess Zero), analyzing their trade-offs and the current convergence toward hybrid systems. In essence, This paper establishes the current state of chess programming and identifies the techniques that have proven essential for competitive engine development.
  ],
)

#pagebreak()

= Introduction

The game of chess has served as a proving ground for artificial intelligence research for decades now. From Claude Shannon's foundational paper framing chess as a computational problem, to Deepmind's AlphaZero achieving extremely high strength through sheer self-play; chess has redefined the boundaries of algorithmic reasoning. Today, chess engines have far exceeded human capacity, with top engines like Stockfish and Leela Chess Zero estimated to operate at over 3500 Elo, approximately 800 Elo above the best humans to play chess.

What started as theoretical curiosity, that, if solved, would to create "mechanized thinking" has now transformed into a vast domain for algorithmic innovation. Shannon recognized early on that exhaustive search was not feasible, as a typical chess game lasting 40 moves, contains approximately $10^120$ possible position variations; a number that far exceeds the number of atoms in the observable universe @shannon_1950_programming[p. 4]. This fundamental constraint, paired with the well-defined rules and clear win criteria, made chess an ideal playground for developing selective search methods, heuristic evaluation, and other fundamental techniques in modern AI.

= Foundations of Search
The strength of a chess engine fundamentally depends on its ability to search through the game tree and identify a move that leads to the best position. This section reviews the mathematical and algorithmic foundations that underpin modern chess engines.


== Minimax and Negamax Framework
Chess, like any two-player, zero-sum game, can be represented as a game tree, where nodes represent legal board positions and edges represent legal moves. The foundation of searching for the best move is the calculation of the minimax value, defined as the least upper bound on the score for the side to move, representing the true value of a position @marsland[p. 3]. This framework, first formalized in the 1950s, remains the foundational principle for search tree traversal in classical game AI @marsland[p.3] @Brange[p.18] @parallel_chess_searching[p.24-p.26].


=== Minimax Formulation
In the traditional minimax framework, two functions, $F(p)$ and $G(p)$, are defined from the perspective of the maximizing player (typically White) and the minimizing player (typically Black), respectively @knuth_1975_an[p. 4]. For a position $p$ with $d$ legal successor positions $p_1, p_2,..., p_d$, the framework is:

- *Maximizing Function*: $F(p)$ represents the best value Max can guarantee from position $p$ when it is Max's turn. If $p$ is terminal ($d = 0$), then $F(p) = f(p)$, where $f(p)$ is an evaluation function. If $d > 0$, then:
  $ F(p) = max(G(p_1), G(p_2), \ldots, G(p_d)) $

- *Minimizing Function*: $G(p)$ represents the best value Min can guarantee from position $p$ when it is Min's turn. If $p$ is terminal ($d = 0$), then $G(p) = g(p) = -f(p)$. If $d > 0$, then:
  $ G(p) = min(F(p_1), F(p_2), \ldots, F(p_d)) $

Both players play perfectly, with Max maximizing $F(p)$ and Min minimizing $G(p)$. The zero-sum property guarantees $G(p) = -F(p)$ for all positions $p$ @knuth_1975_an[p. 3].


=== Negamax Simplification
The name "negamax" comes from "negative maximum" and is a simplification of minimax. Negamax utilizes the zero-sum nature, using a single function $F(p)$ *defined from the perspective of the player to move* to maximize the negative of the opponent's score. This removes the need to oscillate between minimizing and maximizing, making the algorithm easier to implement @marsland[p.5].

- *Value Function*: $F(p)$ represents the best value the *player to move* can guarantee from position $p$, assuming optimal play.

  - If $p$ is terminal ($d = 0$): $ F(p) = f(p) $

  - If $p$ is non-terminal ($d > 0$): $ F(p) = max(-F(p_1), -F(p_2), ..., -F(p_d)) $


==== The Negative Sign
The key simplification is the negative sign, $-F(p_i)$. It exploits the zero-sum property: the opponent's advantage is the negative of the current player's advantage. The current player chooses the move that maximizes $-F(p_i)$, equivalent to minimizing $F(p_i)$.


== Pruning
A chess game typically lasts $~40$ moves with a branching factor of 35. Even for a game lasting 40 moves per player (80 plies), this yields a search space on the order of $10^40 - 10^100$. Exhaustive search is unfeasible, as the time complexity of basic negamax is $O(b^d)$, where $b = "branching factor", d = "depth"$ @shannon_1950_programming[p. 4] @marsland[p. 4]. This computational constraint has driven the development of pruning techniques that maintain search accuracy while dramatically reducing nodes examined.


=== Branch-and-Bound Optimization
Knuth and Moore present an optimization $F_1$ that improves upon pure negamax $F$ by introducing an upper bound to prune moves that can't beat already known options @knuth_1975_an[p.5].
$
  F_1(p, "bound") = cases(
    F(p) "if" F(p) < "bound",
    >= "bound" "if" F(p) >= "bound"
  )
$

When evaluating position $p$ with a known bound representing the best value achievable till now, $F_1$ returns the value if less than the bound, or "$>= "bound"$" otherwise; once a position achieves a value at least as good as the bound, the exact value is irrelevant since the opponent will avoid this line, allowing the branch to be pruned.

This reduces nodes evaluated from $O(b^d)$, though the exact reduction depends on move ordering and tree structure. This approach bridges pure negamax and alpha-beta pruning.

=== Alpha Beta Pruning
Alpha-Beta pruning is the most popular and reliable pruning method, used to speed up search without information loss. Universally recognized as the most vital algorithmic optimization for achieving practical search depth, it offers exponential complexity reduction in the best case @marsland[p.1, p.11] @Brange[p.22] @parallel_chess_searching[p.28] @tessaract[p.19]. Similar to $F_1$, alpha-beta improves efficiency by maintaining two bounds $alpha$ and $beta$.

- $alpha$: The best score the maximizing player can guarantee
- $beta$: The best score the minimizing player can guarantee

Formally, Knuth and Moore define it as,

$
  F_2(p, alpha, beta) = cases(
    F(p) & "if" alpha < F(p) < beta,
    <= alpha & "if" F(p) <= alpha,
    >= beta & "if" F(p) >= beta
  )
$

@knuth_1975_an[p.6]. Pruning happens when $alpha >= beta$; the maximizing player already has an option $alpha$ at least as good as what the opponent will allow $beta$. The minimizing player won't allow reaching this position under optimal play, so we prune that branch @marsland[p.4].


==== Deep Cutoffs
A significant advantage of alpha-beta over single bounded approaches is "deep cutoffs". Knuth and Moore demonstrated that $F_2(-infinity, +infinity)$ examines the same nodes as $F_1(p,infinity)$ until the fourth look-ahead level, but beyond, $F_2$ occasionally makes deep cutoffs that $F_1$ cannot find @knuth_1975_an[p.2, p.7]. This represents a fundamental improvement in pruning efficiency @knuth_1975_an[p.6].

==== Proof Of Optimality
Knuth and Moore investigated whether improvements beyond alpha-beta existed, such as $F_3(p,alpha,beta,gamma)$ where $gamma$ could hold additional information. They concluded no, showing alpha-beta is optimal in a reasonable sense @knuth_1975_an[p. 6]. This theoretical optimality established alpha-beta as the definitive pruning algorithm for game-tree search.

In the best case, where the "best" move is examined first at every node, alpha-beta examines $W^[D/2] + W^[D/2] -1$ terminal positions, a vast improvement over $W^D$ for exhaustive search. With branching factor 35 and depth 6, this reduces search from $~1.8$ billion nodes to $~86$ thousand.

However, this performance critically depends on move ordering. Chess programs rarely search until *true terminal* positions; instead, they end at a certain depth and evaluate using heuristic evaluation functions. To achieve performance closer to the theoretical best, chess programs employ move ordering heuristics like examining captures or checks first, or iteratively deepening to prioritize moves that performed well in shallower searches.

==== Challenging Alpha-Beta's Dominance
While Knuth and Moore's proof established alpha-beta's theoretical optimality within brute-force minimax search, recent developments challenge whether this remains optimal. AlphaZero's success with Monte Carlo Tree Search (MCTs) guided by deep neural networks demonstrated that selective search based on learned policy estimates can outperform traditional alpha-beta, despite examining $~1000times$ fewer positions @mastering[p.3-p.5]. This represents a paradigm shift from guaranteed pruning through mathematical bounds to probabilistic selection through learned heuristics.

Traditional alpha-beta engines use brute force with guaranteed pruning, while neural network guided MCTs engines seek efficiency through highly accurate selectivity learned from self-play @mastering[p.3-p.5]. While earlier MCTs implementations proved weaker than alpha-beta @mastering[p.12], coupling MCTs with deep neural networks achieved superiority, challenging the belief that alpha-beta was inherently better suited for chess. Later sections examine these contrasting and converging approaches in greater depth.


== The Horizon Effect
Beyond pruning efficiency, search algorithms must address tactical limitations. Shannon was among the earliest to recognize the "horizon effect" @shannon_1950_programming[p.6]. This effect describes a program's tendency to "hide" inevitable material loss by making delaying moves until said loss is beyond its maximum depth (the horizon). This problem emerges from computing power constraints that force programs to limit search depth and make the "best move" based on incomplete information @Brange[p.14].

The core issue is that positions evaluated at the search edge may appear favorable, but extending search by even a few moves would reveal better alternatives @bijl_2021_exploring[p.10-11]. While alpha-beta pruning significantly enhances search efficiency and enables deeper analysis, it remains vulnerable to the horizon effect since the problem persists at whatever depth search terminates.

Shannon acknowledged the importance of evaluating only "relatively quiescent" positions @shannon_1950_programming[p.6], defining a quiescent position as one assessable accurately without further deepening @marsland[p.7]. This matters because positions at the horizon frequently occur amidst tactical sequences like captures, checks, or forcing moves, creating situations that static evaluation cannot capture accurately @marsland[p.19].

=== Quiescence Search
Quiescence search is the principal approach to solving the horizon effect, ensuring positions are stable before evaluation. Sources universally agree that Quiescence Search (QS) is critical for handling tactical volatility, extending search beyond the depth limit to ensure evaluation occurs only in "quiet" positions @marsland[p.7] @parallel_chess_searching[p.41] @bijl_2021_exploring[p.11]. QS is a search extension that continues evaluation of forcing moves until a "quiet" position is reached. Rather than terminating search at fixed depth regardless of position characteristics, quiescence search adapts, extending analysis in tactical positions.

However, a consistent theoretical framework defining "true quiescence" remains undeveloped, forcing reliance on heuristic thresholds for when QS should stop @marsland[p.8]. This represents an ongoing research gap about what exactly a "quiet" position objectively means, with definitions varying between implementations. No mathematical definition has emerged to replace the intuitive heuristics currently used.

==== Performance Impact
QS often comes with big performance impacts. When Tesseract added quiescence search to an engine already equipped with transposition tables, iterative deepening, and MVV-LVA move ordering, the results were:

- *Execution time*: Reduced from 709.48s to 266.21s (62.5% faster)
- *Evaluation score*: Increased from 7,314 to 8,520 (+1,206 points)
- *Effective branching factor*: Decreased from 5.99 to 4.23 (-1.76)

The time reduction, despite searching additional moves, occurs because accurate leaf node evaluations produce more effective pruning throughout the tree. The substantial score improvement demonstrates how severely the horizon effect degrades tactical play when unaddressed @tessaract[p.20, p.31, p.50]. This reinforces the consensus that quiescence search remains a valuable technique for competitive chess engines, despite the true definition of a "quiescent" position being theoretically ambiguous.

#pagebreak()

= Entity Representation & Move Generation

Storing the board state efficiently is fundamental for any chess engine @sophie[p.13] @Brange[p.14]. Board representation significantly impacts move generation performance. Multiple sources agree that BitBoards have emerged as the dominant method for representing board state in competitive chess engines, though this reveals nuances about theoretical and practical performance @alphadeepchess[p.30] @hash_funtions[p.5] @bijl_2021_exploring[p.5].

== Approaches To Board Representation

=== Array Based Representations
These are intuitive approaches mirroring the physical board. The evolution from the 1950s onwards reflects a progression from intuitive array-based systems to specialized BitBoard approaches @bijl_2021_exploring[p.4-p.5].

==== The Two-Dimensional Array
This representation directly corresponds to the physical board layout. An $8 times 8$ two-dimensional array `chess_board[8][8]` stores piece objects at indices matching their board positions.

However, this intuitiveness comes with performance costs. Indexing requires calculating memory location `8 * rank + file` and performing multiple boundary checks, making it inefficient @bijl_2021_exploring[p.4] @tessaract[p.6]. In Bijl & Tiet's testing, this approach was slowest, at `39.189 Mn/s` in Perft and `6.327 Mn/s` in search speed @bijl_2021_exploring[p.19].

==== Mailbox
This mimics a physical board, using a single-dimensional array of 64 elements where each index can contain a piece or be empty. While simple, this is inefficient for move generation as it requires loops and conditional checks for off-board movement @sophie[p.15]. A more common approach is `0x88`.

==== 0x88
This mailbox variant pads the array, resulting in a `16x8` array with sentinel values. This padding eliminates out-of-bounds checks, reducing them to a single sentinel value comparison @bijl_2021_exploring[p.4] @tessaract[p.6-p.7]. In performance tests, the 0x88 approach was nearly equal to BitBoards in Perft speed at `46.496 Mn/s` @bijl_2021_exploring[p.19]. This challenges the conventional wisdom that BitBoard's primary advantage lies solely in move generation speed.


=== BitBoards
BitBoards are piece-centric representations utilizing the fact that an unsigned 64-bit integer has the same number of bits as squares on a chess board. First applied to chess in 1970 @bijl_2021_exploring[p. 5], this uses each bit as a corresponding representation of a square @sophie[p.16-p.26] @parallel_chess_searching[p.47-p.50] @bijl_2021_exploring[p.5].

BitBoards represent board information using 64-bit integers, allowing logical operations (unions, intersections, shifts) to execute in parallel using single CPU instructions @alphadeepchess[p.30] @hash_funtions[p.5] @bijl_2021_exploring[p.5]. Since most CPUs today use 64-bit instructions, this proves very efficient, making common operations like filtering trivial.

This representation uses different BitBoards for each piece type and color. The entire board is the logical sum (bitwise `OR`) of all these separate boards:

#figure(
  image("images/bitboard_representation.png"),
  caption: "Example Position Represented Using BitBoards",
)

BitBoards aren't limited to representing piece occupancies; they can also represent attack patterns, the core idea behind pre-computed lookup tables for fast, constant-time move generation with techniques like PEXT or Magic BitBoards.


=== Hybrid Approaches
Modern engines incorporate both BitBoards and mailbox-style approaches. BitBoards are used for filtering and move generation, while mailbox is used for fast data access. This comes at slightly larger memory cost and overhead of incrementally updating multiple data structures per move @tessaract[p.6-p.7] @bijl_2021_exploring[p.5], but the speed benefits are generally worth this overhead.

=== Why BitBoards Dominate
While sources agree that BitBoards are preferred for competitive engines @alphadeepchess[p.30] @bijl_2021_exploring[p.5], the reasons reveal interesting nuances.

Bijl & Tiet's findings challenge the conventional narrative: traditional array based representations like 0x88 can achieve comparable speeds to BitBoards in isolated move generation tasks @bijl_2021_exploring[p.20]. This is surprising given that move generation appeared to be the primary justification for adopting BitBoards.

However, BitBoards are preferred not primarily because of move generation, but because they accelerate evaluation, which heavily relies on fast bitwise operations where array based methods struggle @tessaract[p.10] @bijl_2021_exploring[p.20]. This distinction is important as the common assumption that board representation performance matters primarily for move generation is incorrect. Both architectures perform adequately in move generation, but evaluation benefits significantly from BitBoard representations @bijl_2021_exploring[p.20].

In Bijl & Tiet's complete engine tests, move generation accounted for only about 10% of processing time, with evaluation forming the primary bottleneck. Thus, BitBoards remain optimal not solely due to move generation speed, but because of performance advantages across the entire engine pipeline.

== Move Generation
Move generation is fundamental for any chess engine. Given any position, generating all legal moves quickly and accurately is critical. There are two different approaches.

=== Pseudo-Legal vs Legal Move Generation

==== Pseudo-Legal Move Generation
A pseudo-legal move follows the rules of how pieces typically move but doesn't account for whether the king is in check. If an engine takes this route, it must check legality afterward, generally by making that move on a copy of the board and verifying it doesn't leave the king in check.

==== Legal Move Generation
A legal move is a subset of pseudo-legal moves that accounts for the king being in check. This approach is more complex as it needs to account for pinned pieces, checking pieces, and typically requires producing a check-mask that filters moves @sophie[p.65].

==== Pseudo-Legal Vs Legal Move Generation
Although pseudo-legal move generation adds to running time because of the need to check legality during search @sophie[p.11], it tends to be preferred. During search with pruning heuristics like alpha-beta, if a cutoff occurs, the engine avoids wasting time generating or verifying legality of moves that would have been pruned regardless @parallel_chess_searching[p.56] @bijl_2021_exploring[p.20]. Modern engines, including #link("https://Stockfishchess.org/")[Stockfish], prefer the pseudo-legal move generation approach.

=== Generating Moves For Non-Sliding Pieces

To generate moves for non-sliding pieces (kings and knights), the standard approach is using pre-computed lookup tables. The idea is to have a 64-element array storing a BitBoard representing attacks of a non-sliding piece from each square:

#figure(
  image("images/knight_attack.png", width: 60%),
  caption: "Attacks for a knight on e4",
)

The arrows highlight all legal moves the white knight on "e4" can make, and circles highlight all illegal moves. Our attacks array `knight_attacks[64]` is defined such that:

```rust
// ("e4" = 28th bit on a BitBoard, assuming a1 = 0)

knight_attack[0] = ...
knight_attacks[28] = 44272527353856
...
knight_attack[63] = ...
```

In a BitBoard where `"a1"` is the LSB, the square `"e4"` corresponds to the $28^"th"$ bit. As such, `knight_attacks[28]` represents the attack pattern of a knight at `"e4"`:

\
#line(length: 100%)
```rust
// where the number 44272527353856,
// displayed in the form of a BitBoard, is:
//
8 . . . . . . . .
7 . . . . . . . .
6 . . . X . X . .
5 . . X . . . X .
4 . . . . . . . .
3 . . X . . . X .
2 . . . X . X . .
1 . . . . . . . .
  a b c d e f g h
```
#line(length: 100%)

To filter out capturing friendly pawns, it's simply `knight_attacks[28] & !friendly`, where `friendly` is another BitBoard representing all friendly pieces for the current side to move @Brange[p.27] @tessaract[p.7] @bijl_2021_exploring[p.6]. The same principle applies to kings.

=== Move Generation for Sliding Pieces

For sliding pieces like bishops, rooks, and queens, simple lookup tables don't suffice because their movement depends on blocker configuration. The evolution of techniques for handling sliding pieces represents a key advancement: initial runtime calculations evolved to static table lookups facilitated first by Magic BitBoards, and then by hardware-accelerated PEXT instructions @hash_funtions[p.10]. There are two main approaches:

==== Magic BitBoards
Magic BitBoards efficiently generate pseudo-legal moves for sliding pieces. They convert the move generation problem into a lookup operation; essentially a hashing technique using blocker configuration as a key to index the correct pseudo-legal attack BitBoard. Before 2013, Magic BitBoards were considered the fastest practical solution @hash_funtions[p.26] @bijl_2021_exploring[p.8]. This technique consists of:

1. *Pre-computing Phase*: At initialization, the engine enumerates all possible blocker configurations for each square and piece type using the #link("https://groups.google.com/g/rec.games.chess/c/KnJvBnhgDKU/m/yCi5yBx18PQJ")[Carry-Rippler] or similar technique. The engine calculates and stores the resulting pseudo-legal moves, creating a lookup table mapping blocker configurations to attack BitBoards @bijl_2021_exploring[p.7-p.8] @tessaract[p.10].

2. *The Magic Number*: Magic BitBoards use multiplicative hashing with carefully chosen constants (magic numbers) that act as perfect hash functions, transforming blocker configuration BitBoard into unique indices. These magic numbers are found through brute force, done once during development, then used as static values.

During runtime, the index is:
```rust
index = (blockers * magic_number) >> shift_amount

// blockers      : pieces along the ray of the sliding piece
// magic_number  : precomputed constant unique to each square
// shift_amount  : typically (64 - number_of_potential_blockers)
```

Magic BitBoards provide constant-time move generation for sliding pieces and have become the de facto standard @bijl_2021_exploring[p.7] @alphadeepchess[p.48-p.51]. While other variants like Black magics and Fixed Shift Magics exist, they tackle the same fundamental problem @hash_funtions[p.30].

==== PEXT Boards
The PEXT instruction, part of the BMI2 instruction set introduced in 2013 with Intel Haswell processors, acts as an alternative to magic BitBoards. PEXT directly computes the necessary index in a single CPU cycle, eliminating the need for magic numbers @hash_funtions[p.10] @alphadeepchess[p.51] @bijl_2021_exploring[p.8] @tessaract[p.10]. The PEXT instruction performs parallel bit extraction:

\
```rust
source: 0b10110101
mask:   0b11001100
result: 0b1011 // (bits at positions where mask=1, packed together)
```
\
For sliding pieces, PEXT eliminates the need for finding and storing magic numbers. At runtime:
```rust
index = PEXT(blockers, ray_mask)
```

==== Magic vs. PEXT
The distinction represents a hardware-driven evolution rather than a purely algorithmic advancement. PEXT's theoretical superiority depends entirely on hardware support, making Magic BitBoards the essential fallback for platforms lacking this instruction @hash_funtions[p.10] @tessaract[p.10].

However, empirical testing reveals a surprising result. Based on 100 runs of Stockfish's benchmark suite, PEXT BitBoards provide only a 2.3% speedup over Magic BitBoards @hash_funtions[p.10], corroborated by Bijl & Tiet @bijl_2021_exploring[p.20]. The choice thus becomes less about raw performance and more about implementation tradeoffs: PEXT offers simpler code without magic number generation, while Magic provides broader hardware compatibility.

Bijl & Tiet's study yielded:

#figure(
  table(
    columns: (auto, auto, auto),
    align: center,
    [*Type*], [*Perft speed (MN/s)*], [*Search speed (MN/s)*],
    [2D array based], [39.189], [6.327],
    [0x88 based], [46.496], [7.216],
    [Magic BitBoards], [48.772], [10.992],
    [PEXT BitBoards], [48.740], [11.038],
  ),
  caption: "Bijl & Tiet's findings comparing PERFT and Search Speed across representations",
)

Their findings challenge the general consensus that the main advantage of BitBoards is move generation speed @tessaract[p.6, p.10] @sophie[p.4] @parallel_chess_searching[p.49]. This shows mailbox approaches like `0x88` can keep up in Perft tests. However, in evaluation, BitBoards are significantly faster, yielding more nodes searched during actual gameplay @bijl_2021_exploring[p.19].

=== Move Representation
When an engine employs PEXT or Magic BitBoards, what it gets as pseudo-legal/legal moves is a raw BitBoard. This isn't sufficient as special moves like en-passant, castling, captures, promotions require updating multiple BitBoards. To contextualize the `make_move` function, we need to pack raw moves into an efficient structure.

The fundamental information this structure must capture is the `from` and `to` square. Representing moves requires an integer that is at least 12 bits long, with each 6-bits representing the `from` and `to` square. However, modern engines like #link("https://Stockfishchess.org/")[Stockfish] use a 16 bit representation @tessaract[p.12] @shannon_1950_programming[p.10] @bijl_2021_exploring[p. 8-9].
```
0000 000000 000000
____ ______ ______
prom   to    from
```
This encoding allocates:
- 6 bits for the `from` square (0-63)
- 6 bits for the `to` square (0-63)
- 4 bits for the promotion piece type

This encoding offers significant advantages:
- Compact Storage: Fits into a single CPU register
- Speed: Direct bit manipulation makes parsing faster compared to struct fields
- Cache Efficiency: Smaller size means more moves fit into CPU cache lines

Although engines mostly stick to 16 bit representation, some split the bits differently. Another approach is the (6-6-2-2) encoding scheme with 6 bit source, 6 bit destination, 2 bit move type, and 2 bit promotion piece. This variant explicitly tags special moves, simplifying move execution logic and aiding move ordering, but limits promotion encoding.

When Tesseract adopted this 16-bit encoding scheme over a naive struct/class implementation, move generation speed increased by nearly 50% @tessaract[p.12].

=== Perft

==== Correctness and Validation
Perft, short for performance test, is a fundamental debugging and validating tool in chess engine development. It operates by recursively generating the entire game tree for a specific position up to a given depth and counting all resulting nodes @alphadeepchess[p.41] @sophie[p.67] @tessaract[p.16]. Developers can compare the nodes their engine calculates with reputable engines or visit websites sharing consensus such as #link("https://www.chessprogramming.org/Perft_Results")[chess programming wiki].

==== Performance Indicator
Because of chess's branching factor, just 9 plies deep from the starting position yields over 2.4 trillion leaf nodes. Due to this computationally heavy nature, Perft can also act as a performance measure in an engine as evident in Tesseract's benchmarks and Bijl & Tiet's study @bijl_2021_exploring[p.19] @tessaract[p.17].
= Foundations Of Evaluation
Shannon first introduced the concept of an approximate evaluation function $f(P)$ to guide chess engines in selecting the best move, as he recognized that searching the entire game tree is unfeasible @alphadeepchess[p.18] @shannon_1950_programming[p. 4-6]. This foundational insight established evaluation as a critical component of chess programming, with sources consistently agreeing that evaluation must address both material balance and positional factors @marsland[p.3] @alphadeepchess[p.33] @shannon_1950_programming[p.17] @bijl_2021_exploring[p.12].

Originally, Shannon described this evaluating function $f(P)$ as one based on a combination of various established chess concepts and general chess principles that approximates the long-term advantages of a position. He also noted that $f(P)$ would produce a continuous quality range that reflects the "quality" of a move, as no move in chess is inherently wrong or right in the literal sense. Most notably, Shannon suggested that $f(P)$ should include material advantage, pawn formation, piece mobility, and king safety @shannon_1950_programming[p.5, p.17]. These classical components, proposed in 1950, formed the baseline that evolved into increasingly specialized and complex heuristics through the 1980s and 1990s @mastering[p.10].

This section, taking basis from Shannon's work, covers the techniques concerned with evaluating a position that chess engines have implemented over the years.

== Hand Crafted Evaluation (HCE)

Engines have historically used Hand Crafted Evaluation functions that account for different features @mastering[p.10] @mcts[p.2] @shannon_1950_programming[p. 5]. Historically, evaluation was an exercise in highly complex hand-crafted functions, relying on human chess knowledge to identify and weight features @mastering[p.2] @shannon_1950_programming[p.5]. Although the exact combinations of these heuristics differed from engine to engine, the key factors Shannon suggested formed the foundation for all subsequent HCE development.

=== Materialistic Approach

Material advantage is generally a stronger indicator compared to other positional factors and is also perhaps the simplest form of evaluation. The intuition is simple: "if you are up pieces, then you are probably winning." Material score, with weighted piece values, forms the quantitative baseline for evaluation @shannon_1950_programming[p.17] @marsland[p.2] @alphadeepchess[p.34]. This technique simply subtracts the total material scores of the two sides, and these values are generally represented in centipawns:

$
    "Pawn" & = 100 \
  "Knight" & = 320 \
  "Bishop" & = 330 \
    "Rook" & = 550 \
   "Queen" & = 950
$

@marsland[p.3] @alphadeepchess[p.34]. Although these values are the de-facto standard, Bijl & Tiet also note a study from S. Droste and J. Furnkranz for assigning values to pieces using reinforcement learning that yielded the following @bijl_2021_exploring[p.12]:

$
    "Pawn" & = 100 \
  "Knight" & = 270 \
  "Bishop" & = 290 \
    "Rook" & = 430 \
   "Queen" & = 890
$

=== Positional and Strategic Heuristics

In a game of chess, material is not everything; other factors such as king safety, mobility, and pawn structure determine whether a position is good or bad. Positional elements ( mobility, pawn structure, king safety) are necessary for strong play @shannon_1950_programming[p.17] @marsland[p.2] @alphadeepchess[p.34]. As such, to encapsulate these factors, chess engines have employed various techniques:

==== Piece Square Tables (PSTs)

Piece Square Tables are piece-specific, precomputed tables that assign a bonus or a penalty for a piece depending on its square. They are used to represent the fact that a piece's effectiveness is dependent on its position. For instance, take the following position into consideration:

#figure(
  image("images/random_pos.png", width: 60%),
  caption: "A Position With Equal Material Count",
)

Although both sides have the same material count, the Black's Knight is arguably better than the White's Knight as it is towards the center and covers more squares @alphadeepchess[p.35] @Brange[p.31] @tessaract[p.33].

Tesseract's performance analysis shows that the implementation of PSTs caused the evaluation to go from 5640 to 8255, the single biggest evaluation impact amongst other heuristics. He also concludes that the most important heuristics for the evaluation function were the material and positional scores @tessaract[p.38-p.39]. This validation demonstrates PSTs' critical role in bridging the gap between pure material counting and nuanced positional understanding.

==== Pawn Structure

Another positional aspect is the pawn structure; isolated, doubled, or backwards pawns are weak. As such, engines penalize the evaluation of such positions @bijl_2021_exploring[p.15] @tessaract[p.36].

==== Mobility
Mobility can be defined as the number of legal moves available to a piece @bijl_2021_exploring[p.14] @parallel_chess_searching[p.57].  A higher mobility score yields a better positional score compared to a lower one.

==== King Safety
The King is the most important piece, as such its safety matters very much. Engines often approximate this by accounting for the proximity of enemy pieces and that of the friendly pieces. The bonus or penalty is then applied as needed @alphadeepchess[p.53] @tessaract[p.34].

==== Tapered Evaluation

To account for the fact that a piece's value and its position are also dependent on the stage of the game, this technique is used. The technique of tapered evaluation is agreed upon as necessary to adjust heuristic scores dynamically based on the game phase (midgame versus endgame) to reflect the shifting value of pieces and positional constraints @alphadeepchess[p.35] @bijl_2021_exploring[p.13]. This is done to capture the fact that, say, a pawn in the early game is worth less compared to that in the endgame, or the fact that a king towards the center of the board is a huge problem in the early game but is actually wanted in the endgame. As such, engines typically employ 2 different sets of PSTs and interpolate between them depending on the stage of the game @alphadeepchess[p.35] @tessaract[p.33].

=== Parameter Tuning

Tuning these PSTs and values is a way to increase the efficiency of these techniques. Bijl & Tiet's sequential tuning resulted in an average win rate increase of 15%. Their study also revealed that search depth was an important factor that determined the value of a piece. They found that the optimal Knight Material Score decreased with increasing depth, but the bishop pair increased. Their study also shows that stacked rooks were ranked high across all iterations of tuning @bijl_2021_exploring[p.20]. This depth-dependent variation in piece values challenges the notion of fixed material scores and suggests that optimal evaluation is context-sensitive. The findings imply that S. Droste and J. Furnkranz's reinforcement learning-derived values might have been more accurate than traditional centipawn assignments @bijl_2021_exploring[p.12], though this remains an open question requiring further validation.


#pagebreak()

= Search Enhancements & Optimizations
This section expands upon the fundamentals and cover more advanced optimization techniques that modern engines implement. Building upon the foundational search algorithms, these enhancements represent the accumulated refinements developed over decades of chess programming, transforming theoretical frameworks into practical, high-performance systems.

== Memory-Aided Search
=== Transposition Tables
In any chess game, the same positions can be reached in different sequences of moves. For instance, take the following move sequences into consideration:

$
  "Starting position → 1. e4 e5 2. Nf3 Nc6" \
  "Starting position → 1. Nf3 Nc6 2. e4 e5"
$

Although the order in which the moves were made are different, the final position reached is inherently the same. These sequences are called transpositions. When an engine explores the game tree, it encounters the same position in multiple branches. Without a transposition table, the engine would, for each of these branches, re-calculate the evaluation for the same position over and over again. Transposition tables are data structures, typically hash tables that store the evaluation of a position that has already been reached, for it to be re-used later @marsland[p.13] @bijl_2021_exploring[p. 10] @alphadeepchess[p.45]. Sources universally recognize Transposition Tables (TPT) as essential aids to pruning, enabling exact forward pruning (avoiding redundant searches for previously solved positions) and providing crucial information for move ordering @marsland[p.13] @parallel_chess_searching[p.34] @bijl_2021_exploring[p.10] @tessaract[p.20].

==== Zobrist Hashing
Zobrist Hashing is the most popular way to generate the hash for game positions. It is universally accepted as the standard algorithm for computing position hash keys for transposition tables @marsland[p.14] @zobrist @bijl_2021_exploring[p.9] @tessaract[p.18]. It is an incremental hashing technique that involves calculating the hash by `XOR`-ing together pregenerated 64 bit numbers corresponding to every piece type on every square, together with other game states like castling rights, en passant square, and the side to move. Although Zobrist Hashing is not perfect, as it yields a chance to collide (~0.000003% with 1 billion moves stored) @zobrist[p.10], the chance is small enough to be effectively zero for practical purposes. The key advantage of this technique is its incremental nature, allowing the hash to be updated in just 2-4 `XOR` operations, rather than recalculating from scratch. Zobrist keys are efficiently updated incrementally via XOR operations @marsland[p.14] @bijl_2021_exploring[p.9] @zobrist[p.5, p.10] @parallel_chess_searching[p.36] @tessaract[p.18].

==== Transposition Table Entry
Each entry in the table stores multiple things to maximize its effectiveness @alphadeepchess[p.48] @marsland[p.14] @Brange[p.36] @parallel_chess_searching[p.100]:

- The Zobrist Hash: The full 64-bit hash of the position. This is used to verify that the entry in the table is correct and detect index collisions

- Evaluation: The result yielded by the evaluation function

- Depth: The depth to which the search was calculated. This value is generally used to determine if the entry should be overridden with a more extensive search.

- Best Move: The best move found during the search, this is the foundation for move ordering in future searches.

- Age: This is used to identify stale entries from previous searches.

- Node Type: Due to alpha-beta pruning, not all searches result in exact scores, the node type represents these cases
  - `EXACT`: The search completed fully without cutoffs, the exact evaluation score for the position is searched. This occurs when the score falls between the search window ($alpha$ < `score` < $beta$)

  - `LOWERBOUND`: A beta cutoff occurred, meaning that the score is at least as good as the stored value, but it could also be better. This happens when a good move was found, (`score` >= $beta$), causing the search to end early. Thus, this stored score can only be used if it's greater than or equal to the current $beta$ value

  - `UPPERBOUND`: An alpha cutoff occurred, meaning that none of moves scored better than the current best value (`score` <= $alpha$). Thus, this stored score can only be used if it's less than or equal to the current $alpha$ value.

==== Replacement Schemes
Since Transposition Tables are often fixed in size due to resource limitations @marsland[p.16] @zobrist[p.2], entries in the table need to be overwritten. The most common replacement strategies are:

- Always Replace: The simplest strategy is to unconditionally overwrite any existing entry with a new one. While simple to implement, it has significant drawbacks. This strategy is prone to shallow searches replacing the deeper ones, losing valuable information. As such, this strategy is rarely seen in chess engines.

- Depth Preferred Replacement: This technique acknowledges that deeper searches are more valuable than the shallower ones, as such an entry is replaced only if the new entry is greater in depth than the currently stored one. This preserves the most computationally expensive searches, while still allowing updates where it is better.

=== Syzygy Tablebases
Chess endgames with seven or fewer pieces have been completely solved through exhaustive retrograde analysis @parallel_chess_searching[p.11]. Engines can leverage tablebases, such as #link("https://www.chessprogramming.org/Ronald_de_Man")[Ronald de Man's] Syzygy tablebases, to achieve perfect endgame play @bijl_2021_exploring[p.21]. These tablebases work by analyzing positions backwards from known outcomes (checkmate, stalemate, or drawn positions) to determine the optimal move and outcome for every possible configuration.

However, the storage requirements are substantial. The complete Syzygy tablebases scale dramatically with piece count: 3-5 piece endgames require 939 MiB, 6-piece endgames expand to 149.2 GB, and the full 7-piece tablebase consumes 16.7 TiB of storage #link("https://www.chessprogramming.org/Syzygy_Bases")[source]. This massive data requirement echoes Shannon's original proposal for a "dictionary" storing optimal moves for all positions @shannon_1950_programming[p.4]; an idea he dismissed as impractical due to size constraints. While Shannon's vision of solving the entire game remains infeasible ($10^120$ positions), modern engines have realized a practical subset: perfect play for the simplified positions that matter most, once sufficient material has been traded off the board.

=== Refutation Tables
In chess, a refutation is a move that punishes the opponent's last move, proving that it was a mistake. For instance,
```
Black plays: Nf6 (developing the knight)
White responds: e5 (kicks the knight, "refutes" the idea)
```
and if this refutation worked well, the engine remembers to try the same move next time. A refutation table is a lightweight data structure that stores these effective refutations and main continuations. It is much simpler than the transposition table employing arrays instead of hashes, and are often referred to as space-efficient alternative to transposition tables. This table is often preferred for low end devices with memory constraints. For devices with no memory constraint, this technique is still used as an additional aid for the search @marsland[p.16].

== Iterative Deepening

Iterative Deepening, also known as "iterated aspiration search" or "progressive deepening"; a term first coined by de Groot @deGroot1965, is an optimization technique that chess engines employ, especially those that implement alpha-beta pruning. All traditional engines employ Iterative Deepening as a standard procedure to manage search time and enhance performance by improving move ordering and hash table utility across increasing depths @marsland[p.19] @Brange[p.38] @bijl_2021_exploring[p.11] @tessaract[p.21]. The idea behind iterative deepening is that when a search is requested to $D$ plies, the search will first go 1-ply, then 2-ply, and so on until it reaches $D$. Although this may seem counter-intuitive, as we're repeating the same search over and over again in each iteration, engines use the information gained from these shallow searches to prioritize the best moves in deeper searches, which prunes a lot of branches. If caches like transposition tables are also implemented, it's is also possible that iterative deepening searches faster than an immediate search to the same depth @bijl_2021_exploring[p.10] @alphadeepchess[p.32] @Brange[p.38].

=== Benefits of Iterative Deepening

==== Time Management

Iterative Deepening is perhaps the de-facto standard for time management, as it ensures that if a search is interrupted (e.g., due to a time limit), we have the result from the previously completed depth. As such, the result from the previous shallower depth search can be used rather than the deeper but incomplete search @marsland[p.17] @parallel_chess_searching[p.39].

==== Move Ordering

Iterative Deepening helps move ordering significantly. Generally, the promising moves from previous shallower searches are searched first, and as such, the likelihood of finding a good move goes up, enabling more pruning. The overall efficiency of iterative deepening comes from the fact that it can use the information from the previous search to get the Principal Variation, and then use that information to reorder moves in the current deeper search.

In an empirical analysis of the KLAS engine, Brange mentions that the use of Iterative Deepening along with PV-Ordering caused the average search time to decrease by 28.7% on average @Brange[p.47].

==== Aspiration Windows
The search score obtained from a previously evaluated position often serves as a good approximation for the expected value of the current search. By leveraging this information, the engine can initialize a narrow search window. This tighter bound significantly reduces the number of nodes that need to be explored, since it increases the likelihood of early cutoffs during alpha–beta pruning @tessaract[p.21] @parallel_chess_searching[p.33].


== Advanced Alpha-Beta Variations

=== Principle Variation Search (PVS) / Negascout
PVS or Negascout is an optimization of alpha-beta that exploits move ordering. Assuming the first move is likely best, PVS searches it with a full window [$alpha, beta$] to determine its exact value. Subsequent moves are searched with a minimal window (typically [$alpha, alpha+1$]) to quickly verify they score no better than the first move. These narrow window searches are significantly faster because they produce more cutoffs. If a minimal window search fails, indicating a move may actually be superior, PVS searches it again with the full window to find its true value. In this case, the algorithm takes the cost of a re-search, but with good move ordering this situation is rare enough that the approach remains beneficial overall @marsland[p.9] @parallel_chess_searching[p.40] @tessaract[p.22].

=== MTD(f)
MTD(f), short for Memory-enhanced Test Driver with node f, takes a different approach from PVS by performing multiple minimal window searches that converge on the minimax value. Instead of searching once with a full window, it starts with an initial guess (typically from a previous iteration or transposition table) and repeatedly searches with minimal windows around that guess. If the search yields a value $>= beta$, the true value is at least $beta$, so the algorithm searches again with a higher window. If the search yields $< beta$, the value is below $beta$, prompting a search with a lower window. This process continues until the bounds converge on the exact minimax value.

This approach performs less work per individual search since minimal windows produce more cutoffs, but it requires searching multiple times. As such, a strong transposition table is essential to avoid redundantly re-computing positions across multiple passes. In practice, MTD(f) can outperform PVS when combined with effective hashing @negascout. Despite its promise, PVS remains more widely adopted due to its simpler implementation and less strict dependency on transposition tables.

== Move Ordering Heuristics
Move ordering is critical for pruning effectiveness, as it establishes the threshold against which other positions are evaluated, allowing for subsequent, worse branches, to be ignored @parallel_chess_searching[p.31] @alphadeepchess[p.22]. Move ordering heuristics  were developed specifically to maximize alpha-beta's pruning capability @marsland[p.12].

=== Transposition Table Move (TT Move)
The intuition behind the TT Move ordering is that the transposition table stores previously searched positions along with their best moves. So, when an engine encounters the same position, the table tells it what move was best last time. Depending on the depth, it's fair to assume that the same move is still probably very good since it's not just a heuristic guess from the evaluation function but a proven score from the search itself. Thus, transposition tables help both avoid re-computation and improve move ordering @parallel_chess_searching[p.37] @marsland[p.13].

=== MVV-LVA
The Most Valuable Victim - Least Valuable Aggressor (MVV-LVA) is a simple yet reasonably effective heuristic for ordering captures. It prioritizes positive material trades; for example, ordering a pawn capturing a queen ahead of a queen capturing a pawn. The idea is simple, winning material is good, and doing so without risking your valuable pieces is even better. This heuristic is fast to compute and works well because captures that win material often cause beta cutoffs @alphadeepchess[p.42] @mastering[p.11] @Brange[p.34]. In an assessment of the KLAS engine, MVV-LVA ordering resulted in the single biggest performance impact, decreasing execution time by 68.5% @Brange[p.45], which is evidence of its effectiveness.

=== Killer Heuristics
Killer moves are aliases for non-capture moves that caused beta cutoffs at the same depth in sibling positions. The key insight is that if a move was strong enough to cause a cutoff in a position at this depth, that move is likely to do the same at other positions at the same depth too, and as such searching this move early is probably beneficial. Typically, the two most frequently occurring "killers" at each level of the search tree are tracked, and a quiet move that matches a tracked "killer" is given a bonus score to prioritize it amongst other quiet ones @parallel_chess_searching[p.38] @alphadeepchess[p. 42-p.43] @marsland[p. 12].

=== History Heuristic
The History Heuristic tracks how often a move causes a beta cutoff across the entire search tree. Generally, this is done by maintaining a table indexed by `[from_square][to_square]`, incrementing the score each time that move causes a cutoff. Unlike killers, history is *global across all depths and positions* and thus captures broader patterns about which moves tend to perform well. The history heuristic is often applied to sort the remainder of the non-capture moves after other ordering schemes like killer moves have been applied @marsland[p.12] @parallel_chess_searching[p.39].

== Selective Search Extensions
These are mechanisms used in game-tree searching to strategically increase the search depth of certain moves, beyond the fixed depth @marsland[p.3]. The primary purpose of selective search extensions is to shape the game-tree so that "interesting" positions are explored more thoroughly and uninteresting ones aren't. Shannon categorizes this as a *type B* strategy @shannon_1950_programming[p.13]. However, these extensions need to be controlled as the tree can explode in size if done too frequently or extensively @parallel_chess_searching[p.43].

=== Check Extensions
Checks are the most forceful type of move, as they limit the responses from the opponent. The rationale behind check extension is that, if an opponent is in check, it is reasonable to assume that it might lead to a checkmate, as such extending the analysis of this move might be beneficial. And since the opponent's responses are limited, it's not too computationally expensive. As such, check extensions are the most common type of extension heuristic. Check extensions differ from quiescence search in that they occur during the main alpha-beta search before the depth limit is reached, while quiescence search happens after the normal search depth is exhausted and continues until the position is tactically quiet @parallel_chess_searching[p.42].

=== Pawn Pushes
In this mechanic, the search is extended if the pawn is near promotion, typically when a pawn is moved to the 7th (for white) or 2nd (for black) rank. Passed pawns advancing to these ranks create significant threats that can drastically alter the evaluation, making deeper analysis necessary to assess promotion threats and defensive resources accurately. This should optimally be added to quiescence search itself if possible @parallel_chess_searching[p.43] @marsland[p.8].

=== Singular Extensions
This extension focuses on situations where the best move is very clear or forced. The engine performs a reduced-depth search excluding the best move candidate; if all alternative moves fail significantly below the current best move's value, the best move is considered "singular" and the search is extended. This identifies tactically or strategically forced moves that warrant deeper analysis @parallel_chess_searching[p.10] @bijl_2021_exploring[p.13].

=== One Reply Extensions
When a position has only one legal move (or one non-losing move), the search is extended since the response is forced. Since there are no alternative moves to consider, extending the search incurs minimal computational cost while ensuring forced sequences are analyzed completely. This helps resolve tactical lines where the opponent has no meaningful choice @parallel_chess_searching[p.42].

== Pruning Techniques

=== Null Move Pruning (NMP)
Null move pruning exploits the observation that, in most positions, making any legal move is preferable to passing a turn. Sources recognize Null Move Pruning (NMP) as a highly effective speculative heuristic that can provide significant speedup (e.g., cutting 2 plies), provided constraints are applied to avoid illegal states (check) or unreliable results (zugzwang endgames) @mastering[p.10] @parallel_chess_searching[p.43] @bijl_2021_exploring[p.12] @tessaract[p.25]. The technique operates by allowing the side to move to "pass" (make a null move), giving the opponent two consecutive moves, and searching the resulting position with reduced depth. If this deliberately weakened position still produces a score $>= beta$, the engine can safely assume that the current position is so strong that at least one real move will exceed $beta$, allowing the subtree to be pruned @mastering[p.10] @parallel_chess_searching[p.43].

The search after the null move is typically performed with a reduced depth (commonly $D-R-1$, where $R$ is the reduction factor, usually 2 or 3) and a narrow window around $beta$ to quickly verify the position's strength. However, this technique relies on the fundamental assumption that zugzwang positions, where passing would be preferable to any legal move, are rare. Since zugzwang occurs more frequently in endgames with few pieces, engines typically disable null move pruning in such positions or when in check, as the null move assumption breaks down @bijl_2021_exploring[p.12].

=== Late Move Reduction (LMR)
Late move reduction exploits strong move ordering to reduce search effort on moves that are unlikely to be best. In a well-ordered move list, the most promising moves appear first, while later moves are statistically less likely to improve upon the current best line. Rather than searching all moves to the full depth $D$, LMR searches later moves to a reduced depth, typically $D-R$ where $R$ increases with move number and decreases with depth. Unlike Principal Variation Search (PVS), which operates with narrow search windows at full depth, LMR fundamentally alters the search depth itself. To avoid missing tactical opportunities, LMR includes safeguards that prevent reduction of tactically critical moves such as captures, promotions, checks, check evasions, and killer moves. If a reduced-depth search returns a score within the $[alpha, beta]$ window,indicating the move may be better than expected,the engine re-searches the move at full depth. While this re-search incurs additional cost, effective move ordering ensures such cases are rare enough that the overall trade-off remains positive @bijl_2021_exploring[p.12] @alphadeepchess[p.55] @tessaract[p.26].

=== The Sensitivity of LMR Implementation
The effectiveness of LMR is heavily dependent on move ordering quality. LMR is implemented in top engines like Stockfish, indicating its value when refined @bijl_2021_exploring[p.12]. However, several developers found implementing LMR reliably resulted in worse performance or Elo drops due to its very aggressive pruning settings causing blunders @alphadeepchess[p.63] @tessaract[p.27].

AlphaDeepChess reported no improvement from implementing LMR due to insufficient move ordering strength @alphadeepchess[p.65]. In contrast, the Tesseract engine demonstrated significant performance gains, reducing average search time from 83.87 to 64.13 milliseconds, but with a corresponding decrease in score from 8584 to 8124 @tessaract[p.26].

LMR is a sensitive technique whose net benefit is heavily dependent on the quality of auxiliary systems, especially accurate move ordering heuristics that prevent good moves from being misclassified as "late". Weak supporting systems cause LMR to fail @alphadeepchess[p.63] @tessaract[p.27]. This trade-off illustrates the delicate nature of LMR and other aggressive pruning techniques. A research gap remains in creating accessible and robust implementations of aggressive pruning like LMR that do not suffer search instability or blunders when used outside of the highly optimized environments of top commercial engines @tessaract[p.26].

=== Futility Pruning
Futility pruning eliminates moves that are unlikely to raise the score above $alpha$ when the search is near the horizon. The technique operates on the principle that if a position's static evaluation plus a generous margin still falls below $alpha$, and only a few plies remain to the search horizon, then quiet moves (non-tactical moves) are unlikely to dramatically improve the position and can be safely pruned @parallel_chess_searching[p.41] @marsland[p.11].

This optimization is particularly effective when applied with quiescence search, as it helps limit the explosive branching factor of the quiescence tree. Futility pruning typically applies only at nodes one or two plies from the horizon and to quiet moves, as tactical moves (captures, promotions, checks) can cause non-linear evaluation changes that go against the futility assumption.

== Parallel Search
As modern CPUs have evolved to include multiple cores, parallelizing the search has become the natural next step. The intuition is simple: if one core is fast, multiple cores should be faster. However, the reality is more nuanced. Alpha-beta search is inherently sequential; the results from searching one move provide critical information for pruning subsequent moves. When the work is distributed across threads to search different subtrees simultaneously, this pruning information is not immediately available across threads. Each thread ends up searching more nodes than would be examined in a sequential search, because they lack real-time access to each other's cutoff discoveries. This is why parallelization yields diminishing returns: a speedup of only 9.2x was observed on 22 processors, far short of the theoretical 22x @parallel_chess_searching[p. 3, p.78].

To prevent threads from redundantly searching the same positions, shared data structures like the transposition table are employed. However, concurrent access to these global structures introduces its own costs; synchronization overhead from mutex locks or atomic operations can become significant. The tree size growth from parallelization overhead appears to be roughly linear @parallel_chess_searching[p. 78], meaning that the combined effect of sub-linear speedup and linear growth in nodes searched results in only modest time reductions when using many processors. At some point, adding more processors no longer translates to a meaningfully faster search. This section examines the two most common approaches to parallelizing chess search: Young Brothers Wait Concept (YBWC) and Lazy SMP.

=== Young Brothers Wait Concept (YBWC)
The Young Brothers Wait Concept (YBWC) represents an early, theoretically principled approach to parallelizing alpha-beta search. The algorithm is straightforward: search the first child node sequentially with the main thread, then distribute the remaining "young brother" nodes among multiple threads for parallel evaluation. During the sequential phase, helper threads remain idle, waiting for the principal variation search to complete before they can begin their work @parallel_chess_searching[p.62] @alphadeepchess[p.55].

This design aligns with the structure of alpha-beta node types. In Type 1 (PV) nodes, where all children must be searched, YBWC's sequential first approach establishes tight alpha and beta bounds before parallelizing the remaining children @parallel_chess_searching[p. 78]. Similarly, for Type 2 (CUT) nodes with good move ordering, a cutoff typically occurs after searching the first child, meaning the young brothers never need to be searched at all,making the wait concept perfectly efficient @parallel_chess_searching[p. 62]. However, YBWC proves suboptimal for Type 3 (ALL) nodes, where all children must be searched regardless. Here, forcing the first child to be searched sequentially wastes potential parallelism, as all children could have been evaluated simultaneously from the start.

Despite its theoretical soundness, YBWC has struggled in practice. The AlphaDeepChess project implemented YBWC for its multithreaded search but observed performance degradation rather than improvement. The decline was attributed to synchronization overhead, the costs of thread creation and destruction, and the implementation's inability to leverage a shared transposition table for concurrent access @alphadeepchess[p.62]. These practical challenges have led modern engines, most notably Stockfish, to #link("https://github.com/official-Stockfish/Stockfish/commit/ecc5ff6693f116f4a8ae5f5080252f29b279c0a1")[switch away from YBWC to Lazy SMP].

=== Lazy SMP
Lazy Symmetric MultiProcessing (Lazy SMP) takes a very different approach to parallelization. Rather than carefully coordinating threads, it spawns independent threads that each perform a complete search autonomously, sharing information only through the transposition table @Brange[p.39] @tessaract[p.27].

This "lazy" technique; allowing threads to redundantly search similar positions instead of enforcing perfect work distribution, sounds counterintuitive, yet proves remarkably effective in practice. To prevent threads from exploring identical lines simultaneously, implementations employ randomized move ordering at the root node, ensuring each thread's search diverges early @Brange[p.39] @tessaract[p.27].

In practice, Lazy SMP achieved a 33.1% reduction in average execution time on a four-core system in the KLAS engine @Brange[p.58] and a 40% speedup in Tesseract @tessaract[p.27]. However, these gains come with tradeoffs; memory usage increases substantially, and garbage collection overhead can become significant, as noted in the KLAS implementation @Brange[p.58]. Nevertheless, despite these costs and its inherently wasteful nature, Lazy SMP remains the dominant multithreaded search method in modern chess engines, outcompeting more theoretically sound alternatives through sheer simplicity.

However, a research gap still remains in determining the optimal way to integrate modern parallel processing techniques into the core alpha-beta algorithm to maximize parallel scaling benefits.



= Evaluation Optimizations & Enhancements

Despite their historical dominance and continued utility, HCE functions face a fundamental limitation: they rely on human domain expertise and are bounded by the strategies and heuristics humans can explicitly model @mastering[p.2] @shannon_1950_programming[p.5]. This means that even the best HCE is theoretically limited to the level of the best human player's explicit understanding. This limitation becomes apparent when trying to explicitly model non-linear relationships, that are guided by human intuition @mastering[p.12] @Nasu2018NNUE[p.1] @Nasu2018NNUEOriginal.

This gap has paved the way for the shift toward neural network-based evaluation, which leverages machine learning to capture patterns that go beyond human definition, resulting in demonstrably stronger evaluations.

== Monte Carlo Tree Search and Neural Network Engines

Moving away from traditional alpha-beta architectures, engines like AlphaZero and Leela Chess Zero employ Monte Carlo Tree Search (MCTs), a fundamentally different approach to finding the best move. Unlike alpha-beta search which aims for exhaustive coverage within a depth limit, MCTs grows its tree asymmetrically, concentrating computational effort on the most promising variations @mastering[p.3]. This represents the paradigm shift in the search algorithms: traditional high performance chess engines like pre-NNUE Stockfish relied heavily on refined, hand-crafted heuristics guiding highly efficient alpha-beta search, while AlphaZero's algorithm entirely replaced alpha-beta search with a general purpose MCTs guided by a deep neural network, demonstrating that selective search based on learned policy value estimates can surpass the brute-force efficiency of alpha-beta search @mastering[p.3-p.5].

=== MCTs Algorithm

MCTs operates through four iterative phases that build the search tree incrementally:
+ *Selection*: Starting from the root position, traverse the tree by selecting moves that balance exploring new possibilities with exploiting known strong lines, guided by the UCB1 (Upper Confidence Bound) formula.
+ *Expansion*: When reaching an unvisited position, add it to the tree as a new node.
+ *Simulation*: Evaluate the new position to estimate its value (traditionally via random playouts, but in AlphaZero using neural network evaluation).
+ *Backpropagation*: Update the value estimates and visit counts for all positions along the path from the new node back to the root.

This process repeats thousands of times per move, gradually building confidence about which moves are strongest.

=== AlphaZero's Neural-Guided MCTs

In AlphaZero, MCTs is guided by a deep neural network $f_theta (s)$ that takes the board position $s$ as input and outputs two critical values @mastering[p.2]:
+ *Policy ($bold(p)$)*: A probability distribution indicating which moves are most promising.
+ *Value ($v$)*: An estimate of the expected game outcome from this position (ranging from -1 for a loss to +1 for a win).

AlphaZero has no handcrafted chess knowledge beyond the basic rules and learns entirely through self-play reinforcement learning. The network trains by minimizing a loss function $l$ via gradient descent, where $l$ combines two components @mastering[p.3]:

- *Value Loss*: $(z - v)^2$, minimizing the mean-squared error between the predicted outcome $v$ and the actual game outcome $z$ (where $z = +1$ for win, $0$ for draw, $-1$ for loss)

- *Policy Loss*: $-bold(pi)^T log bold(p)$, maximizing similarity between the network's policy $bold(p)$ and the search probabilities $bold(pi)$ generated by MCTs

Notably, AlphaZero optimizes for expected outcome (accounting for draws as $0$), whereas its predecessor AlphaGo Zero treated draws as losses, optimizing only for win probability @mastering[p.3].

=== Comparison with Traditional Engines

This neural-guided MCTs approach differs fundamentally from traditional alpha-beta engines:

#figure(
  table(
    columns: (auto, auto, auto),
    align: left,
    [*Aspect*], [*AlphaZero / MCTs*], [*Stockfish / Alpha-Beta*],
    [Primary Algorithm], [Monte Carlo Tree Search], [Alpha-Beta Pruning],
    [Evaluation], [Deep Neural Network], [HCE / NNUE],
    [Knowledge Source], [Learned from self-play], [Handcrafted + tuning],
    [Search Strategy], [Selective, focused on promising lines], [Broad, exhaustive within depth],
    [Evaluation Speed], [~80,000 positions/second], [~70,000,000 positions/second],
    [Search Depth], [Deeper in critical lines], [Uniform depth with extensions],
    [Hardware], [GPU-optimized], [CPU-optimized],
    [Interpretability], [Black box], [Transparent heuristics],
  ),
  caption: "Comparison of AlphaZero and Traditional Engine Approaches",
)

The most striking difference is evaluation speed: AlphaZero examines approximately 80,000 positions per second while Stockfish evaluates roughly 70 million. However, AlphaZero compensates for this speed disadvantage through superior selectivity, using its neural network to prioritize the most promising lines and achieving superior results despite searching $~1000 times$ fewer positions @mastering[p.4].

While older MCTs implementations proved weaker than alpha-beta @mastering[p.12], coupling MCTs with deep neural networks achieved superiority, challenging the widespread belief that alpha-beta was inherently better suited for these domains. In head-to-head competition, using 64 threads and a hash size of 1GB, AlphaZero convincingly defeated all opponents, losing zero games to Stockfish @mastering[p.5].

== NNUE ( ƎUИИ Efficiently Updatable Neural Networks )
The Efficiently Updatable Neural Network (NNUE) represents a major shift in how chess engines, particularly, approach evaluation functions. Originally proposed by Yu Nasu @Nasu2018NNUE for computer shogi, NNUE introduces a hybrid paradigm that merges the pattern recognition strength of neural networks with the speed of traditional handcrafted evaluators. The shift towards neural networks began in specialized fields like Shogi (Sankoma-Kankei models) @Nasu2018NNUE, accelerating quickly with the successes of AlphaZero (2017) @mastering. The later creation of the NNUE architecture (2018-2019) enabled top alpha-beta engines like Stockfish to successfully migrate to neural network evaluation without sacrificing the speed of alpha-beta search, representing the current state of the art @Stockfish2025NNUEWiki. The architecture was first integrated into Stockfish in 2019, and a #link("https://www.chessprogramming.org/File:NNEUOneYearEloGain.png")[big performance leap] was observed.

Unlike deep convolutional or reinforcement-learning models such as AlphaZero, NNUE is designed explicitly for CPU execution rather than GPU acceleration. It uses a fully connected, shallow neural network, optimized for rapid, low-precision inference, which enables the network to update evaluations incrementally after each move, rather than recalculating from scratch. @Nasu2018NNUE

A distinctive component of NNUE is its, difference based mechanism, where the system maintains an accumulator. When a piece moves, only the relevant features, encoded through HalfKP (depending on the version) relationships, are updated. This allows near instantaneous position evaluation. Furthermore, quantization of weights and activations into integer domains (often 8–16 bits) allows the network to leverage SIMD instructions for better speed on standard CPUs.

NNUE's introduction bridged the gap between hand engineered heuristics (HCE) and learned evaluation. It's implementation into major engines such as Stockfish and Komodo Dragon resulted in strength gains exceeding 100 Elo, demonstrating that lightweight neural architectures can coexist with traditional search algorithms without the computational demands of deep learning frameworks. @Stockfish2025NNUEWiki @Nasu2018NNUE.

=== Architecture

#figure(
  image("images/NNUE.jpg"),
  caption: "NNUE Stockfish Architecture",
)

The NNUE architecture consists of four layers designed for efficient evaluation of positions. Unlike traditional deep neural networks used in other chess engines like Leela Chess Zero, NNUE's design prioritizes incremental updates during alpha-beta search, making it computationally efficient enough to maintain high search speeds.

=== Input Layer and Feature Transformer

The input layer uses a sparse binary representation called HalfKP (or HalfKAv2 in modern versions), where features represent the presence of specific pieces on specific squares relative to each king's position. The network processes two "halves" simultaneously, one for each king, with each half containing information about all pieces on the board relative to that king's position.

In the original HalfKP architecture, each half receives 41,024 binary inputs (64 king positions × 641 inputs per position), where each input indicates whether a particular piece occupies a particular square or not. These inputs connect to a 256 neuron hidden layer per half, resulting in over 10 million weights in this feature transformer. This massive overparameterization allows the network to learn complex patterns.

The modern HalfKAv2 architecture improves upon this by using 45,056 inputs per side (11 piece types × 64 squares × 64 king positions) mapped to a 512 neuron feature transformer per side. This version eliminates redundancy by considering that the king's own square doesn't need to be encoded as a separate feature.

=== The Accumulator

The cornerstone of enabling NNUE's efficiency is the accumulator mechanism. Rather than re-calculating the entire feature transformer output for each position during search, the engine maintains an accumulator. When a piece moves, only the weights corresponding to the moved piece need updating:

- Subtract the weights for the piece's old square
- Add the weights for the piece's new square

This transforms what would be an O(n) operation (processing all active features) into an O(1) operation (updating only changed features). During alpha-beta search, where the engine evaluates millions of positions per second, this incremental update provides massive computational savings. For example,

```
move(piece from A to B):
  accumulator -= weights[piece][A]  // remove old position
  accumulator += weights[piece][B]  // add new position
```

=== Hidden Layers

After the feature transformer, the network passes through three smaller fully-connected layers:
- First hidden layer: 512 inputs → 32 outputs
- Second hidden layer: 32 inputs → 32 outputs
- Output layer: 32 inputs → 1 output (evaluation score)

These layers use ClippedReLU activation functions, which clip values to a $[0,127]$ range. The smaller size of these layers means they contribute minimal computational cost compared to the feature transformer.

=== Quantization for Speed
All network weights and intermediate values use quantized integer arithmetic rather than floating point calculations. The feature transformer uses 16 bit integers, while subsequent layers use 8 bit integers. This quantization enables efficient SIMD  operations using CPU instructions like AVX2, processing multiple values simultaneously.

=== NNUE's Architectural Constraints and Research Gaps
NNUE's architecture is fundamentally defined to provide fast evaluation within the tight performance loop of a high speed, single-threaded alpha-beta search engine @Stockfish2025NNUEWiki @Nasu2018NNUE. A quantitative gap exists in optimizing NNUE: developing superior feature sets other than HalfKP / HalfKAv2 and refining the quantization and layer structure to achieve greater accuracy without sacrificing the speed @Stockfish2025NNUEWiki. Additionally, sophisticated methods for automatically tuning complex sets of handcrafted heuristics (like advanced Texel tuning approaches) are still needed to close the gap between man made and machine learned evaluations further @bijl_2021_exploring[p.17].

== The State Of Neural Network Based Engines

Neural network evaluation architecture changes drastically based on whether it targets traditional CPU-bound search or selective MCTs systems. NNUE is optimized for CPU based low-latency with alpha-beta's, aiming for exhaustive search @Stockfish2025NNUEWiki @Nasu2018NNUE, while AlphaZero's CNNs are better suited for GPU/TPU acceleration and batch processing in MCTs @mastering.

The integration of NNUE into Stockfish demonstrates a hybrid approach rather than complete replacement of alpha-beta search for future engines. Given that engines must maintain compatibility with consumer hardware, NNUE is often preferred despite MCTs potentially offering stronger evaluation @Stockfish2025NNUEWiki.

Be that as it may, a core research gap remains in quantifying performance comparisons between highly optimized alpha beta engines with neural evaluations (like Stockfish/NNUE) versus pure neural network-guided MCTs systems, especially under varying time controls and hardware constraints.

#pagebreak()

= System Analysis & Architecture Patterns
This section examines two chess engines, namely Stockfish and LC0 to examine how they translate the theoretical technique into working systems. These 2 engines were chosen because they effectively encapsualte all major techniques in chess programming:

== The Classical Paradigm: Alpha-Beta + HCE
The classical approach dominated the field of chess programming from the 1960s  until around 2017. This paradigm was fundamentally relied on exhaustive search to a fixed depth, and accelerated by alpha-beta pruning. It was guided by hand-crafted evaluation functions that were founded on the human chess principles. Engines like pre-2020 Stockfish were a testimant to this approach, acheiving very strong playing strength through years of incrementally refined heuristics and search optimizations.

Stockfish, first released in 2008 as a fork of Glaurung, became the world's strongest chess engine through years of tedious, relentless optimization of the classical alpha-beta paradigm. Before the integration of NNUE in 2020, Stockfish represented the pinnacle of hand-crafted evalaution and highlighy optimized search functions

The pre-NNUE Stockfish architecture consisted of several tightly coupled components, designed for maximum effeciency. The section below explores the architectural choices made int he development of Stockfish:

==== BitBoard + Mailbox Hybrid Representation
===== The Problem
BitBoards are proven to be excellent at bulk operations and enable computing attacks with the help of magic BitBoards or PEXT boards, but they are inefficient for random access queries of piece and type occupancy on the board.

===== The Solution
Thus, Stockfish maintains both the BitBoard and mailbox representations together to counter BitBoard's limitation. Stockfish maintained 12 different BitBoards, one for each piece type and color for effecient move generation and evaluation, and a 64-element array to provide `O(1)` piece lookups.

===== Tradeoffs
- *Memory Cost:* Approximately 2x representation overhead (12 BitBoards + 64-byte mailbox + auxiliary data). The board can be represented with just 8 BitBoards without the mailbox.
- *Synchronization Cost:* Every move must update both representations
- *Speed Gain:* Move generation benefits from BitBoard operations (no need to filter piece type with white_pieces & rooks or black_pieces & rooks) while evaluation benefits from mailbox lookups

Move generation uses BitBoards with Magic BitBoards for sliding pieces, achieving constant-time lookup. Evaluation functions query the mailbox for piece-square table indexing. The hybrid approach enables both components to operate at peak efficiency rather than compromising one for the other.
==== Move Generation

===== The Problem
Stockfish uses precomputed BitBoards for non-sliding pieces, but generating moves for sliding pieces (bishops, rooks, queens) requires determining which squares are attacked based on the blocker configuration. This is computationally intensive and occurs millions of times per second.

===== The Solution
Stockfish implements both, Magic BitBoards and PEXT Boards to acheive constant-time generation of moves for sliding-pieces. It selects between them at compile-time based on the CPU's capabilities.

===== Tradeoffs
- *PEXT Benefits:* Simpler code (no magic number generation), slightly faster (2.3% speedup) @hash_funtions[p.10]
- *PEXT Costs:* Requires Haswell+ (Intel 2013) or Zen+ (AMD 2018) CPUs; some AMD processors have slow PEXT implementation
- *Magic BitBoards Benefits:* Universal compatibility, predictable performance
- *Magic BitBoards Costs:* Complex initialization (finding magic numbers), more code complexity

By maintaining both implementations, Stockfish achieves maximum performance on modern hardware while remaining functional on older systems. The compile-time detection ensures zero runtime overhead from abstraction.

==== Lazy SMP for Parallelization
Stockfish originally used Young Brothers Wait Concept (YBWC) for parallel search, but later #link("https://github.com/official-Stockfish/Stockfish/commit/ecc5ff6693f116f4a8ae5f5080252f29b279c0a1")[switched to Lazy SMP] noting that it scales better than YBWC for high number of threads.

===== Trade-offs
- *Redundant Work:* Threads inevitably search some identical positions
- *Implementation Simplicity:* No complex synchronization logic, no thread coordination overhead
- *Scalability:* Near-linear speedup up to 8-16 cores, diminishing returns beyond

===== Why YBWC "failed"
Although no official explaination, the theoretical advantage of coordinated search was likely negated by:
- Mutex contention on shared data structures
- Thread creation/destruction overhead
- Complexity in managing thread pools and work queues
- Helper threads idling while waiting for principal variation

==== Move Ordering Heuristics

===== The problem
It is established that Alpha-beta pruning's effectiveness depends critically on move ordering. Searching good moves first enables earlier cutoffs, potentially reducing the effective branching factor from 35 to under 6 in well-ordered trees.
===== The Solution
Stockfish implements a sophisticated multi-tiered move ordering system:
1. *Transposition Table Move* (highest priority): If the position has been searched before, try that move first
2. *Winning Captures* (MVV-LVA): Captures that win material, ordered by victim value minus aggressor value
3. *Killer Moves* (two per ply): Non-captures that caused cutoffs in sibling positions
4. *Counter Moves*: Moves that historically refuted the opponent's last move
5. *History Heuristic*: Global statistics on which moves tend to cause cutoffs
6. *Losing Captures*: Captures that lose material, searched last

===== Trade-offs:
- *Complexity:* Maintaining multiple overlapping heuristics increases code complexity
- *Memory:* History and killer tables consume additional RAM
- *Computation:* Move ordering itself takes time; as such it must be faster than searching misordered moves to make it a positive trade.

==== Strength:
- Estimated Elo: ~3450-3480 (depending on hardware and time controls)
- Approximately 800 Elo above the best human players
- Dominant in computer chess championships (TCEC, CCC)

==== Limitations
Despite it's dominance, Stockfish had one major fundamental constraint,it's understanding of a chess position, is ultimately constrainted by the extent to which humans could model their intuition.

The handcrafted evaluation function, despite decades of refinement, was still fundamentally bounded by human understanding. Complex positional factors like long term piece coordination and king safety nuances in unusual positions were difficult to model in explicit heuristics. This limitation paved the way for the next generation of chess engines, ones powered by neural networks.


== Neural Network Based: MCTs + Deep-Learning

December 2017 marked a paradigm shift in the world of chess programming. AlphaZero, having learned the rules of chess through self-play over four hours, played 100 games against Stockfish, the strongest engine at that time. The results were remarkable: AlphaZero won 28 games, drew 72, and lost none.

Neural network-based engines like AlphaZero employ Monte Carlo Tree Search which is guided by deep neural networks that are trained through self-play. This approach sacrifices speed, examining 80,000 positions per second compared to Stockfish's 70 million @mastering[p.4], in favor of evaluation accuracy and selectivity. This architecture is fundamentally dependent on GPU acceleration for neural network inference and represents a completely different philosophy than exhaustive search: search the most promising positions accurately rather than all positions efficiently.

Leela Chess Zero emerged as the open-source implementation of this paradigm, enabling the broader chess programming community to experiment with neural MCTs approaches without the computational resources of DeepMind.

=== Case Study: Leela Chess Zero (LC0)

Leela Chess Zero, launched in 2018 as an open-source reimplementation of AlphaZero's approach, represents the neural network paradigm in chess programming. Unlike Stockfish's hand-crafted evaluation, LC0 learns position evaluation entirely through self-play, combining Monte Carlo Tree Search with deep neural networks trained via reinforcement learning.

The LC0 architecture fundamentally inverts the classical approach: instead of fast, shallow evaluation of millions of positions, it performs slow, deep evaluation of thousands of carefully selected positions. This section examines the architectural decisions that enable this paradigm shift.

==== Neural Network Architecture

===== The Problem
Traditional hand-crafted evaluation functions have a difficult time trying to capture the non-linear patterns that come with chess positions. Engines like Stockfish were seeing diminishing returns from their refinements because there is simply so much nuance that we can explicitly model in hand-crafted evaluation functions. This limitation made it so that traditional approaches struggled with long-term positional understanding and subtle tactical nuances that go beyond simple material or mobility metrics.

===== The Solution
LC0 and AlphaZero employ a deep residual convolutional neural network (ResNet) architecture, typically with 15-40 residual blocks. This neural network takes the board state as input (encoded in multiple planes representing piece positions, castling rights, en-passant, etc.) and outputs two values:
- *Policy Head:* A probability distribution over all legal moves
- *Value Head:* A win/draw/loss evaluation of the position

===== The Trade-offs
- *Training Costs:* This shoots up compared to traditional approaches. As these models require millions of self-play games and explicitly require GPUs to do so, these models aren't really viable for the average user.
- *Inference Speed:* These models by their nature sacrifice the number of positions evaluated in favor of accuracy and selectivity, often evaluating hundreds of times fewer positions than their traditional counterpart.
- *Evaluation Quality:* It balances out the low number of positions analyzed by learning subtle patterns over its self-play phase, which allows it to select the most promising lines and see qualities beyond what humans have explicitly modeled in their hand-crafted heuristics.
- *Hardware Dependency:* Requires GPU for competitive performance; CPU-only inference is prohibitively slow.

The network's depth allows it to find patterns in pawn structures, piece coordination, and king safety through entirely learned features rather than programmed rules.

==== Monte Carlo Tree Search (MCTs)

===== The Problem
Traditional alpha-beta search assumes that each chess position can be accurately evaluated in isolation. However, positions in chess are often too complex for immediate evaluation, and the true value only emerges after exploring possible continuations. Although traditional architectures have also acknowledged this and attempt to counter this using techniques like quiescence search, MCTs takes a fundamentally different approach.

===== The Solution
LC0 implements a neural network-guided MCTs using the PUCT (Predictor + Upper Confidence Bounds for Trees) algorithm. Instead of random or exhaustive play, each node expansion consists of:
1. Querying the neural network for policy (move probabilities) and value (position evaluation)
2. Selecting moves to explore based on: Q(s,a) + U(s,a), where U balances exploitation and exploration
3. Back propagating the neural network's evaluation up the tree

===== Tradeoffs
- *Selectivity vs. Coverage:* MCTs explores promising variations deeply rather than all variations uniformly
- *Uncertainty Handling:* Visit count-based exploration ensures under-evaluated moves get reconsidered
- *Time Distribution:* Spends more time on critical positions, less on trivial ones
- *Search Instability:* Early search can dramatically shift as new variations are explored

This approach allows MCTs to explore promising lines deeply rather than every line uniformly, growing the tree asymmetrically. Unlike alpha-beta's deterministic best-first search, MCTs is inherently a probabilistic model. It gradually converges toward optimal play but initially explores suboptimal branches. This makes its play style appear "human-like" initially while finding "unconventional" moves that prove to be extremely strong several moves later.

==== Virtual Loss for Parallelization

===== The Problem
MCTs parallelization is challenging because multiple threads selecting moves simultaneously can all choose the same promising node, leading to redundant exploration and wasted computation.

===== The Solution
LC0 implements virtual loss: when a thread selects a node for exploration, it temporarily decreases that node's value as if it had lost. This discourages other threads from immediately exploring the same line. Once the neural network evaluation returns, the virtual loss is removed and replaced with the actual evaluation.

===== Tradeoffs
- *Exploration Diversity:* Threads naturally spread across different promising branches
- *Overhead:* Atomic operations required for thread-safe virtual loss updates
- *Tuning Sensitivity:* Virtual loss magnitude affects search behavior; too high causes over-diversification, too low causes redundant work
- *Batch Efficiency:* Enables gathering multiple positions for GPU batch inference, dramatically improving throughput

Virtual loss enables near-linear scaling up to 8-16 threads with a single GPU, with each thread exploring different variations. Combined with batched neural network inference (processing 256+ positions simultaneously), this achieves efficient GPU utilization.

==== Training via Self-Play

===== The Problem
Supervised learning from human games would limit the engine to human-level understanding. To surpass human play, the engine must discover novel strategies through exploration.

===== The Solution
LC0 trains exclusively through self-play reinforcement learning:
1. Generate games using the current network with added exploration noise
2. Store positions, move probabilities, and game outcomes
3. Train the network to predict both the move probabilities (policy target) and game result (value target)
4. Deploy the improved network and repeat

===== Tradeoffs
- *Computational Cost:* Requires distributed infrastructure; LC0's training involved thousands of volunteers contributing GPU time
- *Training Stability:* Networks can plateau or even regress; requires careful hyperparameter tuning and network evaluation
- *Data Efficiency:* Learns from scratch without human knowledge, but requires millions of games to reach competitive strength
- *Emergent Understanding:* Discovers opening theory, endgame techniques, and tactical patterns independently

The distributed nature of LC0's training, with volunteers worldwide contributing self-play games, demonstrates both the power and challenge of this approach. Early networks (first few thousand games) play poorly, but strength improves dramatically as patterns emerge from accumulated experience.

==== Strength
- Estimated Elo: ~3500-3550 (with large networks on strong GPUs)
- Approximately 50-100 Elo stronger than pre-NNUE Stockfish
- Playing style characterized by deep positional understanding and long-term planning
- Particularly strong in complex middle-games and closed positions

==== Limitations
Despite its strength, LC0/AlphaZero has several constraints:

*Computational Requirements:* Due to their intrinsic model, these types of engines require high-end GPUs, making them inaccessible to many users. CPU-only inference is orders of magnitude slower.

*Tactical Blindness:* The probabilistic nature of MCTs occasionally misses forcing tactical sequences that alpha-beta would find instantly through exhaustive search. LC0 can overlook short, critical variations if they initially appear unpromising.

*Opening Book Dependency:* As these models converge, the early networks can struggle in sharp opening lines, requiring curated opening books to compensate and compete in tournaments.

*Time Management:* MCTs's gradual convergence makes it perform relatively worse in fast time controls where immediate evaluation is beneficial rather than deep exploration.

*Explainability:* The neural network's decision-making is opaque; unlike Stockfish's explicit evaluation terms, LC0 cannot explain why it prefers one move over another in human-understandable terms.

These limitations highlight the complementary nature of the two paradigms: neural MCTs excels at strategic understanding and pattern recognition, while alpha-beta excels at tactical calculation and computational efficiency. This realization led to the next evolution in chess programming, and the current state of the art: a hybrid approach.

== Hybrid Approach
August of 2020 represents another paradigm shift, as it was the date when Stockfish officially integrated Efficiently Updatable Neural Networks (NNUE). This represented a combination of both traditional and neural network approaches, combining the computational efficiency of alpha-beta search with the pattern recognition capability of neural networks.  This hybrid allowed Stockfish to see a dramatic strength gain of ~100 Elo over it's previous implementation; the biggest jump it had seen in a long time.

Originally developed by Yu Nasu in 2018 specifically to counter the limitations of the previous approaches in the game of Shogi, for the engine #link("https://github.com/yaneurao/YaneuraOu")[YaneuraOu]. Unlike LeelaChess's ( LC0 ) and likewise AlphaZero's dependent on deep neural networks, NNUE uses a shallow but highly optimized architecture for CPU inference, and unlike the traditional hand crafted evaluation, it learns the evaluation through supervised learning from billions of positions. This results in an engine that searches with alpha-beta but evaluates with neural networks.

==== NNUE Origination

===== The Problem

Deep neural networks, although powerful, require GPU acceleration and evaluate a significantly lower number of positions. Classical engines evaluate millions of positions but are limited by their hand-crafted evaluation functions. The challenge thus was to create a neural network architecture that could run efficiently on CPUs while providing the superior evaluation metrics.

===== The Solution
The critical innovation of NNUE is incrementally updated accumulators. The NNUE network typically consists of:
- Input Layer: 40,960 features (piece+square combinations)
- Hidden Layer: 256-1024 neurons with ClippedReLU activation
- Output Layers: Two small layers producing a single evaluation score

But, instead of recomputing the entire network for each position, NNUE maintains an "accumulator" that tracks the hidden layer's state. As such, when a move is made, only the features affected by said move are updated, reducing the evaluation cost.

===== The Tradeoffs
- Evaluation Speed: ~10-100x slower than hand-crafted evaluation, but 100-1000x faster than GPU-based deep networks
- Search Depth: Reduced by 1-2 plies compared to classical Stockfish due to slower evaluation, but has better position understanding
- Memory Footprint: Network weights (~20-50MB) are small enough to fit in CPU cache
- Training Requirements: Requires hundreds of billions of training positions, but training is one-time and can be done offline. Furthermore, implementation is simpler because these trained networks are available online, for anyone on sites like: #link("https://tests.Stockfishchess.org/nns")[Stockfish's FishTest]

==== Quantization and Optimization
===== The Problem
Even with incremental updates, NNUE evaluation consumes significant CPU time. Further optimization was needed to maintain competitive search speeds.
===== The Solution
The solution to this for Stockfish was to implement aggressive quantization and CPU-specific optimizations:

- 8-bit Integer Quantization: Network weights and activations use 8-bit integers instead of 32-bit floats
- SIMD Vectorization: AVX2/AVX-512 instructions process 16-32 neurons simultaneously
- Weight Permutation: Network weights are reordered in memory to optimize cache access patterns
- Sparse Input Optimization: Most input features are zero (only ~30 active pieces); computation skips zero inputs

===== Tradeoffs

- Accuracy Loss: Quantization introduces small evaluation errors (~5-10 Elo), but the speed gain is worth it
- Portability: Optimizations are CPU-specific; different binaries for different architectures
- Complexity: Low-level optimization code is difficult to maintain and debug
- Speed Gain: Combined optimizations achieve ~3-5x speedup over naive implementation

Modern Stockfish evaluates ~1-5 million positions per second with NNUE on high-end CPUs, compared to 50-70 million with classical evaluation. The 10-20x slowdown is acceptable because NNUE's superior evaluation quality means fewer positions need to be searched for the same playing strength.

==== Strength and Impact
===== Current Performance

- Estimated Elo: ~3600-3650 (depending on hardware and time controls)
- Improvement: ~150-200 Elo stronger than pre-NNUE Stockfish
- Comparison to LC0: Roughly equal strength, with different stylistic characteristics
- Dominance: Won TCEC Season 19 (November 2020) and has remained dominant in classical time controls

==== The State of the art
The NNUE integration succeeded where previous neural network attempts failed because it respected the constraints of CPU-based alpha-beta search:

- Computational Efficiency: The shallow architecture and incremental updates keep evaluation fast enough for deep search. NNUE evaluates positions 100-1000x faster than LC0's deep networks while being only 10-20x slower than classical evaluation.

- Training Efficiency: Supervised learning from engine positions converges in days rather than months, making iterative improvement practical. The community can experiment with new architectures and training techniques without requiring massive computational resources.

- Incremental Adoption: Stockfish could integrate NNUE while preserving its existing search infrastructure, minimizing risk. The classical evaluation function remains as a fallback, and search tuning could be done gradually.

- Hardware Accessibility: CPU-only execution means NNUE runs on commodity hardware, unlike LC0 which requires GPUs for competitive performance. This democratizes access to top-level chess engines.

==== Limitations and Future Directions
Despite its success, NNUE-based engines have limitations:
- Evaluation Speed: Still 10-20x slower than classical evaluation, limiting search depth in very fast time controls (bullet, ultrabullet). In extremely short time controls, the depth loss outweighs evaluation quality gains.

- Architecture Constraints: The shallow network architecture may be approaching its strength ceiling. Deeper networks would provide better evaluation but sacrifice too much speed. Research continues on architectures that balance depth and efficiency.

- Training Data Quality: NNUE's strength depends on training data quality. Biased or low-quality training positions can introduce weaknesses. Generating high-quality training data remains an active research area.

- Interpretability: Like all neural networks, NNUE's decisions are opaque. Unlike classical evaluation's explicit piece-square tables and mobility terms, NNUE cannot explain its evaluation.

- Hardware Dependency: Peak performance requires modern CPUs with AVX2/AVX-512 support. Older hardware sees smaller improvements, creating a performance gap between hardware generations.

= The Current State of Chess Programming
The hybrid approach has become the dominant paradigm in chess programming as of 2025:

- Stockfish: Remains the strongest CPU-based engine, continuously improving through better NNUE architectures and training
- LC0: Continues development with larger networks and improved MCTs algorithms, especially strong on GPUs
- Other Engines: Dragon, Berserk, Koivisto, and others have adopted NNUE-like approaches
- Convergence: Top engines are within 50-100 Elo of each other, with stylistic differences rather than clear strength hierarchies

The success of NNUE demonstrates that the future of chess programming likely lies not in purely classical or purely neural approaches, but in carefully designed hybrids that leverage the strengths of both paradigms. Alpha-beta search computational efficiency, while neural networks provide positional understanding and pattern recognition. Together, they have pushed chess engine strength to levels that would have seemed impossible just a decade ago.

#pagebreak()

#bibliography("refs.bib", style: "harvard-cite-them-right")
