resource "google_certificate_manager_certificate_map" "this" {
  name        = var.ssl_certificate_map["name"]
  description = var.ssl_certificate_map["description"]
  project     = var.ssl_certificate_map["project_id"]
}

module "ssl_certificate" {
  source = "../certificates"

  for_each = { for index, cert in var.certificates : cert.name => cert }

  ssl_certificate = {
    name              = each.value.name
    domains           = each.value.domains
    description       = each.value.description
    dns_authorization = each.value.dns_authorization
    location          = each.value.location
    project_id        = var.ssl_certificate_map["project_id"]
  }
}

# resource "google_certificate_manager_certificate_map_entry" "this" {
#   project      = var.project_id
#   name         = "certmgr-map-entry-web1"
#   description  = "My test certificate map entry"
#   map          = google_certificate_manager_certificate_map.certificate_map.name
#   certificates = [google_certificate_manager_certificate.all.id]
#   hostname     = "test.example.com"
# }


output "dns_authz" {
  value = { for certificates, certificate in module.ssl_certificate : certificates => certificate.dns_authz }
}
