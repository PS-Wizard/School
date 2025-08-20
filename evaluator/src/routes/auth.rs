#![allow(dead_code)]

use std::time::Duration;

use argon2::{Argon2, PasswordHash, PasswordHasher, PasswordVerifier};
use axum::{Json, extract::State};
use chrono::Utc;
use jsonwebtoken::{EncodingKey, Header, encode};
use libsql::params;
use rand_core::OsRng;
use serde::{Deserialize, Serialize};

use crate::AppState;

#[derive(Deserialize)]
pub struct SignUpRequest {
    username: String,
    password: String,
}

pub async fn sign_up(State(state): State<AppState>, Json(payload): Json<SignUpRequest>) -> String {
    println!("New Signup Request for username: {}", payload.username);

    let salt = argon2::password_hash::SaltString::generate(&mut OsRng);
    let argon2 = Argon2::default();
    let password_hash = argon2
        .hash_password(payload.password.as_bytes(), &salt)
        .unwrap()
        .to_string();

    state
        .conn
        .execute(
            "INSERT INTO users (username, password_hash) VALUES (?1, ?2)",
            params![payload.username, password_hash],
        )
        .await
        .unwrap();

    "User created!".into()
}

#[derive(Deserialize)]
pub struct LoginRequest {
    username: String,
    password: String,
}

#[derive(Serialize, Deserialize)]
pub struct Claims {
    pub sub: String,
    pub exp: i64,
}

pub async fn login(State(state): State<AppState>, Json(payload): Json<LoginRequest>) -> String {
    println!("Login Request for username: {}", payload.username);

    let mut rows = state
        .conn
        .query(
            "SELECT username, password_hash FROM users WHERE username = ?1",
            params![payload.username],
        )
        .await
        .unwrap();

    let user = if let Some(row) = rows.next().await.unwrap() {
        (row.get::<String>(0).unwrap(), row.get::<String>(1).unwrap())
    } else {
        return "Invalid credentials".into();
    };

    let argon2 = Argon2::default();
    let parsed_hash = PasswordHash::new(&user.1).unwrap();
    if argon2
        .verify_password(payload.password.as_bytes(), &parsed_hash)
        .is_err()
    {
        return "Invalid credentials".into();
    }

    let expiration = Utc::now() + Duration::from_secs(3600);
    let claims = Claims {
        sub: user.0,
        exp: expiration.timestamp(),
    };

    let token = encode(
        &Header::default(),
        &claims,
        &EncodingKey::from_secret("super-duper-secret-69-lol".as_bytes()),
    )
    .unwrap();
    format!("{}", token)
}
