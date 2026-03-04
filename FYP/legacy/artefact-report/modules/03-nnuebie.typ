#import "common.typ": diag

#let nnuebie_section() = [
= 3. nnuebie NNUE Inference Crate

`nnuebie` is an independent Rust crate focused on high-throughput NNUE inference for chess engines. It follows the efficiently updatable design: sparse feature extraction, accumulator caching, incremental updates, and quantized forward propagation.

== 3.1 Integration and Dataflow

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

The integration design allows an engine to provide piece-square state while the crate handles network loading, incremental accumulator maintenance, and final centipawn-like output.

== 3.2 Core NNUE Structures

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
  "Feature-transformer responsibilities and update path",
  w: 88%,
)

#diag(
  "../artefact-diagrams/nnuebie/class-diagram-accumulator.svg",
  "Accumulator state and incremental update semantics",
  w: 88%,
)

These structures correspond to the HalfKA-style NNUE processing model described in the crate documentation (`src/nnuebie/README.md`).

== 3.3 Incremental Update Sequence

#diag(
  "../artefact-diagrams/nnuebie/sequence-diagram-incremental.svg",
  "Sequence of operations for incremental evaluation update",
  w: 90%,
)

The sequence highlights the core performance property of NNUE: update only features affected by a move, instead of recomputing a full network input transform from scratch.
]
