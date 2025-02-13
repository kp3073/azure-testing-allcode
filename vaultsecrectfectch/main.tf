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


# app_name =$1
# env = $2
# 
# export PATH = /github-runner/.local/bin : /github-runner/bin: /usr/local/bin : /usr/bin : /usr/local/sbin :/usr/sbin
# 
# if [
# -z "$app_name" -o -z "$env"
# ]; then
# echo Input AppName or env is missing
# exit 1
# fi
# 
# # If not logged in we will login
# argocd account list &>/dev/null
# if [$ ? -ne 0]; then
# argocd_ip = $(kubectl get svc -n argocd argocd-server -o jsonpath= '{.status.loadBalancer.ingress[0].ip}')
# argocd_password = $(kubectl get secret argocd-initial-admin-secret -n argocd -o = jsonpath = '{.data.password}' | base64 --decode)
# argocd login ${argocd_ip} --insecure --username admin --password ${argocd_password}
# fi
# 
# argocd app create ${app_name} --repo https : //github.com/raghudevopsb82/roboshop-helm.git --dest-namespace default --dest-server https://kubernetes.default.svc --values env-${env}/${app_name}.yaml  --path .
# argocd app sync ${app_name}