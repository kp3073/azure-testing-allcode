provider "vault" {
  address = "http://vault.cloudaws.shop:8200"
  token = var.token
}

variable "token" {}

data "vault_generic_secret" "secret_data" {
  path = "infra/ssh"
}

resource "local_file" "secret" {
  filename = "infra/ssh"
  content = replace(replace(jsonencode(data.vault_generic_secret.secret_data.data["admin_username"]), "\"", ""), ":", "=")
}
