variable "ssl_certificate" {
  description = "The SSL certificate to create"
  type = object({
    name              = string
    domains           = list(string)
    description       = optional(string)
    dns_authorization = bool
    location          = optional(string)
    project_id        = string
  })

}

variable "certificate_map" {
  type = string
}
