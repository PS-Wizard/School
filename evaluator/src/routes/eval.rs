use axum::{Json, extract::State};
use serde::{Deserialize, Serialize};
use tokio::io::{AsyncBufReadExt, AsyncWriteExt};

use crate::AppState;

#[derive(Deserialize)]
pub struct EvalRequest {
    pub fen: String,
}

#[derive(Serialize, Clone)]
pub struct EvalResponse {
    best_move: String,
    eval_cp: Option<i32>,
}

pub async fn evaluate(
    State(state): State<AppState>,
    Json(payload): Json<EvalRequest>,
) -> Json<EvalResponse> {
    {
        let cache = state.cache.lock().await;
        if let Some(cached) = cache.get(&payload.fen) {
            println!("Hit Cache");
            return Json(cached.clone());
        }
    }

    let mut stdin = state.stockfish_stdin.lock().await;
    let mut stdout = state.stockfish_stdout.lock().await;

    stdin
        .write_all(format!("position fen {}\n", payload.fen).as_bytes())
        .await
        .unwrap();
    stdin.write_all(b"go depth 15\n").await.unwrap();
    stdin.flush().await.unwrap();

    let mut best_move = String::new();
    let mut eval_cp: Option<i32> = None;
    let mut line = String::new();

    loop {
        line.clear();
        let bytes_read = stdout.read_line(&mut line).await.unwrap();
        if bytes_read == 0 {
            break;
        }

        if line.starts_with("info") && line.contains("score cp") {
            if let Some(cp_str) = line.split("score cp ").nth(1) {
                if let Some(cp_val) = cp_str.split_whitespace().next() {
                    if let Ok(v) = cp_val.parse::<i32>() {
                        eval_cp = Some(v);
                    }
                }
            }
        }

        if line.starts_with("bestmove") {
            best_move = line.split_whitespace().nth(1).unwrap_or("").to_string();
            break;
        }
    }

    let resp = EvalResponse { best_move, eval_cp };

    {
        let mut cache = state.cache.lock().await;
        cache.insert(payload.fen.clone(), resp.clone());
    }

    Json(resp)
}
