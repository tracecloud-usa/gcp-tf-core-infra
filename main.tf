module "network" {
  source = "./modules/vpc"

  vpcs     = { for k, v in local.vpcs_definition["vpcs"] : v.name => v }
  peerings = { for k, v in local.vpcs_definition["peerings"] : k => v }
}

module "firewall" {
  source = "./modules/firewall"

  firewall_rules  = local.rules
  firewall_routes = local.routes
}

module "secrets" {
  source = "./modules/secrets"

  for_each = { for k, v in local.secrets : k => v }

  name    = each.value.name
  project = each.value.project
  region  = each.value.region
}

module "cloudflare_dns_records" {
  source = "./modules/cloudflare"

  for_each = merge(
    local.cloudflare_dns,
    local.google_ns_cloudflare_records,
  )

  name    = each.value.name
  zone    = each.value.zone
  type    = each.value.type
  content = each.value.content
  ttl     = each.value.ttl
}

module "cloud_dns_zone" { # create a managed dns zone for each hostname
  source = "./modules/cloud_dns"

  for_each = { for k, v in local.cloud_dns_zones : v.hostname => v }

  domain     = trimsuffix(var.domain, ".us")
  project    = each.value.project
  hostname   = each.value.hostname
  visibility = each.value.visibility
  dns_name   = each.value.dns_name
}

module "bucket" {
  source = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"

  version = "~> 6.1"

  for_each = { for k, v in local.storage_buckets : v.name => v }

  name       = each.key
  project_id = each.value.project
  location   = each.value.location

  lifecycle_rules = each.value.lifecycle_rules

  iam_members = [{
    role   = "roles/storage.objectViewer"
    member = "serviceAccount:${data.google_client_openid_userinfo.this.email}"
  }]

  autoclass  = each.value.autoclass
  encryption = each.value.encryption
}
