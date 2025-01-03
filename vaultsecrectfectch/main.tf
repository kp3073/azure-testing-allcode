provider "vault" {
  address = "http://vault.cloudaws.shop:8200"
  token = var.token
}

variable "token" {}

data "vault_kv_secret" "secret_data" {
  path = "test/data/dem-ssh"
}
output "secret_data" {
  value = data.vault_kv_secret.secret_data.data
}