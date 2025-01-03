provider "vault" {
  address = "http://vault.cloudaws.shop:8200"
  token = var.token
}

variable "token" {}

data "vault_generic_secret" "secret_data" {
  path = "test/dem-ssh"
}

resource "local_file" "secret" {
  filename = "/tmp/secret"
  content = replace(replace(jsonencode(data.vault_generic_secret.secret_data.data["password"]), "\"", ""), ":", "=")
}