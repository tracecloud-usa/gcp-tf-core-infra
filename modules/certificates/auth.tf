resource "google_certificate_manager_dns_authorization" "this" {
  for_each = toset(var.ssl_certificate["domains"])

  name        = "${replace("${each.key}", ".", "-")}-dns-auth"
  project     = var.ssl_certificate["project_id"]
  location    = try(var.ssl_certificate["location"], "global")
  description = "authorization for ${each.key} domain"
  domain      = each.key
}

resource "google_dns_record_set" "this" {
  for_each = { for domain, dns_auth in google_certificate_manager_dns_authorization.this : domain => dns_auth }

  name         = each.value.dns_resource_record[0].name
  managed_zone = data.google_dns_managed_zone.this[each.key].name
  project      = var.dns_project
  type         = each.value.dns_resource_record[0].type
  ttl          = 60

  rrdatas = [each.value.dns_resource_record[0].data]
}
