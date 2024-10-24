output "vpcs" {
  value = google_compute_network.this
}

output "subnets" {
  value = google_compute_subnetwork.this
}
