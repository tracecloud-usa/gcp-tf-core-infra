variable "certificates" {
  type = list(object({
    name                         = string
    domains                      = list(string)
    description                  = optional(string)
    dns_authorization            = bool
    location                     = optional(string)
    auto_create_dns_auth_records = optional(bool)
  }))
}

variable "ssl_certificate_map" {
  type = object({
    name        = string
    project_id  = string
    description = optional(string)
  })
}

variable "dns_project" {
  description = "value of the project where the DNS records will be created"
  type        = string
}
