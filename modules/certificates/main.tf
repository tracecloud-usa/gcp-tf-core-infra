locals {
  dns_authorization_records = {
    for domain, authorization in google_certificate_manager_dns_authorization.this : domain => {
      record_name = authorization.dns_resource_record[0].name
      record_type = authorization.dns_resource_record[0].type
      record_data = authorization.dns_resource_record[0].data
      record_ttl  = "60"
    }
  }
}

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

# module "cloudflare_dns" {
#   source = "./modules/cloudflare"

#   for_each = local.combined_dns_records

#   name    = each.value.name
#   zone    = each.value.zone
#   type    = each.value.type
#   content = each.value.content
#   ttl     = each.value.ttl
# }
