use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize, Serialize)]
pub struct User {
    pub id: u64,
    pub username: String,
    pub password_hash: String,
}
