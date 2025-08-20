use crate::routes::auth::Claims;
use axum::{
    Json,
    http::{Request, StatusCode},
    middleware::Next,
    response::{IntoResponse, Response},
};
use jsonwebtoken::{DecodingKey, Validation, decode};

pub async fn auth_middleware(mut req: Request<axum::body::Body>, next: Next) -> Response {
    let auth_header = match req
        .headers()
        .get("Authorization")
        .and_then(|h| h.to_str().ok())
    {
        Some(header) => header,
        None => {
            return (StatusCode::UNAUTHORIZED, Json("brudda, need authorization")).into_response();
        }
    };

    let token_data = match decode::<Claims>(
        auth_header,
        &DecodingKey::from_secret("super-duper-secret-69-lol".as_bytes()),
        &Validation::default(),
    ) {
        Ok(data) => data,
        Err(_) => {
            return (StatusCode::UNAUTHORIZED, Json("brudda, token invalid")).into_response();
        }
    };

    req.extensions_mut().insert(token_data.claims.sub);

    next.run(req).await
}
