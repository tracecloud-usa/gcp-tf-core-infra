terraform {
  required_version = ">=1.6.6"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=5.10.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">=5.10.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.40.0"
    }
  }
  cloud {
    organization = "tracecloud"
    hostname     = "app.terraform.io"

    workspaces {
      project = "main"
      name    = "gcp-tf-core-infra-network"
    }
  }
}

provider "google" {
}

provider "google-beta" {
}

data "google_secret_manager_secret_version" "this" {
  project = var.cloudflare_secret.project
  secret  = var.cloudflare_secret.name
}

provider "cloudflare" {
  api_token = data.google_secret_manager_secret_version.this.secret_data
}
