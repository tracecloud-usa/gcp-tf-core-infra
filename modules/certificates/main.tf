data "google_dns_managed_zones" "this" {
  project = var.dns_project
}

data "google_dns_managed_zone" "this" {
  for_each = toset(var.ssl_certificate["domains"])
  name     = lookup(local.managed_zones, each.key, null)
  project  = var.dns_project

}

locals {
  managed_zones = {
    for k, v in data.google_dns_managed_zones.this.managed_zones : trimsuffix(v.dns_name, ".") => v.name
  }
}

