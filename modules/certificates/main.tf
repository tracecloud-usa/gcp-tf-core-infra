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

resource "google_certificate_manager_dns_authorization" "this" {
  for_each = toset(var.ssl_certificate["domains"])

  name        = "${replace("${each.key}", ".", "-")}-dns-auth"
  project     = var.ssl_certificate["project_id"]
  location    = try(var.ssl_certificate["location"], "global")
  description = "authorization for ${each.key} domain"
  domain      = each.key
}

output "dns_authz" {
  value = { for domain, authorization in google_certificate_manager_dns_authorization.this : domain => authorization }
}
