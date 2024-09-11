provider "cloudflare" {
  api_token = data.google_secret_manager_secret_version.this.secret_data
}

provider "google" {
}

provider "google-beta" {
}
