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
