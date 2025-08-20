# SDE Portfolio

## Chess Evaluator
A high-performance targeted, chess evaluation API built in **rust**. 

## Stack:
- Rust
- Axum: Web Framework
- Tokio: Async Runtime
- LibSQL (Turso): Distributed SQL Database
- Stockfish: Chess Engine
- Redis: Cache
- Argon2: Password Hashing
- JWT: Authorization
- Chrono: Timestamps for expiration

## Installation

1. Clone + Build:
```bash
git clone https://github.com/PS-Wizard/School
cd School/evaluator
cargo build --release
```

2. Enviroment
```
export TURSO_DATABASE_URL="..." // Enter your creds here
export TURSO_AUTH_TOKEN="..." // your creds here
export REDIS_URL="redis://127.0.0.1:6379" // your thing here
```

3. Run The Server
```
    cargo run --release
```

Server starts at `0.0.0.0:3000`. 

---

>[!INFO]
> ### API Documentation can be found inside the `tests/` folder of the project in `*.hurl` files

