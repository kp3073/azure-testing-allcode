variable "first_name" {
  description = "First name for the Keycloak user"
  type        = string
}

variable "last_name" {
  description = "Last name for the Keycloak user"
  type        = string
}

variable "keycloak_url" {
  description = "Base URL of the Keycloak server (e.g. http://localhost:8080)"
  type        = string
  default     = "http://localhost:8080"
}

variable "keycloak_client_id" {
  description = "Keycloak client ID for Terraform access"
  type        = string
  default     = "terrafom-cli"
}

variable "keycloak_client_secret" {
  description = "Keycloak client secret for Terraform access"
  type        = string
  sensitive   = true
}

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    keycloak = {
      source  = "linz/keycloak"
      version = "4.4.1"
    }
  }
}

provider "keycloak" {
  client_id     = var.keycloak_client_id
  client_secret = var.keycloak_client_secret
  url           = var.keycloak_url
}
data "keycloak_realm" "realm" {
  realm = "master"
}

# Output the realm ID
output "realm_id" {
  value = data.keycloak_realm.realm.id
}

# Create a user in the master realm
resource "keycloak_user" "admin_user" {
  realm_id = data.keycloak_realm.realm.id
  username = join("-", [var.first_name, var.last_name])
  enabled  = true

  email      = "${join("-", [var.first_name, var.last_name])}@example.com"
  first_name = var.first_name
  last_name  = var.last_name
}

# Output the username
output "created_username" {
  value = keycloak_user.admin_user.username  # ❗ reference, not string
}