resource "google_dns_managed_zone" "this" {
  name        = "${var.hostname}-${var.domain}-${var.visibility}"
  dns_name    = var.dns_name
  description = "Managed DNS zone for ${var.dns_name} - domain registered with Cloudflare"
  visibility  = var.visibility
  project     = var.project
}

output "nameservers" {
  value = google_dns_managed_zone.this.name_servers
}

variable "hostname" {
  type = string
}

variable "visibility" {
  type = string
}

variable "dns_name" {
  type = string
}

variable "project" {
  type = string
}

variable "domain" {
  type = string
}
