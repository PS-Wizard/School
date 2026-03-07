#set page(
  paper: "a4",
  margin: (x: 16mm, y: 12mm),
  fill: rgb("ececec"),
)

#let heading-font = ("New Computer Modern", "Libertinus Serif", "FreeSans")
#set text(font: heading-font, size: 8.9pt)
#set par(justify: false, leading: 1.06em)

#let line-color = black
#let section-blue = rgb("c4d2e4")

#align(center)[
  #block(width: 182mm)[
    #table(
      columns: (1fr, 1.8fr, 1fr, 1.8fr),
      stroke: 0.8pt + line-color,
      inset: (x: 4pt, y: 2pt),
      align: left,
      fill: (x, y) => if y == 0 { section-blue } else { none },

      table.cell(colspan: 4, align: center + horizon, inset: (x: 0pt, y: 4pt))[#strong("PROJECT MANAGEMENT LOG")],
      [#strong("First Name:")], [Swoyam], [#strong("Surname:")], [Pokharel],
      [#strong("Student Number:")], [2431342], [#strong("Supervisor:")], [Prakriti Regmi],
      [#strong("Project Title:")], [Oops!Mate.], [#strong("Month:")], [September 2025],
    )
    #table(
      columns: (1fr,),
      stroke: 0.8pt + line-color,
      inset: 0pt,
      align: (x, y) => if calc.even(y) { center + horizon } else { left + top },
      fill: (x, y) => if calc.even(y) { section-blue } else { none },

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What have you done since the last meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 76mm)[
        - Bootstrapped the workspace and initialized the board crate.\
        - Introduced core bitboard primitives in `Board` with bit set/query operations.\
        - Laid initial game and piece scaffolding used by later move generation modules.\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What do you aim to complete before the next meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 44mm)[
        - Add attack table generation and utility helpers for square/algebraic conversion.\
        - Expand piece-wise move generation APIs from the initial board foundation.\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Supervisor comments")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 28mm)[]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Proof of work")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 30mm)[
        #set text(size: 7.1pt)
        - OopsMate commits: #link("https://github.com/PS-Wizard/OopsMate/commits/main/?since=2025-09-01&until=2025-09-07")[https://github.com/PS-Wizard/OopsMate/commits/main/?since=2025-09-01&until=2025-09-07]\
      ]],
    )
  ]
]

#pagebreak()

#align(center)[
  #block(width: 182mm)[
    #table(
      columns: (1fr, 1.8fr, 1fr, 1.8fr),
      stroke: 0.8pt + line-color,
      inset: (x: 4pt, y: 2pt),
      align: left,
      fill: (x, y) => if y == 0 { section-blue } else { none },

      table.cell(colspan: 4, align: center + horizon, inset: (x: 0pt, y: 4pt))[#strong("PROJECT MANAGEMENT LOG")],
      [#strong("First Name:")], [Swoyam], [#strong("Surname:")], [Pokharel],
      [#strong("Student Number:")], [2431342], [#strong("Supervisor:")], [Prakriti Regmi],
      [#strong("Project Title:")], [Oops!Mate.], [#strong("Month:")], [September 2025],
    )
    #table(
      columns: (1fr,),
      stroke: 0.8pt + line-color,
      inset: 0pt,
      align: (x, y) => if calc.even(y) { center + horizon } else { left + top },
      fill: (x, y) => if calc.even(y) { section-blue } else { none },

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What have you done since the last meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 76mm)[
        - Added PEXT-based attack infrastructure and lazy-initialized lookup tables.\
        - Implemented king/knight/pawn/bishop/rook/queen attack generation pathways.\
        - Refactored into clearer `attacks`, `types`, and utilities crates; introduced move typing APIs.\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What do you aim to complete before the next meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 44mm)[
        - Integrate attack APIs into full game state and legal move generation flow.\
        - Validate move correctness against pin/check edge cases.\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Supervisor comments")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 28mm)[]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Proof of work")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 30mm)[
        #set text(size: 7.1pt)
        - OopsMate commits: #link("https://github.com/PS-Wizard/OopsMate/commits/main/?since=2025-09-15&until=2025-09-21")[https://github.com/PS-Wizard/OopsMate/commits/main/?since=2025-09-15&until=2025-09-21]\
      ]],
    )
  ]
]

#pagebreak()

#align(center)[
  #block(width: 182mm)[
    #table(
      columns: (1fr, 1.8fr, 1fr, 1.8fr),
      stroke: 0.8pt + line-color,
      inset: (x: 4pt, y: 2pt),
      align: left,
      fill: (x, y) => if y == 0 { section-blue } else { none },

      table.cell(colspan: 4, align: center + horizon, inset: (x: 0pt, y: 4pt))[#strong("PROJECT MANAGEMENT LOG")],
      [#strong("First Name:")], [Swoyam], [#strong("Surname:")], [Pokharel],
      [#strong("Student Number:")], [2431342], [#strong("Supervisor:")], [Prakriti Regmi],
      [#strong("Project Title:")], [Oops!Mate.], [#strong("Month:")], [September 2025],
    )
    #table(
      columns: (1fr,),
      stroke: 0.8pt + line-color,
      inset: 0pt,
      align: (x, y) => if calc.even(y) { center + horizon } else { left + top },
      fill: (x, y) => if calc.even(y) { section-blue } else { none },

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What have you done since the last meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 76mm)[
        - Major V2 refactor: rebuilt `game` plus `pext` APIs with cleaner boundaries.\
        - Implemented pseudo-legal move generation, then constraint-based legal move generation.\
        - Added pin/check-mask logic, FEN parsing, and conversion of raw moves into typed `Move` structures.\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What do you aim to complete before the next meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 44mm)[
        - Address perft failures through another movegen rewrite.\
        - Harden make/unmake mechanics and correctness tests.\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Supervisor comments")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 28mm)[]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Proof of work")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 30mm)[
        #set text(size: 7.1pt)
        - OopsMate commits: #link("https://github.com/PS-Wizard/OopsMate/commits/main/?since=2025-09-22&until=2025-09-28")[https://github.com/PS-Wizard/OopsMate/commits/main/?since=2025-09-22&until=2025-09-28]\
      ]],
    )
  ]
]

#pagebreak()

#align(center)[
  #block(width: 182mm)[
    #table(
      columns: (1fr, 1.8fr, 1fr, 1.8fr),
      stroke: 0.8pt + line-color,
      inset: (x: 4pt, y: 2pt),
      align: left,
      fill: (x, y) => if y == 0 { section-blue } else { none },

      table.cell(colspan: 4, align: center + horizon, inset: (x: 0pt, y: 4pt))[#strong("PROJECT MANAGEMENT LOG")],
      [#strong("First Name:")], [Swoyam], [#strong("Surname:")], [Pokharel],
      [#strong("Student Number:")], [2431342], [#strong("Supervisor:")], [Prakriti Regmi],
      [#strong("Project Title:")], [Oops!Mate.], [#strong("Month:")], [September-October 2025],
    )
    #table(
      columns: (1fr,),
      stroke: 0.8pt + line-color,
      inset: 0pt,
      align: (x, y) => if calc.even(y) { center + horizon } else { left + top },
      fill: (x, y) => if calc.even(y) { section-blue } else { none },

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What have you done since the last meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 76mm)[
        - Rewrote legal move generation around a fresh board representation.\
        - Completed legal movegen and perft test coverage for standard benchmark positions.\
        - Introduced tapered PeSTO evaluation and connected a base negamax search executable.\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What do you aim to complete before the next meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 44mm)[
        - Optimize move generation hot paths and remove redundant copying.\
        - Transition from copy-make to make/unmake for search throughput.\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Supervisor comments")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 28mm)[]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Proof of work")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 30mm)[
        #set text(size: 7.1pt)
        - OopsMate commits: #link("https://github.com/PS-Wizard/OopsMate/commits/main/?since=2025-09-29&until=2025-10-05")[https://github.com/PS-Wizard/OopsMate/commits/main/?since=2025-09-29&until=2025-10-05]\
      ]],
    )
  ]
]

#pagebreak()

#align(center)[
  #block(width: 182mm)[
    #table(
      columns: (1fr, 1.8fr, 1fr, 1.8fr),
      stroke: 0.8pt + line-color,
      inset: (x: 4pt, y: 2pt),
      align: left,
      fill: (x, y) => if y == 0 { section-blue } else { none },

      table.cell(colspan: 4, align: center + horizon, inset: (x: 0pt, y: 4pt))[#strong("PROJECT MANAGEMENT LOG")],
      [#strong("First Name:")], [Swoyam], [#strong("Surname:")], [Pokharel],
      [#strong("Student Number:")], [2431342], [#strong("Supervisor:")], [Prakriti Regmi],
      [#strong("Project Title:")], [Oops!Mate.], [#strong("Month:")], [October 2025],
    )
    #table(
      columns: (1fr,),
      stroke: 0.8pt + line-color,
      inset: 0pt,
      align: (x, y) => if calc.even(y) { center + horizon } else { left + top },
      fill: (x, y) => if calc.even(y) { section-blue } else { none },

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What have you done since the last meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 76mm)[
        - Improved perft speed by removing redundant legality-path work.\
        - Cleaned project structure across board/evaluation/engine modules.\
        - Switched to explicit make/unmake with `UndoInfo` for reversible state updates.\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What do you aim to complete before the next meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 44mm)[
        - Run Elo validation and regression testing against fixed opponents.\
        - Stabilize UCI-facing move parsing and runtime behavior.\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Supervisor comments")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 28mm)[]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Proof of work")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 30mm)[
        #set text(size: 7.1pt)
        - OopsMate commits: #link("https://github.com/PS-Wizard/OopsMate/commits/main/?since=2025-10-06&until=2025-10-12")[https://github.com/PS-Wizard/OopsMate/commits/main/?since=2025-10-06&until=2025-10-12]\
      ]],
    )
  ]
]

#pagebreak()

#align(center)[
  #block(width: 182mm)[
    #table(
      columns: (1fr, 1.8fr, 1fr, 1.8fr),
      stroke: 0.8pt + line-color,
      inset: (x: 4pt, y: 2pt),
      align: left,
      fill: (x, y) => if y == 0 { section-blue } else { none },

      table.cell(colspan: 4, align: center + horizon, inset: (x: 0pt, y: 4pt))[#strong("PROJECT MANAGEMENT LOG")],
      [#strong("First Name:")], [Swoyam], [#strong("Surname:")], [Pokharel],
      [#strong("Student Number:")], [2431342], [#strong("Supervisor:")], [Prakriti Regmi],
      [#strong("Project Title:")], [Oops!Mate.], [#strong("Month:")], [October 2025],
    )
    #table(
      columns: (1fr,),
      stroke: 0.8pt + line-color,
      inset: 0pt,
      align: (x, y) => if calc.even(y) { center + horizon } else { left + top },
      fill: (x, y) => if calc.even(y) { section-blue } else { none },

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What have you done since the last meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 76mm)[
        - Ran test games and reported ~1220 Elo baseline.\
        - Minor fixes around make/unmake/perft and UCI parser touchpoints.\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What do you aim to complete before the next meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 44mm)[
        - Prepare next search-strength feature branches (pruning and deeper search control).\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Supervisor comments")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 28mm)[]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Proof of work")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 30mm)[
        #set text(size: 7.1pt)
        - OopsMate commits: #link("https://github.com/PS-Wizard/OopsMate/commits/main/?since=2025-10-13&until=2025-10-19")[https://github.com/PS-Wizard/OopsMate/commits/main/?since=2025-10-13&until=2025-10-19]\
      ]],
    )
  ]
]

#pagebreak()

#align(center)[
  #block(width: 182mm)[
    #table(
      columns: (1fr, 1.8fr, 1fr, 1.8fr),
      stroke: 0.8pt + line-color,
      inset: (x: 4pt, y: 2pt),
      align: left,
      fill: (x, y) => if y == 0 { section-blue } else { none },

      table.cell(colspan: 4, align: center + horizon, inset: (x: 0pt, y: 4pt))[#strong("PROJECT MANAGEMENT LOG")],
      [#strong("First Name:")], [Swoyam], [#strong("Surname:")], [Pokharel],
      [#strong("Student Number:")], [2431342], [#strong("Supervisor:")], [Prakriti Regmi],
      [#strong("Project Title:")], [Oops!Mate.], [#strong("Month:")], [October 2025],
    )
    #table(
      columns: (1fr,),
      stroke: 0.8pt + line-color,
      inset: 0pt,
      align: (x, y) => if calc.even(y) { center + horizon } else { left + top },
      fill: (x, y) => if calc.even(y) { section-blue } else { none },

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What have you done since the last meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 76mm)[
        - Documentation update: revised WIP/readme status and scope.\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What do you aim to complete before the next meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 44mm)[
        - Resume engine-strength feature development on branch-based workflow.\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Supervisor comments")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 28mm)[]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Proof of work")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 30mm)[
        #set text(size: 7.1pt)
        - OopsMate commits: #link("https://github.com/PS-Wizard/OopsMate/commits/main/?since=2025-10-20&until=2025-10-26")[https://github.com/PS-Wizard/OopsMate/commits/main/?since=2025-10-20&until=2025-10-26]\
      ]],
    )
  ]
]

#pagebreak()

#align(center)[
  #block(width: 182mm)[
    #table(
      columns: (1fr, 1.8fr, 1fr, 1.8fr),
      stroke: 0.8pt + line-color,
      inset: (x: 4pt, y: 2pt),
      align: left,
      fill: (x, y) => if y == 0 { section-blue } else { none },

      table.cell(colspan: 4, align: center + horizon, inset: (x: 0pt, y: 4pt))[#strong("PROJECT MANAGEMENT LOG")],
      [#strong("First Name:")], [Swoyam], [#strong("Surname:")], [Pokharel],
      [#strong("Student Number:")], [2431342], [#strong("Supervisor:")], [Prakriti Regmi],
      [#strong("Project Title:")], [Oops!Mate.], [#strong("Month:")], [November 2025],
    )
    #table(
      columns: (1fr,),
      stroke: 0.8pt + line-color,
      inset: 0pt,
      align: (x, y) => if calc.even(y) { center + horizon } else { left + top },
      fill: (x, y) => if calc.even(y) { section-blue } else { none },

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What have you done since the last meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 76mm)[
        - Implemented alpha-beta pruning in negamax search path.\
        - Added iterative deepening with `SearchLimits` and time-related control wiring.\
        - Benchmarked these search upgrades and archived outputs in `archive/data/results/legacy/pruning/` and `archive/data/results/legacy/iterative_deepening/`.\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What do you aim to complete before the next meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 44mm)[
        - Add zobrist hashing and transposition-table caching.\
        - Continue search ordering improvements.\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Supervisor comments")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 28mm)[]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Proof of work")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 30mm)[
        #set text(size: 7.1pt)
        - OopsMate commits: #link("https://github.com/PS-Wizard/OopsMate/commits/main/?since=2025-11-03&until=2025-11-09")[https://github.com/PS-Wizard/OopsMate/commits/main/?since=2025-11-03&until=2025-11-09]\
        - Benchmark logs: `archive/data/results/legacy/pruning/alpha_beta/pruning_benchmarks`, `archive/data/results/legacy/iterative_deepening/iterative_deepening_vs_stockfish_1320`.\
      ]],
    )
  ]
]

#pagebreak()

#align(center)[
  #block(width: 182mm)[
    #table(
      columns: (1fr, 1.8fr, 1fr, 1.8fr),
      stroke: 0.8pt + line-color,
      inset: (x: 4pt, y: 2pt),
      align: left,
      fill: (x, y) => if y == 0 { section-blue } else { none },

      table.cell(colspan: 4, align: center + horizon, inset: (x: 0pt, y: 4pt))[#strong("PROJECT MANAGEMENT LOG")],
      [#strong("First Name:")], [Swoyam], [#strong("Surname:")], [Pokharel],
      [#strong("Student Number:")], [2431342], [#strong("Supervisor:")], [Prakriti Regmi],
      [#strong("Project Title:")], [Oops!Mate.], [#strong("Month:")], [November 2025],
    )
    #table(
      columns: (1fr,),
      stroke: 0.8pt + line-color,
      inset: 0pt,
      align: (x, y) => if calc.even(y) { center + horizon } else { left + top },
      fill: (x, y) => if calc.even(y) { section-blue } else { none },

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What have you done since the last meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 76mm)[
        - Added zobrist hashing into position and move-update flow.\
        - Integrated transposition table APIs with iterative deepening and negamax entry points.\
        - Benchmarked hash/TPT additions with logs in `archive/data/results/legacy/tpt/results` and `archive/data/results/legacy/tpt/results_stockfish`.\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What do you aim to complete before the next meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 44mm)[
        - Introduce stronger move ordering (captures-first, later SEE/history families).\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Supervisor comments")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 28mm)[]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Proof of work")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 30mm)[
        #set text(size: 7.1pt)
        - OopsMate commits: #link("https://github.com/PS-Wizard/OopsMate/commits/main/?since=2025-11-10&until=2025-11-16")[https://github.com/PS-Wizard/OopsMate/commits/main/?since=2025-11-10&until=2025-11-16]\
        - Benchmark logs: `archive/data/results/legacy/tpt/results`, `archive/data/results/legacy/tpt/results_stockfish`.\
      ]],
    )
  ]
]

#pagebreak()

#align(center)[
  #block(width: 182mm)[
    #table(
      columns: (1fr, 1.8fr, 1fr, 1.8fr),
      stroke: 0.8pt + line-color,
      inset: (x: 4pt, y: 2pt),
      align: left,
      fill: (x, y) => if y == 0 { section-blue } else { none },

      table.cell(colspan: 4, align: center + horizon, inset: (x: 0pt, y: 4pt))[#strong("PROJECT MANAGEMENT LOG")],
      [#strong("First Name:")], [Swoyam], [#strong("Surname:")], [Pokharel],
      [#strong("Student Number:")], [2431342], [#strong("Supervisor:")], [Prakriti Regmi],
      [#strong("Project Title:")], [Oops!Mate.], [#strong("Month:")], [November 2025],
    )
    #table(
      columns: (1fr,),
      stroke: 0.8pt + line-color,
      inset: 0pt,
      align: (x, y) => if calc.even(y) { center + horizon } else { left + top },
      fill: (x, y) => if calc.even(y) { section-blue } else { none },

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What have you done since the last meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 76mm)[
        - Implemented captures-first ordering helpers in move container APIs.\
        - Reorganized and corrected captures-first benchmark logs under `archive/data/results/legacy/ordering/captures_first/`.\
        - Merged captures-first branch and fixed reporting typos.\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What do you aim to complete before the next meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 44mm)[
        - Pause window / holiday gap before major 2026 engine rewrite.\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Supervisor comments")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 28mm)[]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Proof of work")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 30mm)[
        #set text(size: 7.1pt)
        - OopsMate commits: #link("https://github.com/PS-Wizard/OopsMate/commits/main/?since=2025-11-17&until=2025-11-23")[https://github.com/PS-Wizard/OopsMate/commits/main/?since=2025-11-17&until=2025-11-23]\
        - Benchmark logs: `archive/data/results/legacy/ordering/captures_first/results`, `archive/data/results/legacy/ordering/captures_first/results_stockfish_1320`.\
      ]],
    )
  ]
]

#pagebreak()

#align(center)[
  #block(width: 182mm)[
    #table(
      columns: (1fr, 1.8fr, 1fr, 1.8fr),
      stroke: 0.8pt + line-color,
      inset: (x: 4pt, y: 2pt),
      align: left,
      fill: (x, y) => if y == 0 { section-blue } else { none },

      table.cell(colspan: 4, align: center + horizon, inset: (x: 0pt, y: 4pt))[#strong("PROJECT MANAGEMENT LOG")],
      [#strong("First Name:")], [Swoyam], [#strong("Surname:")], [Pokharel],
      [#strong("Student Number:")], [2431342], [#strong("Supervisor:")], [Prakriti Regmi],
      [#strong("Project Title:")], [Oops!Mate.], [#strong("Month:")], [January-February 2026],
    )
    #table(
      columns: (1fr,),
      stroke: 0.8pt + line-color,
      inset: 0pt,
      align: (x, y) => if calc.even(y) { center + horizon } else { left + top },
      fill: (x, y) => if calc.even(y) { section-blue } else { none },

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What have you done since the last meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 76mm)[
        - Large rewrite under root `src/`: legal move engine, evaluation, alpha-beta, qsearch, and UCI baseline.\
        - Added zobrist + TPT, move ordering (MVV-LVA/TT move), null-move pruning, LMR, killer/history scaffolding.\
        - Implemented futility pruning and extensive benchmark-driven tuning with archived engine snapshots.\
        - Captured benchmark summaries in `archive/data/results/initial_v2_test.md` and `archive/data/results/v2_mull_move_pruning.md` through `archive/data/results/v5_futility_pruning.md`.\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What do you aim to complete before the next meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 44mm)[
        - Continue advanced pruning stack (reverse futility, PVS, aspiration, SEE, IID, ProbCut).\
        - Modularize search code and improve parallel scaling.\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Supervisor comments")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 28mm)[]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Proof of work")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 30mm)[
        #set text(size: 7.1pt)
        - OopsMate commits: #link("https://github.com/PS-Wizard/OopsMate/commits/main/?since=2026-01-26&until=2026-02-01")[https://github.com/PS-Wizard/OopsMate/commits/main/?since=2026-01-26&until=2026-02-01]\
        - Benchmark logs: `archive/data/results/initial_v2_test.md`, `archive/data/results/v2_mull_move_pruning.md` to `archive/data/results/v5_futility_pruning.md`.\
      ]],
    )
  ]
]

#pagebreak()

#align(center)[
  #block(width: 182mm)[
    #table(
      columns: (1fr, 1.8fr, 1fr, 1.8fr),
      stroke: 0.8pt + line-color,
      inset: (x: 4pt, y: 2pt),
      align: left,
      fill: (x, y) => if y == 0 { section-blue } else { none },

      table.cell(colspan: 4, align: center + horizon, inset: (x: 0pt, y: 4pt))[#strong("PROJECT MANAGEMENT LOG")],
      [#strong("First Name:")], [Swoyam], [#strong("Surname:")], [Pokharel],
      [#strong("Student Number:")], [2431342], [#strong("Supervisor:")], [Prakriti Regmi],
      [#strong("Project Title:")], [Oops!Mate.], [#strong("Month:")], [February 2026],
    )
    #table(
      columns: (1fr,),
      stroke: 0.8pt + line-color,
      inset: 0pt,
      align: (x, y) => if calc.even(y) { center + horizon } else { left + top },
      fill: (x, y) => if calc.even(y) { section-blue } else { none },

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What have you done since the last meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 76mm)[
        - Implemented reverse futility, PVS, check extension, razoring, aspiration windows, IID, SEE, and ProbCut.\
        - Refactored monolithic search into modular files (`negamax`, `pruning`, `search/alphabeta`, etc.).\
        - Added Lazy SMP and multi-thread search scaling, plus mailbox and unsafe-path optimizations.\
        - Logged benchmark progression in `archive/data/results/v6_reverse_futility_pruning.md` through `archive/data/results/v16_lazysmp.md`.\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What do you aim to complete before the next meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 44mm)[
        - Add make/unmake refinements and singular/dynamic pruning updates.\
        - Start standalone NNUE track and workspace linkage.\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Supervisor comments")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 28mm)[]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Proof of work")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 30mm)[
        #set text(size: 7.1pt)
        - OopsMate commits: #link("https://github.com/PS-Wizard/OopsMate/commits/main/?since=2026-02-02&until=2026-02-08")[https://github.com/PS-Wizard/OopsMate/commits/main/?since=2026-02-02&until=2026-02-08]\
        - Benchmark logs: `archive/data/results/v6_reverse_futility_pruning.md` to `archive/data/results/v16_lazysmp.md`.\
      ]],
    )
  ]
]

#pagebreak()

#align(center)[
  #block(width: 182mm)[
    #table(
      columns: (1fr, 1.8fr, 1fr, 1.8fr),
      stroke: 0.8pt + line-color,
      inset: (x: 4pt, y: 2pt),
      align: left,
      fill: (x, y) => if y == 0 { section-blue } else { none },

      table.cell(colspan: 4, align: center + horizon, inset: (x: 0pt, y: 4pt))[#strong("PROJECT MANAGEMENT LOG")],
      [#strong("First Name:")], [Swoyam], [#strong("Surname:")], [Pokharel],
      [#strong("Student Number:")], [2431342], [#strong("Supervisor:")], [Prakriti Regmi],
      [#strong("Project Title:")], [Oops!Mate.], [#strong("Month:")], [February 2026],
    )
    #table(
      columns: (1fr,),
      stroke: 0.8pt + line-color,
      inset: 0pt,
      align: (x, y) => if calc.even(y) { center + horizon } else { left + top },
      fill: (x, y) => if calc.even(y) { section-blue } else { none },

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What have you done since the last meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 76mm)[
        - Documented Stockfish NNUE architecture study and consolidated notes.\
        - Added make/unmake in position state plus singular extension and dynamic null-move pruning adjustments.\
        - Introduced `crates/nnuebie` into workspace and started the NNUE development track.\
        - NNUE: Bootstrapped NNUE engine (`Accumulator`, `NNUEProbe`, feature transformer, evaluator, network parsing).\
        - NNUE: Implemented AVX2 accumulator/forward optimizations, scratch buffers, and multithreaded support/tests.\
        - NNUE: Added accumulator stack and Finny tables for O(1)-style make/unmake and king-move cache acceleration.\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What do you aim to complete before the next meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 44mm)[
        - Push NNUE toward stockfish-parity optimizations (alignment, cache prefill, tiled refresh kernels).\
        - Stabilize APIs and verify correctness under multithreaded stress.\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Supervisor comments")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 28mm)[]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Proof of work")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 30mm)[
        #set text(size: 7.1pt)
        - OopsMate commits: #link("https://github.com/PS-Wizard/OopsMate/commits/main/?since=2026-02-09&until=2026-02-15")[https://github.com/PS-Wizard/OopsMate/commits/main/?since=2026-02-09&until=2026-02-15]\
        - NNUEbie commits: #link("https://github.com/PS-Wizard/nnuebie/commits/main/?since=2026-02-09&until=2026-02-15")[https://github.com/PS-Wizard/nnuebie/commits/main/?since=2026-02-09&until=2026-02-15]\
      ]],
    )
  ]
]

#pagebreak()

#align(center)[
  #block(width: 182mm)[
    #table(
      columns: (1fr, 1.8fr, 1fr, 1.8fr),
      stroke: 0.8pt + line-color,
      inset: (x: 4pt, y: 2pt),
      align: left,
      fill: (x, y) => if y == 0 { section-blue } else { none },

      table.cell(colspan: 4, align: center + horizon, inset: (x: 0pt, y: 4pt))[#strong("PROJECT MANAGEMENT LOG")],
      [#strong("First Name:")], [Swoyam], [#strong("Surname:")], [Pokharel],
      [#strong("Student Number:")], [2431342], [#strong("Supervisor:")], [Prakriti Regmi],
      [#strong("Project Title:")], [Oops!Mate.], [#strong("Month:")], [February 2026],
    )
    #table(
      columns: (1fr,),
      stroke: 0.8pt + line-color,
      inset: 0pt,
      align: (x, y) => if calc.even(y) { center + horizon } else { left + top },
      fill: (x, y) => if calc.even(y) { section-blue } else { none },

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What have you done since the last meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 76mm)[
        - NNUE: Implemented weight permutation, accumulator deep-copy fixes, cache prepopulation, and tiled refresh update paths.\
        - NNUE: Added rule50 dampening through APIs and reset/push stack paths.\
        - NNUE: Consolidated constants/types, removed duplicate evaluation path, and merged optimization branch on remote.\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What do you aim to complete before the next meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 44mm)[
        - Finalize SIMD dispatch strategy (AVX2/AVX512/VNNI).\
        - Fix remaining cache-refresh correctness and benchmark coverage gaps.\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Supervisor comments")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 28mm)[]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Proof of work")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 30mm)[
        #set text(size: 7.1pt)
        - NNUEbie commits: #link("https://github.com/PS-Wizard/nnuebie/commits/main/?since=2026-02-16&until=2026-02-22")[https://github.com/PS-Wizard/nnuebie/commits/main/?since=2026-02-16&until=2026-02-22]\
      ]],
    )
  ]
]

#pagebreak()

#align(center)[
  #block(width: 182mm)[
    #table(
      columns: (1fr, 1.8fr, 1fr, 1.8fr),
      stroke: 0.8pt + line-color,
      inset: (x: 4pt, y: 2pt),
      align: left,
      fill: (x, y) => if y == 0 { section-blue } else { none },

      table.cell(colspan: 4, align: center + horizon, inset: (x: 0pt, y: 4pt))[#strong("PROJECT MANAGEMENT LOG")],
      [#strong("First Name:")], [Swoyam], [#strong("Surname:")], [Pokharel],
      [#strong("Student Number:")], [2431342], [#strong("Supervisor:")], [Prakriti Regmi],
      [#strong("Project Title:")], [Oops!Mate.], [#strong("Month:")], [February-March 2026],
    )
    #table(
      columns: (1fr,),
      stroke: 0.8pt + line-color,
      inset: 0pt,
      align: (x, y) => if calc.even(y) { center + horizon } else { left + top },
      fill: (x, y) => if calc.even(y) { section-blue } else { none },

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What have you done since the last meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 76mm)[
        - Applied clippy-focused cleanup across movegen, position, and search modules.\
        - NNUE: Fixed padding/zeroing bugs and expanded benchmark harness quality.\
        - NNUE: Added sparse FC0 AVX2 path, AVX512 VNNI paths, and AVX512 refresh kernels.\
        - NNUE: Improved Finny refresh correctness with fixed piece-list and bitboard-driven refresh paths.\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What do you aim to complete before the next meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 44mm)[
        - Stabilize NNUE tests and hot paths after SIMD refactors.\
        - Prepare reproducible Nix development setup for both repos.\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Supervisor comments")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 28mm)[]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Proof of work")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 30mm)[
        #set text(size: 7.1pt)
        - OopsMate commits: #link("https://github.com/PS-Wizard/OopsMate/commits/main/?since=2026-02-23&until=2026-03-01")[https://github.com/PS-Wizard/OopsMate/commits/main/?since=2026-02-23&until=2026-03-01]\
        - NNUEbie commits: #link("https://github.com/PS-Wizard/nnuebie/commits/main/?since=2026-02-23&until=2026-03-01")[https://github.com/PS-Wizard/nnuebie/commits/main/?since=2026-02-23&until=2026-03-01]\
      ]],
    )
  ]
]

#pagebreak()

#align(center)[
  #block(width: 182mm)[
    #table(
      columns: (1fr, 1.8fr, 1fr, 1.8fr),
      stroke: 0.8pt + line-color,
      inset: (x: 4pt, y: 2pt),
      align: left,
      fill: (x, y) => if y == 0 { section-blue } else { none },

      table.cell(colspan: 4, align: center + horizon, inset: (x: 0pt, y: 4pt))[#strong("PROJECT MANAGEMENT LOG")],
      [#strong("First Name:")], [Swoyam], [#strong("Surname:")], [Pokharel],
      [#strong("Student Number:")], [2431342], [#strong("Supervisor:")], [Prakriti Regmi],
      [#strong("Project Title:")], [Oops!Mate.], [#strong("Month:")], [March 2026],
    )
    #table(
      columns: (1fr,),
      stroke: 0.8pt + line-color,
      inset: 0pt,
      align: (x, y) => if calc.even(y) { center + horizon } else { left + top },
      fill: (x, y) => if calc.even(y) { section-blue } else { none },

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What have you done since the last meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 76mm)[
        - Added `flake.nix` and lockfile for reproducible developer environment (local branch ahead remote).\
        - NNUE: Optimized AVX2 hot paths and stabilized NNUE tests (including larger-stack test wrapper).\
        - NNUE: Added `flake.nix` in nnuebie local branch (ahead of remote main).\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("What do you aim to complete before the next meeting")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 44mm)[
        - Push local Nix commits to remotes when ready.\
        - Begin direct engine+NNUE integration milestone planning.\
      ]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Supervisor comments")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 28mm)[]],

      table.cell(inset: (x: 4pt, y: 3pt))[#strong("Proof of work")],
      table.cell(inset: (x: 6pt, y: 5pt))[#block(height: 30mm)[
        #set text(size: 7.1pt)
        - OopsMate commits: #link("https://github.com/PS-Wizard/OopsMate/commits/main/?since=2026-03-02&until=2026-03-08")[https://github.com/PS-Wizard/OopsMate/commits/main/?since=2026-03-02&until=2026-03-08]\
        - NNUEbie commits: #link("https://github.com/PS-Wizard/nnuebie/commits/main/?since=2026-03-02&until=2026-03-08")[https://github.com/PS-Wizard/nnuebie/commits/main/?since=2026-03-02&until=2026-03-08]\
      ]],
    )
  ]
]
