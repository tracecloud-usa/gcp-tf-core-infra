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
      version = "4.44.0"
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
