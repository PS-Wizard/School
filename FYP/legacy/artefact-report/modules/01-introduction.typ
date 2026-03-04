#let introduction_section() = [
= 1. Introduction

This artefact report documents the software design and implementation structure of the FYP chess-engine workbench. The project is organized around four technical units:

- `OopsMate`: the Rust chess engine executable and search framework.
- `Strikes`: precomputed attack and ray tables for fast move generation.
- `Utilities`: common notation and board-display helpers.
- `nnuebie`: a standalone Rust NNUE inference crate for chess evaluation.

The report presents architecture, key data/control flows, and implementation-level diagrams generated from the current codebase and maintained in `artefact-report/artefact-diagrams`.

== 1.1 Scope and Evidence Base

The technical statements in this report are aligned with the current repository layout and module boundaries, especially:

- `src/OopsMate/Cargo.toml` and `src/OopsMate/src/` for engine composition.
- `src/OopsMate/crates/strikes/src/` and `src/OopsMate/crates/utilities/src/` for support crates.
- `src/nnuebie/README.md` and `src/nnuebie/src/` for NNUE design and API intent.

The design objective is clean separation of responsibilities: search and protocol handling in the engine, move legality infrastructure in `strikes`, utility abstractions in `utilities`, and high-performance neural evaluation in `nnuebie`.
]
