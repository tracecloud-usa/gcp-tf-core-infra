variable "ssh_pub_key" {
  description = "SSH public key - stored in TFE"
  type        = string
}

variable "cloudflare_secret" {
  type = object({
    name    = string
    project = string
  })
  default = {
    name    = "cloudflare-api-token"
    project = "trace-terraform-perm"
  }
}

variable "billing_account" {
  type = string
}

variable "perm_project" {
  type = string
}

variable "region" {
  type = string
}

variable "domain" {
  type = string
}

variable "org_id" {
  type = string
}
