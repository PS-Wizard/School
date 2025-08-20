POST http://localhost:3000/login
{
  "username": "wizard1",
  "password": "secret123"
}

# This Should Fail
# POST http://localhost:3000/login
# {
#   "username": "wizard1",
#   "password": "someincorrectpass"
# }
