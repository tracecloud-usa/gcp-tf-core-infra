output "nameservers" {
  value = google_dns_managed_zone.this.name_servers
}
