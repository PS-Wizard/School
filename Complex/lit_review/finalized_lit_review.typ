#import "layout.typ": *;
#show: academic-theme.with(
  title: "Efficiency vs Generality: Analyzing the Trade-offs Between NNUE and AlphaZero-like Deep Networks",
  author: "Swoyam Pokharel",
  student-number: 2431342,
  tutor: "Jeshmi Rajak",

  abstract: [
    #lorem(50)
  ],
)
#pagebreak()


= Introduction
==== Context
Chess has long served as a benchmark for the field of artificial intelligence, from Shannon's early works establishing chess as a computational problem to Deep Blue's victory in 1997. The use of artificial intelligence in the game of chess has come a long way, and after 2017 we began to see a significant paradigm shift when AlphaZero demonstrated that neural networks trained with just self-play could defeat classical engines like Stockfish. However, with the integration of NNUE (Efficiently Updatable Neural Networks) in Stockfish since 2020, traditional exhaustive search-based engines reclaimed dominance while still maintaining CPU efficiency. Thus, today's chess AI is defined by two competing philosophies: domain-optimized efficiency versus general-purpose learning.
==== The Efficiency vs. Generality Debate
NNUE-based architectures achieve fast evaluation through small networks and incremental updates, allowing them to run efficiently on consumer hardware. In contrast, AlphaZero-styled systems use deep neural networks with Monte Carlo Tree Search (MCTS), inherently requiring massive computational resources. However, their architectural differences come with different behaviors. Stockfish (NNUE) can search millions of positions per second on a CPU, while LCZero (LeelaChessZero; an open-sourced AlphaZero-like engine) evaluates mere thousands but with deeper "understanding."

NNUE optimizes specifically for chess through handcrafted input features and efficient update mechanisms, while AlphaZero/LCZero-style systems learn entirely from self-play through domain-agnostic neural architectures. This choice bleeds into trade-offs on playing strength, computational accessibility, and interpretability that extend beyond chess. Are systems better off being tailored to specific problems with domain knowledge and optimizations, or should they be agnostic, learning via general principles from scratch that transfer across domains?
==== Aims & Objectives
This review aims to analyze the trade-offs between NNUE and AlphaZero-like architectures across the three sectors: performance, computational efficiency, and interpretability using recent comparative studies and implementation papers. This topic was chosen to inform the architectural decisions for a custom chess engine built in Rust, currently under development as a final year project.


#pagebreak()
= Literature Review
== Chess AI: Competing Paradigms for Machine Intelligence @competing_paradigms_for_machine_intelligence
==== Methodology
Maharaj et al. conducted an experimental comparison between Stockfish 14 (alpha-beta search) and Leela Chess Zero network 609950 (neural MCTS) using Plaskett's Puzzle @competing_paradigms_for_machine_intelligence[p. 2], a famous endgame study requiring 15-move depth and a counterintuitive underpromotion. The engines were tested over five trials to account for multithreading randomness, with results averaged to ensure reliability @competing_paradigms_for_machine_intelligence[p. 6].

==== Findings
Their findings show that Stockfish successfully solved the corrected puzzle at a depth of 40, correctly identifying a forced mate in 29 half-moves @competing_paradigms_for_machine_intelligence[p. 8]. However, LCZero failed to find the solution even after analyzing 60 million nodes @competing_paradigms_for_machine_intelligence[p. 8]. They found that a surprising 92.4% of LCZero's search nodes followed an inferior move because its policy head assigned it 15.75% probability compared to only 7.40% for the winning move @competing_paradigms_for_machine_intelligence[pp. 8-9]. Their experiment gave LCZero 34 times more computational power than Stockfish relative to standard tournament ratios, yet it still failed the puzzle @competing_paradigms_for_machine_intelligence[p. 9].

Stockfish reached $1.5 times 10^8$ nodes per second while LCZero reached only $1.4 times 10^5$ nps @competing_paradigms_for_machine_intelligence[p. 9]. However, when given the first move, LCZero found the mate after 5.5 million nodes while Stockfish required 500 million nodes, showing LCZero's efficiency when its intuition is correct @competing_paradigms_for_machine_intelligence[p. 9]. This paper effectively highlights a fundamental trade-off in chess AI design: NNUE-based engines like Stockfish are better at tactical calculation, making them effective for edge cases. AlphaZero-style systems like LCZero rely on pattern matching, which is more generalizable across other games like shogi and Go, but fail at edge cases when the policy network misjudges position complexity @competing_paradigms_for_machine_intelligence[p. 10].

==== Takeaway
Ultimately, Maharaj et al. conclude that Stockfish solves the puzzle with much greater efficiency than LCZero @competing_paradigms_for_machine_intelligence[p. 1].

#pagebreak()

== Stockfish or Leela Chess Zero? A Comparison Against Endgame Tablebases @sadmine2023stockfish
==== Methodology

Sadmine et al. conducted an analysis comparing Stockfish 15.1 and LC0 0.29.0 (both rated at 2850 Elo) against perfect play defined by Syzygy endgame tablebases @sadmine2023stockfish[p.2] @sadmine2023stockfish[p.4] . The study evaluated engine moves across 3-piece, 4-piece, and 5-piece endgames, measuring errors as game-theoretic outcome changes (win to draw, draw to loss, etc.) @sadmine2023stockfish[p.4]. Tests were primarily conducted on raw policy networks without search to isolate learning ability, though performance with a small search budget of 400 nodes was also examined @sadmine2023stockfish[p.7].

==== Finding
Their findings reveal Stockfish's policy is superior in 3-piece endgames, demonstrating stronger tactical calculation in simpler positions @sadmine2023stockfish[p.9]. However, LCZero produced fewer mistakes in most 4-piece endgames, with LC0 making 1.32% errors in winning positions compared to Stockfish's 1.47% @sadmine2023stockfish[p.4].

The study found that predicting wins is easier for Stockfish, whereas predicting draws is easier for LC0, with LC0 performing better in drawing positions across nearly all 4-piece tablebases  @sadmine2023stockfish[p.9]. They also found that, when LC0 makes a mistake, its evaluation of the position remains more accurate (further from zero in centipawns) than Stockfish's, suggesting a better understanding of positional nuance even when choosing non optimal moves  @sadmine2023stockfish[p.5]. The authors also analyzed specific scenarios such as when the opponent's last pawn is under attack, finding that LCZero made fewer mistakes than Stockfish in these complex tactical-positional situations @sadmine2023stockfish[p.9].

==== Takeaway
This paper demonstrates that the efficiency versus generality trade-off is more pronounced in certain game phases: NNUE-based engines excel at simpler tactical endgames through exhaustive calculation, while AlphaZero-style systems show superior positional "feel" in complex, endgames.

#pagebreak()

== Neural Networks for Chess @neural_network-for_chess
==== Methodology
Klein provides a comprehensive analysis and review of chess AI evolution, combining technical explanations with a practical implementation of a simplified "HexapawnZero" engine @neural_network-for_chess[p.18]. The book examines multiple architectures including Stockfish NNUE, AlphaZero, Leela Chess Zero, and Maia, transitioning from classical alpha-beta search with handcrafted evaluation functions to neural network based systems.

==== Findings

Klein documents that AlphaZero, using 19-39 residual blocks and trained on 48 TPUs, reached a peak rating of 5185 Elo by learning entirely through self-play reinforcement learning @neural_network-for_chess[p.162]. Whereas, NNUE's integration into Stockfish 12 added approximately 80 Elo points while maintaining CPU efficiency through 8-bit integer mathematics and SIMD instructions like `VPADDW` and `VPSUBW` @neural_network-for_chess[p.193, p.194, p.209]. The HalfKP input representation uses 81,920 bits to enable incremental updates, recomputing only the difference when pieces move rather than the entire network @neural_network-for_chess[p.197, p.209]. This allows NNUE to maintain search speeds of 4.6 million nodes per second compared to Stockfish 8's 7.5 million nps, while AlphaZero operates at only 80,000 nps @neural_network-for_chess[p.212, p.193].

Klein also discusses Maia, a human centric engine trained on 12 million Lichess games that achieves over 50% move-matching accuracy for 1100-rated players compared to Stockfish's 35%, demonstrating that supervised learning from human games excels at mimicking human play while reinforcement learning achieves superhuman strength @neural_network-for_chess[p.222]. The book emphasizes that neural networks perform poorly on data completely out of their training domain, highlighting a key limitation of learned systems. @neural_network-for_chess[p.47]

==== Takeaway
Klein's analysis shows that the choice between NNUE and AlphaZero boils down to what you optimize for. NNUE is built for efficiency, using chess-specific tricks to run fast on regular hardware. AlphaZero goes for generality, using the same approach for Chess, Shogi, and Go, but needs massive resources (48 TPUs) to train @neural_network-for_chess[p.160].

#pagebreak()

== Chess Engine Inspired by AlphaZero @krakovsky_chess_engine

==== Methodology
Krakovsk#sym.acute("y") and Liberda attempted to build a self-play reinforcement learning chess engine using Python, python-chess, and PyTorch @krakovsky_chess_engine[p.4]. Their implementation used a 2-layer residual blocks; which, for reference, AlphaZero used 19-blocks @krakovsky_chess_engine[p.4]. Their study aimed to replicate the AlphaZero methodology at a smaller scale to understand the practical challenges of implementing such systems.

==== Findings
Their findings reveal the computational gap between theory and practice. The engine only played 1,200 games over 1 GPU-hour, compared to AlphaZero's 44 million games over 41 TPU-years @krakovsky_chess_engine[p.7]. Their implementation faced big performance bottlenecks, with 40-50% of runtime spent in MCTS calculations due to Python object conversions @krakovsky_chess_engine[p.7]. GPU speedup was only 2x over CPU because of a lack of inference batching, and reaching AlphaZero's scale in this Python environment would take approximately 510 days @krakovsky_chess_engine[p.8, p.9].

The engine reliably learned to draw but failed to learn how to win, with the model preferring draws by repetition or the 50-move rule @krakovsky_chess_engine[p.10]. The authors note that insufficient compute resources and the choice of Python as an implementation language severely limited progress, suggesting that C++ or Rust would be necessary for efficient search and simulation @krakovsky_chess_engine[p.10].

==== Takeaway
This paper demonstrates the extreme accessibility barrier of the AlphaZero paradigm. While the approach allows generality, the computational requirements place it far beyond the reach of individual developers or small teams. The 510 day training estimate highlights that the benefit of generality comes at a big cost, making AlphaZero-style systems practical only for organizations with massive computational resources.

#pagebreak()

== Implementing the Chess Engine using NNUE with Nega-Max Algorithm @implemeting_chess_engine_using_nnue_with_negamax_algorithm
==== Methodology
Chitale et al. conducted an implementation and comparison using a custom engine called "Stockdory," which integrated NNUE with the Nega-Max algorithm @implemeting_chess_engine_using_nnue_with_negamax_algorithm[p.2]. The study compared Stockdory against Stockfish by analyzing two historical games: Bogoljubov vs Alekhine (1922) and Lasker vs Bauer (1889) @implemeting_chess_engine_using_nnue_with_negamax_algorithm[p.4]. 

==== Findings
Their findings reveal performance gaps between the custom implementation and mature engines. In the 1922 positional game, Stockfish achieved 80.19% accuracy in matching game moves, while Stockdory achieved only 45.28% @implemeting_chess_engine_using_nnue_with_negamax_algorithm[p.4]. Stockfish also evaluated this game faster, completing analysis in 6 minutes and 50 seconds compared to Stockdory's 9 minutes and 3 seconds @implemeting_chess_engine_using_nnue_with_negamax_algorithm[p.4]. However, in the 1889 psychological game featuring Lasker's counterintuitive style, Stockdory slightly outperformed Stockfish, matching 52% of moves compared to Stockfish's 48%, and completed evaluation in 6 minutes and 28 seconds versus Stockfish's 7 minutes and 5 seconds @implemeting_chess_engine_using_nnue_with_negamax_algorithm[p.5].

==== Takeaway
This paper illustrates the accessibility advantage of NNUE-based architectures. While Stockdory didn't reach the same level of performance as Stockfish, the authors did not mention computational barriers or scalability issues during implementation. This implies the relative ease and accessibility of building a functional NNUE based engine, and also proves how domain-optimized efficiency translates into allowing individuals and small teams to use NNUE. 

#pagebreak()
// Point for synthesis: This differs very much with Krakovský's experience, where Python bottlenecks and a 510-day training estimate made AlphaZero replication impractical. 
//

== Explaining Intelligent Game-Playing Agents @explaining_intelligent_game_playing_agents
==== Methodology
#lorem(50)
==== Findings
#lorem(50)
==== Takeaway
#lorem(50)

== Chess and Explainable AI
==== Methodology
#lorem(50)
==== Findings
#lorem(50)
==== Takeaway
#lorem(50)

#pagebreak()
#bibliography("refs.bib", style: "./harvard-anglia-ruskin-university.csl")


