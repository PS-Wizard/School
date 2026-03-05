#import "common.typ": diag

#let nnuebie_section() = [
== `nnuebie` NNUE Inference Crate

`nnuebie` is an independent Rust crate aiming to provide high-throughput NNUE inference for chess engines. It follows the stockfish's design: sparse feature extraction, accumulator caching, incremental updates, and quantized forward propagation.

=== Integration and Dataflow

#diag(
  "../artefact-diagrams/nnuebie/component-nnuebie-integration.svg",
  "Integration boundary between engine state and nnuebie evaluation",
  w: 90%,
)

#diag(
  "../artefact-diagrams/nnuebie/dataflow-nnue-evaluation.svg",
  "NNUE dataflow from board features to scalar evaluation score",
  w: 58%,
)

The integration design allows an engine to provide piece-square state while the crate handles network loading, incremental accumulator maintenance, and final centipawn output.

=== Core NNUE Structures

#diag(
  "../artefact-diagrams/nnuebie/class-diagram-network.svg",
  "Network-level structures for loaded NNUE parameters",
  w: 90%,
)

#diag(
  "../artefact-diagrams/nnuebie/class-diagram-layers.svg",
  "Layer composition used in integer forward propagation",
  w: 92%,
)

#diag(
  "../artefact-diagrams/nnuebie/class-diagram-feature-transformer.svg",
  "Feature transformer's decomposition",
  w: 88%,
)

#diag(
  "../artefact-diagrams/nnuebie/class-diagram-accumulator.svg",
  "Accumulator state and incremental update semantics",
  w: 88%,
)

=== Incremental Update Sequence

#diag(
  "../artefact-diagrams/nnuebie/sequence-diagram-incremental.svg",
  "Sequence of operations for incremental evaluation update",
  w: 90%,
)

=== Current Performance:

```
[wizard@nixos:~/Projects/nnuebie]$ ./target/release/benchmark
Loading networks...
Benchmarking with 13 FENs...
Full Refresh (FEN corpus): 529751.91 evals/sec (1999998 evals, 3.78s)
Incremental (mixed moves): 1620089.73 evals/sec (12000000 evals, 7.41s)
King Refresh (toggle): 1805664.43 evals/sec (5000000 evals, 2.77s)

Summary:
- Full Refresh (FEN corpus): 529751.91 evals/sec
- Incremental (mixed moves): 1620089.73 evals/sec
- King Refresh (toggle): 1805664.43 evals/sec

[wizard@nixos:~/Projects/nnuebie]$
```

]
