resource "google_certificate_manager_certificate_map" "this" {
  name        = var.ssl_certificate_map["name"]
  description = var.ssl_certificate_map["description"]
  project     = var.ssl_certificate_map["project_id"]
}

module "ssl_certificate" {
  source = "../certificates"

  for_each = { for index, cert in var.certificates : cert.name => cert }

  certificate_map = google_certificate_manager_certificate_map.this.name
  ssl_certificate = {
    name              = each.value.name
    domains           = each.value.domains
    description       = each.value.description
    dns_authorization = each.value.dns_authorization
    location          = each.value.location
    project_id        = var.ssl_certificate_map["project_id"]
  }
}



output "dns_authz" {
  value = [for certificate in module.ssl_certificate : certificate.dns_authz]
}
