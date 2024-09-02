variable "ssh_pub_key" {
  description = "SSH public key - stored in TFE"
  type        = string
}

variable "region" {
  description = "region to deploy secrets"
  type        = string
  default     = "us-east4"
}

variable "secrets" {
  description = "list of secrets to create"
  type = list(object({
    name    = string
    project = string
  }))
  default = []
}
