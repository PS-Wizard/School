#let introduction_section() = [
== Introduction

This artefact report documents the software design and implementation structure of OopsMate. The project is organized around four technical units:

- `OopsMate`: The actual chess engine.
- `Strikes`: Crate providing precomputed attack and ray tables.
- `Utilities`: Crate providing common notation and board-display helpers.
- `nnuebie`: Crate providing inference for Stockfish NNUE.

The design objective is clean separation of responsibilities: 
- Search and protocol handling and tradition evaluation fucntion in the engine's crate itself, 
- Move legality infrastructure in `strikes`,
- Utility abstractions in `utilities`, 
- NNUE evaluation in `nnuebie`.
]
