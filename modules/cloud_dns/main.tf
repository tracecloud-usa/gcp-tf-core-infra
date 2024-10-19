resource "google_dns_managed_zone" "this" {
  name        = "${var.hostname}-${var.domain}-${var.visibility}"
  dns_name    = var.dns_name
  description = "Managed DNS zone for ${var.dns_name} - domain registered with Cloudflare"
  visibility  = var.visibility
  project     = var.project
}

resource "google_dns_record_set" "this" {
  for_each = { for k, v in var.dns_records : v.name => v }

  name         = each.value.name
  managed_zone = google_dns_managed_zone.this.name
  project      = var.project
  type         = each.value.type
  ttl          = each.value.ttl

  rrdatas = [each.value.content]
}

variable "dns_records" {
  type = list(object({
    name    = string
    ttl     = number
    type    = string
    content = string
  }))
}
