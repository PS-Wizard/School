# Seekdown — Rust IR Project Roadmap

## Project Context

Seekdown is a lightweight Information Retrieval system written in Rust. It indexes Markdown documentation, preserves document structure, builds an inverted index, ranks results using classic lexical retrieval models, and evaluates retrieval quality with standard IR metrics.

The academic angle is:

> Can foundational lexical IR algorithms remain effective when combined with structure-aware Markdown indexing?

The implementation angle is:

> Build a fast local CLI search engine with clean indexing/search separation, measurable ranking quality, and strong performance numbers.

## Proposed Techniques From the Proposal

### Ranking models

1. **Boolean retrieval**
   - Exact term matching.
   - Baseline model.
   - A section/document either matches query terms or it does not.
   - Useful as the simplest control system.

2. **TF-IDF**
   - Scores documents using term frequency and inverse document frequency.
   - Rewards terms that appear often in a document but rarely across the corpus.
   - Strong classic baseline for lexical search.

3. **BM25**
   - Probabilistic lexical ranking model.
   - Improves over TF-IDF using term saturation and document length normalization.
   - Expected to be one of the strongest core models.

4. **BM25+**
   - BM25 variant that reduces excessive penalty against longer documents.
   - Useful because Markdown sections can vary heavily in length.

5. **Pivoted Length Normalization**
   - Alternative length-normalized scoring model.
   - Useful comparison against BM25-style normalization.

### Parsing/indexing comparisons

1. **Naive chunking**
   - Split files into fixed-size token or line windows.
   - Ignores Markdown structure.
   - Serves as the baseline document segmentation approach.

2. **Structure-aware Markdown parsing**
   - Parse headers, sections, code blocks, lists, and metadata.
   - Preserve header hierarchy such as `README > Installation > Linux`.
   - Treat logical Markdown sections as searchable units.
   - Main experimental contribution.

## Core Research Questions

1. Which lexical ranking model performs best on Markdown documentation?
2. Does structure-aware section indexing outperform naive chunking?
3. What is the speed/quality trade-off between Boolean, TF-IDF, BM25, BM25+, and Pivoted Length Normalization?
4. Can a local Rust CLI search tool provide strong retrieval quality with sub-millisecond or low-millisecond query latency on a medium Markdown corpus?

## Recommended Document Unit

Use **section-level indexing** as the primary structure-aware strategy.

A Markdown file should become multiple searchable units:

```text
file: docs/getting-started.md
section 1: # Getting Started
section 2: # Getting Started > ## Installation
section 3: # Getting Started > ## Installation > ### Linux
section 4: # Getting Started > ## Configuration
```

Each section becomes an internal `DocId` with metadata:

```text
DocId
File path
Header path
Heading text
Body text
Start line
End line
Token length
```

Why this is the right choice:

- Better relevance: queries like `install linux` should return the installation section, not the whole README.
- Better evaluation: relevance judgments can target sections precisely.
- Better snippets: CLI output can show the exact section path.
- Better research: allows a clean comparison against naive chunks.

Also keep file-level metadata so results can be grouped by source file in output.

---

# Phase 1 — Foundations

## Goal

Build the smallest complete IR pipeline:

```text
Markdown files -> parser -> tokenizer -> inverted index -> query -> ranking -> top-k results
```

## Checklist

- [ ] Create Rust crate as a CLI application.
- [ ] Add a library entry point so core logic is testable without invoking the CLI.
- [ ] Define core IDs:
  - [ ] `TermId = u32`
  - [ ] `DocId = u32`
- [ ] Define document unit:
  - [ ] file path
  - [ ] section/header path
  - [ ] raw text or normalized token stream
  - [ ] length in tokens
- [ ] Implement recursive corpus loading from a directory.
- [ ] Only ingest `.md` and `.markdown` files.
- [ ] Implement basic tokenizer:
  - [ ] lowercase ASCII/Unicode text
  - [ ] split on non-alphanumeric boundaries
  - [ ] keep useful technical tokens such as `rust`, `serde`, `cli`, `json`, `http`
  - [ ] optional stopword removal behind a config flag
- [ ] Build simple in-memory inverted index.
- [ ] Implement Boolean search first.
- [ ] Return top-k results with file path, section title, score, and snippet.

## Minimal CLI shape

```bash
seekdown index ./dataset --out ./index.seek
seekdown search ./index.seek "install rust cli" --model bm25 --top-k 10
seekdown eval ./index.seek ./qrels.csv ./queries.csv --model bm25 --top-k 10
```

## First correctness target

Given three tiny Markdown files, a query for a unique term must return the section containing that term as rank 1.

---

# Phase 2 — Indexing System

## Goal

Build a fast, explicit inverted index with enough statistics for all proposed ranking models.

## Lucene-style architecture

Separate indexing from searching:

```text
Indexing pipeline:
raw markdown -> parse sections -> tokenize -> assign term IDs -> build postings -> persist index

Query pipeline:
query string -> tokenize -> term lookup -> postings traversal -> score accumulation -> top-k ranking
```

This separation is important for marks because it shows proper IR architecture rather than a script that scans files at query time.

## Core data structures

### Term dictionary

```rust
HashMap<String, TermId>
Vec<String> // term_id -> original term
```

Purpose:

- Convert terms into compact integer IDs.
- Avoid storing repeated strings in postings.
- Keep query lookup simple.

### Document store

```rust
Vec<DocumentMeta>
```

Where `DocumentMeta` contains:

```text
DocId
PathBuf or compact String path
Header path: Vec<String> or compact joined string
Title
Start line
End line
Length in tokens
```

Hot path should use `doc_lengths: Vec<u32>` separately so scoring does not chase large metadata structs.

### Inverted index

Recommended structure:

```rust
Vec<PostingsList> // indexed by TermId

PostingsList {
    doc_ids: Vec<DocId>,
    term_freqs: Vec<u32>,
}
```

This struct-of-arrays layout is better than `Vec<Posting { doc_id, tf }>` for cache behavior during scoring.

### Corpus statistics

```text
num_docs: u32
avg_doc_len: f32
doc_lengths: Vec<u32>
document_frequency: Vec<u32>
```

Needed for TF-IDF, BM25, BM25+, and Pivoted Length Normalization.

## Index build flow

1. Walk dataset directory.
2. Read each Markdown file once.
3. Parse into document units:
   - structure-aware sections, or
   - naive chunks, depending on mode.
4. Tokenize each unit.
5. Count local term frequencies with `HashMap<TermId, u32>`.
6. Append one posting per term per document.
7. Sort postings by `DocId` if needed.
8. Store corpus statistics.
9. Serialize index to disk.

## Storage design

Use in-memory index first, then persist to disk.

Recommended practical storage:

- `bincode` or `postcard` for compact binary serialization.
- `serde` derives for index structs.
- Store metadata and postings in one index file for simplicity.

Avoid JSON for the index because it is slower and larger. JSON is fine for evaluation outputs.

## Tradeoffs

| Choice | Benefit | Cost |
|---|---|---|
| Section-level docs | Better relevance | More docs to index |
| Fixed chunks | Simple baseline | Breaks context |
| `TermId` integers | Faster postings | Requires dictionary |
| In-memory search | Very fast | Index must fit RAM |
| Binary index file | Fast load | Less human-readable |
| Separate hot/cold fields | Faster ranking | Slightly more code |

---

# Phase 3 — Ranking Models

## Implementation order

1. Boolean
2. TF-IDF
3. BM25
4. BM25+
5. Pivoted Length Normalization
6. Structure-aware score boosts

This order gives visible progress and makes each model testable against the previous one.

## Shared scoring flow

For a tokenized query:

1. Convert query terms to `TermId`s.
2. For each query term, get postings list.
3. Accumulate scores in `Vec<f32>` or sparse accumulator.
4. Select top-k documents.
5. Return sorted results.

For early implementation, use:

```text
scores: Vec<f32> with length num_docs
seen_docs: Vec<DocId>
```

When scoring a doc for the first time, push it into `seen_docs`. After the query, only clear scores for seen docs. This avoids resetting a full scores array on every query.

## Boolean retrieval

Score options:

```text
AND mode: document must contain all query terms
OR mode: score = number of matched query terms
```

Use OR mode for ranked output and AND mode as an optional CLI flag.

Pitfall:

- Boolean retrieval is not a ranking model unless you define a tie-breaker.
- Use matched term count, then shorter section length as tie-breaker.

## TF-IDF

Recommended formula:

```text
tf = 1 + ln(term_frequency)
idf = ln((N + 1) / (df + 1)) + 1
score(d, q) = Σ tf(t, d) * idf(t)
```

Where:

```text
N = number of documents/sections
df = number of documents containing term t
```

Pitfalls:

- Raw term frequency over-rewards long sections.
- IDF must handle unseen terms and avoid division by zero.
- Use `ln`, not arbitrary log bases, and document it in the report.

## BM25

Formula:

```text
idf = ln(1 + (N - df + 0.5) / (df + 0.5))
score = Σ idf * ((tf * (k1 + 1)) / (tf + k1 * (1 - b + b * dl / avgdl)))
```

Recommended parameters:

```text
k1 = 1.2
b = 0.75
```

Where:

```text
dl = document length in tokens
avgdl = average document length
```

Pitfalls:

- `avgdl` must be computed per segmentation mode. Naive chunks and sections have different length distributions.
- BM25 can behave badly if document lengths are zero. Empty sections should not be indexed.

## BM25+

Formula:

```text
score = Σ idf * (delta + ((tf * (k1 + 1)) / (tf + k1 * (1 - b + b * dl / avgdl))))
```

Recommended parameters:

```text
k1 = 1.2
b = 0.75
delta = 1.0
```

Purpose:

- Prevents long documents with matching terms from being pushed too low.

Pitfall:

- Apply delta only when the term exists in the document, not to every document.

## Pivoted Length Normalization

Formula:

```text
score = Σ ((1 + ln(1 + ln(tf))) / ((1 - s) + s * (dl / avgdl))) * idf
```

Recommended parameter:

```text
s = 0.2
```

Pitfalls:

- Requires careful handling of `tf = 0`; only score postings where `tf > 0`.
- Keep the formula consistent across all experiments.

## Ranking model architecture

Use an enum for model selection to avoid trait object dispatch in the hot scoring loop:

```text
RankingModel::Boolean
RankingModel::TfIdf
RankingModel::Bm25 { k1, b }
RankingModel::Bm25Plus { k1, b, delta }
RankingModel::Pivoted { slope }
```

A trait is fine for clean external API, but the inner scoring loop should dispatch once before traversal or use an enum `match` outside the tightest loop where possible.

---

# Phase 4 — Query Engine

## Goal

Provide a CLI search path that is fast, deterministic, and easy to demo.

## Retrieval flow

```text
load index -> parse CLI query -> tokenize -> lookup terms -> score postings -> top-k -> format results
```

## Top-k selection

Use a binary heap for top-k:

```text
BinaryHeap<Reverse<ScoredDoc>> limited to k
```

For small corpora, sorting all seen scored docs is acceptable. For the performance demo, heap-based top-k is cleaner.

## Result format

Each result should show:

```text
rank
score
file path
header path
line range
short snippet
matched terms
```

Example:

```text
1. score=8.423 docs/getting-started.md > Installation > Linux lines 20-44
   cargo install seekdown
```

## CLI commands

```bash
seekdown index <dataset_dir> --out <index_file> --mode section
seekdown index <dataset_dir> --out <index_file> --mode chunk --chunk-size 250
seekdown search <index_file> <query> --model bm25 --top-k 10
seekdown eval <index_file> <queries.csv> <qrels.csv> --model bm25 --top-k 10
seekdown bench <index_file> <queries.csv> --model bm25 --repeat 1000
```

## Optimization ideas that are worth implementing

- Use `TermId` and `DocId` integer IDs.
- Keep postings sorted by `DocId`.
- Store `doc_lengths` separately from metadata.
- Reuse score buffers across repeated benchmark queries.
- Track `seen_docs` to clear only touched scores.
- Ignore query terms that do not exist in the dictionary.
- Deduplicate repeated query terms or count query term frequency explicitly.
- Benchmark in `--release` only.

## Optimization ideas to avoid

- No distributed systems.
- No async runtime for local file indexing/search.
- No neural embeddings.
- No database server.
- No complicated compression until the uncompressed index works and is measured.

---

# Phase 5 — Evaluation

## Goal

Produce research-paper-style evidence using standard IR tooling.

Seekdown should not reimplement every effectiveness metric as the primary evaluation path. Instead, it should export **TREC-compatible run files** and compare them against manually judged **qrels** using `trec_eval`.

This gives the report stronger academic framing:

> Retrieval effectiveness was evaluated with `trec_eval`, a standard Information Retrieval evaluation tool. Seekdown exported rankings in TREC run format and compared them against manually annotated relevance judgments using P@10, Recall@10, MAP, reciprocal rank, and nDCG@10.

Evaluation compares:

1. Ranking models.
2. Section-aware indexing vs naive chunking.
3. Retrieval quality vs query latency.
4. Single-threaded vs multi-threaded execution speed, while verifying rankings remain identical.

## Dataset construction

Use real Markdown documentation from open-source repositories.

Good sources:

- Rust crates documentation repositories.
- CLI tool docs.
- Static site docs.
- Framework docs.
- README-heavy GitHub repositories.

Dataset target:

```text
Small demo corpus: 100-300 Markdown files
Final corpus: 1,000-10,000 Markdown files
```

Keep a dataset manifest:

```csv
repo,path,license,commit,file_count
rust-lang/book,src/ch01-00-getting-started.md,MIT/Apache,abc123,180
```

This improves academic credibility and makes the corpus reproducible.

## Query set

Create 25-50 realistic developer queries.

Examples:

```text
install rust toolchain
configure environment variables
json serialization example
command line arguments
docker deployment
http request timeout
authentication middleware
markdown table syntax
error handling result
logging configuration
```

Store queries as CSV:

```csv
query_id,query_text
q001,install rust toolchain
q002,json serialization example
```

## Stable document keys

Every indexed document unit needs a stable external ID used by qrels and run files.

Section-aware key:

```text
relative/path.md#header-one/header-two
```

Naive chunk key:

```text
relative/path.md#chunk-0004
```

Rules:

- Keys must be deterministic across runs.
- Keys must not depend on internal `DocId` values.
- Header text should be slugified consistently.
- Duplicate headings need a numeric suffix.

## Relevance judgments: qrels

`trec_eval` qrels format:

```text
query_id 0 doc_id relevance
```

Example:

```text
q001 0 docs/install.md#installation 3
q001 0 README.md#getting-started 2
q001 0 docs/config.md#manual-install 1
q001 0 docs/unrelated.md#intro 0
q002 0 docs/json.md#serde-json 3
q002 0 docs/config.md#json-config 2
```

Suggested relevance scale:

```text
0 = not relevant
1 = partially relevant
2 = relevant
3 = highly relevant
```

Graded relevance is useful because nDCG rewards highly relevant results appearing near the top.

## Pooling workflow for manual evaluation

Manual qrels are still required for real IR evaluation. The clean workflow is to generate an annotation pool automatically, then label it manually.

1. Run multiple systems over the same query set:
   - Boolean
   - TF-IDF
   - BM25
   - BM25+
   - Pivoted Length Normalization
   - section-aware mode
   - naive chunk mode
2. Take top-k results from each run.
3. Merge duplicate `(query_id, doc_id)` pairs.
4. Export `pool.csv` for manual annotation.
5. Convert annotated judgments into `qrels.txt`.

Pool CSV format:

```csv
query_id,query_text,doc_id,path,title,snippet,relevance
q001,install rust toolchain,docs/install.md#installation,docs/install.md,Installation,"Install with cargo...",
```

The `relevance` column is filled manually with `0`, `1`, `2`, or `3`.

## TREC run files

Seekdown should export rankings in TREC run format:

```text
query_id Q0 doc_id rank score run_name
```

Example:

```text
q001 Q0 docs/install.md#installation 1 8.423 seekdown_bm25_section
q001 Q0 README.md#getting-started 2 6.912 seekdown_bm25_section
q001 Q0 docs/config.md#manual-install 3 4.110 seekdown_bm25_section
q002 Q0 docs/json.md#serde-json 1 9.100 seekdown_bm25_section
q002 Q0 docs/config.md#json-config 2 5.322 seekdown_bm25_section
```

Run names should encode the experiment:

```text
seekdown_boolean_chunk
seekdown_tfidf_chunk
seekdown_bm25_chunk
seekdown_bm25plus_chunk
seekdown_pivoted_chunk
seekdown_boolean_section
seekdown_tfidf_section
seekdown_bm25_section
seekdown_bm25plus_section
seekdown_pivoted_section
seekdown_bm25_section_parallel
```

## Recommended CLI evaluation commands

Generate a single run file:

```bash
seekdown run ./section.seek ./queries.csv \
  --model bm25 \
  --top-k 100 \
  --name seekdown_bm25_section \
  --out runs/bm25_section.run
```

Generate an annotation pool:

```bash
seekdown pool ./section.seek ./chunk.seek ./queries.csv \
  --models boolean,tfidf,bm25,bm25-plus,pivoted \
  --top-k 20 \
  --out qrels/pool.csv
```

Convert annotated pool CSV to qrels:

```bash
seekdown qrels qrels/pool_annotated.csv --out qrels/qrels.txt
```

Run `trec_eval`:

```bash
trec_eval -m P.10 -m recall.10 -m map -m recip_rank -m ndcg_cut.10 \
  qrels/qrels.txt \
  runs/bm25_section.run
```

Run all experiments from a small shell script:

```bash
for run in runs/*.run; do
  trec_eval -m P.10 -m recall.10 -m map -m recip_rank -m ndcg_cut.10 qrels/qrels.txt "$run"
done
```

## Metrics to report from trec_eval

Use these final paper metrics:

```text
P.10          Precision at 10
recall.10     Recall at 10
map           Mean Average Precision
recip_rank    Reciprocal rank / MRR-style first relevant result quality
ndcg_cut.10   nDCG at 10 with graded relevance
```

Also report performance metrics from Seekdown itself:

```text
Index build time
Index size on disk
Index load time
Mean query latency
Median query latency
P95 query latency
Throughput: queries per second
```

## Multithreading experiment

Multithreading should affect **speed**, not **ranking quality**.

Valid experiments:

1. Single-threaded indexing vs parallel indexing.
2. Single-threaded batch query evaluation vs parallel batch query evaluation.
3. Single-threaded benchmark vs parallel benchmark.

Correctness rule:

```text
same input + same model + same index mode = identical ranked doc IDs and scores within float tolerance
```

If parallelism changes ranking order, that is a bug caused by nondeterministic accumulation, unstable tie-breaking, or floating-point reduction order.

Parallelism candidates:

- Parallel file parsing during indexing.
- Parallel token counting per document.
- Parallel batch query execution during `run`, `pool`, and `bench`.

Avoid parallelizing the inner scoring loop until the single-threaded implementation is complete and measured. Batch-level query parallelism gives clean speedups without risking ranking nondeterminism.

## Experiment matrix

Run every ranking model against both segmentation modes:

| Segmentation | Model |
|---|---|
| Naive chunk | Boolean |
| Naive chunk | TF-IDF |
| Naive chunk | BM25 |
| Naive chunk | BM25+ |
| Naive chunk | Pivoted Length Normalization |
| Section-aware | Boolean |
| Section-aware | TF-IDF |
| Section-aware | BM25 |
| Section-aware | BM25+ |
| Section-aware | Pivoted Length Normalization |
| Section-aware | BM25 single-threaded |
| Section-aware | BM25 parallel batch queries |

## Research paper table format

Retrieval quality table from `trec_eval`:

| Mode | Model | P@10 | Recall@10 | MAP | RR | nDCG@10 |
|---|---:|---:|---:|---:|---:|---:|
| Chunk | Boolean | | | | | |
| Chunk | TF-IDF | | | | | |
| Chunk | BM25 | | | | | |
| Section | Boolean | | | | | |
| Section | TF-IDF | | | | | |
| Section | BM25 | | | | | |

Performance table from Seekdown:

| Mode | Model | Threads | Mean ms | Median ms | P95 ms | QPS |
|---|---|---:|---:|---:|---:|---:|
| Section | BM25 | 1 | | | | |
| Section | BM25 | auto | | | | |

Indexing table:

| Mode | Files | Docs/sections | Terms | Index size MB | Build time s | Threads |
|---|---:|---:|---:|---:|---:|---:|
| Chunk | | | | | | 1 |
| Section | | | | | | 1 |
| Section | | | | | | auto |

---

# Phase 6 — Enhancements For Marks And Wow Factor

## Structure-aware ranking boosts

Add controlled boosts and evaluate them as a separate variant.

Possible boosts:

```text
Heading match boost: query term appears in heading/title
Header path boost: query term appears in parent header
Code block boost: query term appears in code block for technical queries
Exact phrase boost: query terms appear adjacent or near-adjacent
```

Example scoring adjustment:

```text
final_score = base_score * heading_boost * path_boost
```

Keep boosts simple and documented. Compare BM25 vs BM25 + structure boosts.

## Snippet generation

Generate snippets around first matched query term.

Academic value:

- Shows usability, not just metric output.

Implementation:

- Store original section text or line offsets.
- Extract ±N characters around match.
- Highlight terms in CLI with ANSI color if output is a terminal.

## Query analysis

Add optional query term diagnostics:

```bash
seekdown explain ./index.seek "install rust" --model bm25
```

Output:

```text
term=install df=32 idf=2.41
term=rust df=118 idf=1.12
```

Academic value:

- Demonstrates interpretability of lexical models.
- Helps explain why results ranked where they did.

## Benchmark command

Add:

```bash
seekdown bench ./index.seek ./queries.csv --model bm25 --repeat 1000
```

Output:

```text
queries=50 repeat=1000 total=50000
mean=0.043ms median=0.038ms p95=0.071ms qps=23255
```

This is strong demo material.

## Export experiment results

Export TREC run files for `trec_eval` and CSV benchmark summaries for charts:

```bash
seekdown run ./section.seek queries.csv --model bm25 --top-k 100 --name seekdown_bm25_section --out runs/bm25_section.run
seekdown bench ./section.seek queries.csv --model bm25 --repeat 1000 --format csv > results/bm25_latency.csv
```

This keeps IR quality evaluation and speed benchmarking cleanly separated.

---

# Suggested Rust Module Structure

```text
seekdown/
  Cargo.toml
  PROJECT_ROADMAP.md
  src/
    main.rs                  # CLI entry only
    lib.rs                   # public library modules
    cli.rs                   # command parsing and command dispatch
    error.rs                 # project error type

    load/                    # Phase 1: read Markdown and produce document units
      mod.rs                 # DocumentLoader trait and LoadedDocument type
      corpus.rs              # file walking and raw Markdown loading
      section.rs             # structure-aware Markdown section loader
      chunk.rs               # naive fixed-size chunk loader

    tokenize/                # Phase 2: normalize text into terms
      mod.rs                 # tokenizer, stopwords, optional stemming

    index/                   # Phase 3: build and store the inverted index
      mod.rs
      builder.rs             # LoadedDocument + tokens -> inverted index
      types.rs               # TermId, DocId, postings, document statistics
      storage.rs             # save/load binary index

    ranking/                 # Phase 4: score candidates from postings lists
      mod.rs
      boolean.rs
      tfidf.rs
      bm25.rs
      bm25_plus.rs
      pivoted.rs

    query.rs                 # Phase 5: query tokenization, postings lookup, top-k retrieval
    output.rs                # Phase 6: CLI result formatting and snippets
    bench.rs                 # latency benchmarking

    eval/                    # Research evaluation exports for trec_eval
      mod.rs
      trec.rs                # TREC run/qrels format writing and validation
      pool.rs                # annotation pool generation for manual qrels
      runner.rs              # batch run generation across queries/models

  tests/
    fixtures/
      tiny_corpus/
      queries.csv
      qrels.txt
    pipeline_test.rs
    trec_format_test.rs
```

The runtime pipeline maps directly to the module layout:

```text
load::{section|chunk}
  -> tokenize
  -> index::builder
  -> query + ranking
  -> output
  -> eval / bench
```

`section.rs` and `chunk.rs` are two implementations of the same loading phase. They both produce `LoadedDocument` values. Everything after loading stays identical, which makes the structure-aware vs naive-chunk comparison fair.

Keep `main.rs` thin. All real logic belongs in `lib.rs` modules so tests can call it directly.

---

# Suggested Dependencies

Use a small dependency set:

```toml
clap = { version = "4", features = ["derive"] }
serde = { version = "1", features = ["derive"] }
bincode = "1"
thiserror = "1"
walkdir = "2"
csv = "1"
```

Optional after the core works:

```toml
pulldown-cmark = "0.10" # Markdown event parser
rust-stemmers = "1"     # stemming experiment
criterion = "0.5"       # Rust microbenchmarks
rayon = "1"             # parallel indexing and batch query experiments
```

External evaluation tool:

```bash
trec_eval
```

Use `trec_eval` for final IR-quality metrics. Use Seekdown's own `bench` command for latency, throughput, and indexing speed.

Use `pulldown-cmark` if manual Markdown parsing becomes messy. For this project, a focused header/section parser can be implemented manually because the needed structure is limited. Use `rayon` for coarse-grained parallelism only: file-level indexing and batch query execution.

---

# Test Strategy

## Unit tests

Test small deterministic units.

### Tokenizer tests

- [ ] lowercases text
- [ ] splits punctuation
- [ ] keeps useful technical terms
- [ ] removes stopwords when enabled
- [ ] does not remove stopwords when disabled

Example:

```text
"Rust, rust-cli and JSON!" -> ["rust", "rust", "cli", "json"]
```

### Markdown parser tests

- [ ] extracts top-level heading
- [ ] creates a new section for each heading
- [ ] preserves parent header path
- [ ] assigns correct line ranges
- [ ] ignores empty sections
- [ ] handles files with no heading by creating a fallback root section

### Chunker tests

- [ ] splits by configured token count
- [ ] does not emit empty chunks
- [ ] keeps stable chunk IDs

### Index tests

- [ ] one term maps to one postings list
- [ ] term frequency is counted correctly
- [ ] document length is stored correctly
- [ ] document frequency is correct
- [ ] unknown term lookup returns no postings

### Ranking tests

Use a tiny artificial corpus where the expected order is obvious.

Example:

```text
doc 1: "rust rust rust install"
doc 2: "rust install"
doc 3: "python install"
query: "rust"
```

Expected:

- TF-IDF ranks doc 1 above doc 2.
- BM25 reduces the gap because of saturation.
- Boolean ranks both as matches.

### Metric tests

Use hand-computed examples.

- [ ] Precision@k returns correct fraction.
- [ ] Recall@k returns correct fraction.
- [ ] MRR uses first relevant result only.
- [ ] nDCG@k handles graded relevance.
- [ ] nDCG@k returns `1.0` for ideal ranking.
- [ ] nDCG@k returns `0.0` when no relevant documents are retrieved.

## Integration tests

Use `tests/fixtures/tiny_corpus`.

Test full pipeline:

```text
index tiny corpus -> run query -> assert expected doc_key appears at rank 1
```

Integration tests should cover:

- [ ] section-aware index + BM25
- [ ] naive chunk index + BM25
- [ ] CLI search output contains expected file path
- [ ] eval command computes expected metrics on tiny qrels

## Testing retrieval results without confusion

Retrieval tests should not assert every score exactly unless the formula is tiny and deterministic. Instead:

1. Unit-test formulas exactly with known inputs.
2. Integration-test ranking order.
3. Evaluation-test metrics from fixed ranked lists.

This avoids brittle tests while still proving correctness.

Recommended split:

```text
Formula test: exact floating-point score within epsilon
Ranking test: doc A ranks above doc B
Pipeline test: known relevant section appears in top 1/top 3
Metric test: exact P@10, Recall@10, MRR, nDCG values
```

For floats:

```text
abs(actual - expected) < 1e-6
```

---

# Common Mistakes To Avoid

- Scanning raw files at query time instead of using an index.
- Mixing indexing and searching logic in the same function.
- Treating the whole Markdown file as the only document unit.
- Forgetting to compare structure-aware parsing against naive chunking.
- Reporting only speed and not retrieval quality.
- Reporting only quality and not latency/index size.
- Using debug builds for benchmarks.
- Evaluating with queries that have no relevance judgments.
- Changing the dataset between model comparisons.
- Changing tokenization between model comparisons.
- Letting BM25 use different parameters without documenting them.
- Including empty sections as documents.
- Resetting a full score array for every query when only a few documents were touched.
- Using strings in postings lists instead of integer IDs.
- Leaving CLI-only logic untestable because everything is inside `main.rs`.

---

# Final Build Checklist

## Implementation

- [ ] CLI has `index`, `search`, `eval`, and `bench` commands.
- [ ] Section-aware indexing works.
- [ ] Naive chunk indexing works.
- [ ] Inverted index stores postings, TF, DF, document lengths, and metadata.
- [ ] Boolean, TF-IDF, BM25, BM25+, and Pivoted Length Normalization work.
- [ ] Top-k query results are stable and deterministic.
- [ ] Index can be saved and loaded.

## Evaluation

- [ ] Dataset manifest exists.
- [ ] Query set has at least 25 queries.
- [ ] Qrels contain graded relevance judgments.
- [ ] Evaluation computes Precision@k, Recall@k, MRR, and nDCG@k.
- [ ] Results compare all models across both segmentation modes.
- [ ] Speed benchmark reports mean, median, p95, and QPS.

## Report material

- [ ] Architecture diagram: indexing pipeline vs query pipeline.
- [ ] Data structure explanation: inverted index and postings list.
- [ ] Formula section for all ranking models.
- [ ] Dataset description and qrels methodology.
- [ ] Results table for retrieval quality.
- [ ] Results table for indexing/search speed.
- [ ] Short analysis explaining which model won and why.
- [ ] Discussion of structure-aware vs naive chunking.

## Demo script

```bash
cargo run --release -- index ./dataset --out ./section.seek --mode section
cargo run --release -- index ./dataset --out ./chunk.seek --mode chunk --chunk-size 250
cargo run --release -- search ./section.seek "install rust cli" --model bm25 --top-k 5
cargo run --release -- eval ./section.seek ./queries.csv ./qrels.csv --model bm25 --top-k 10
cargo run --release -- bench ./section.seek ./queries.csv --model bm25 --repeat 1000
```
