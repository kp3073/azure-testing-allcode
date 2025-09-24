# resource "restapi_object" "kc_user" {
#   path        = "/users"
#   create_path = "/users"
#   read_path   = "/users?username=tfuser1"
#   id_attribute = "0/id"  # First object in array, "id" key
#   data        = <<JSON
# {
#   "username": "tfuser1",
#   "enabled": true,
#   "firstName": "Terraform",
#   "lastName": "User",
#   "email": "tfuser1@example.com"
# }
# JSON
# }
