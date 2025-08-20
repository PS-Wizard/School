**use std::process::Stdio;
use std::sync::Arc;
use tokio::io::BufReader;
use tokio::process::ChildStdin;
use tokio::process::ChildStdout;
use tokio::process::Command;
use tokio::sync::Mutex;

use axum::{
    Router,
    routing::{get, post},
};

use libsql::Builder;

use crate::{
    middleware::auth_middleware,
    routes::{
        auth::{login, sign_up},
        eval::evaluate,
    },
};

mod db;
mod middleware;
mod models;
mod routes;

#[allow(dead_code)]
#[derive(Clone)]
struct AppState {
    conn: libsql::Connection,
    stockfish_stdin: Arc<Mutex<ChildStdin>>,
    stockfish_stdout: Arc<Mutex<BufReader<ChildStdout>>>,
}

#[tokio::main]
async fn main() {
    // --- DB setup ---
    let url = std::env::var("TURSO_DATABASE_URL").expect("Turso DB URL Not Set");
    let token = std::env::var("TURSO_AUTH_TOKEN").expect("Turso DB Auth Token Not Set");

    let db = Builder::new_remote(url, token)
        .build()
        .await
        .expect("Failed To Connect To Remote");
    let conn = db.connect().expect("Failed To Connect To Remote");

    // --- Spawn Stockfish once ---
    let mut child = Command::new("stockfish")
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .spawn()
        .expect("Failed to spawn Stockfish");

    let stockfish_stdin = Arc::new(Mutex::new(child.stdin.take().unwrap()));
    let stockfish_stdout = Arc::new(Mutex::new(BufReader::new(child.stdout.take().unwrap())));

    let state = AppState {
        conn,
        stockfish_stdin,
        stockfish_stdout,
    };

    let protected_routes: Router<AppState> = Router::new()
        .route("/protected", get(|| async { "Protected af" }))
        .route("/eval", post(evaluate))
        .layer(axum::middleware::from_fn(auth_middleware));

    // --- App router ---
    let app = Router::new()
        .route("/", get(|| async { "Hello, World!" }))
        .route("/signup", post(sign_up))
        .route("/login", post(login))
        .merge(protected_routes)
        .with_state(state);

    // --- Start server ---
    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    axum::serve(listener, app).await.unwrap();
}
