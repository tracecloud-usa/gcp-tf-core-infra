variable "certificates" {
  type = list(object({
    name              = string
    domains           = list(string)
    description       = optional(string)
    dns_authorization = bool
    location          = optional(string)
  }))
}

variable "ssl_certificate_map" {
  type = object({
    name        = string
    project_id  = string
    description = optional(string)
  })
}
