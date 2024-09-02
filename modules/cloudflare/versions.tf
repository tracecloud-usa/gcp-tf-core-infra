terraform {
  required_version = ">=1.6.6"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.40.0"
    }
    google = {
      source  = "hashicorp/google"
      version = ">=5.10.0"
    }
  }
  cloud {

    organization = "tracecloud"

    workspaces {
      name = "cloudflare-domain-mgmt"
    }
  }
}

provider "cloudflare" {
  # Configuration options
}

provider "google" {

}

