# Getting Started

Seekdown is a local search tool for Markdown documentation.
It indexes sections so results stay close to the real context.

## Installation

Install the binary with Cargo.

```bash
cargo build --release
cargo run -- search ./test_corpus "install cargo"
```

## Configuration

Configuration uses a small local index and plain text queries.
