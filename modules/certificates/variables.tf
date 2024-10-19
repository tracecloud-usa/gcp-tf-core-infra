variable "ssl_certificate" {
  description = "The SSL certificate to create"
  type = object({
    name                         = string
    domains                      = list(string)
    description                  = optional(string)
    dns_authorization            = bool
    location                     = optional(string)
    project_id                   = string
    auto_create_dns_auth_records = optional(bool)
  })
}

variable "certificate_map" {
  type = string
}

variable "dns_project" {
  description = "value of the project where the DNS records will be created"
  type        = string
}
