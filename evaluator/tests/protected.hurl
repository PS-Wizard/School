# Step 1: Login and capture token
POST http://localhost:3000/login
Content-Type: application/json
{
  "username": "wizard1",
  "password": "secret123"
}
HTTP 200
[Captures]
auth_token: body

# Step 2: Use captured token for protected request
GET http://localhost:3000/protected
Authorization: {{auth_token}}
HTTP 200

# # Step 3:  This should fail
# GET http://localhost:3000/protected
# Authorization: none
