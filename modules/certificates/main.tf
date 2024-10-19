resource "google_certificate_manager_certificate" "this" {
  name        = var.ssl_certificate["name"]
  description = var.ssl_certificate["description"]
  project     = var.ssl_certificate["project_id"]
  location    = var.ssl_certificate["location"]

  managed {
    domains = var.ssl_certificate["domains"]
    dns_authorizations = [
      for domain in var.ssl_certificate["domains"] : google_certificate_manager_dns_authorization.this[domain].id
    ]
  }
}

resource "google_certificate_manager_certificate_map_entry" "this" {
  for_each = toset(var.ssl_certificate["domains"])

  project      = var.ssl_certificate["project_id"]
  name         = "${replace("${each.key}", ".", "-")}-cert-map-entry"
  description  = null
  map          = var.certificate_map
  certificates = [google_certificate_manager_certificate.this.id]
  hostname     = each.key
}


resource "google_certificate_manager_dns_authorization" "this" {
  for_each = toset(var.ssl_certificate["domains"])

  name        = "${replace("${each.key}", ".", "-")}-dns-auth"
  project     = var.ssl_certificate["project_id"]
  location    = try(var.ssl_certificate["location"], "global")
  description = "authorization for ${each.key} domain"
  domain      = each.key
}
