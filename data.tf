data "google_secret_manager_secret_version" "this" {
  project = var.cloudflare_secret.project
  secret  = var.cloudflare_secret.name
}

data "google_client_openid_userinfo" "this" {
}
