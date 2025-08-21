## Dynamic: ( Uncomment, if you're running fresh)

## Step 1: Login and capture token
#POST http://localhost:3000/login
#Content-Type: application/json
#{
#  "username": "wizard1",
#  "password": "secret123"
#}
#HTTP 200
#[Captures]
#auth_token: body
#
## Step 2: Use captured token for protected request
#POST http://localhost:3000/eval
#Authorization: {{auth_token}}
#{
#  "fen": "r1bqkbnr/pppppppp/n7/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 2 2"
#}

# Replace The Authorization Token With Whatever You Got
POST http://localhost:3000/eval
Authorization: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ3aXphcmQxIiwiZXhwIjoxNzU1NzUxMDQyfQ.TV4ga22Zyl0GFPPnEScE_2AGeoWV9Epex0MIhVruGww
{
  "fen": "rnbqkb1r/ppp1pppp/5n2/3p4/3P4/5N2/PPP1PPPP/RNBQKB1R w KQkq - 2 3"
}

