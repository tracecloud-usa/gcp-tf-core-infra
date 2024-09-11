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

module "cloudflare_dns" {
  source = "./modules/cloudflare"

  for_each = local.combined_dns_records

  name    = each.value.name
  zone    = each.value.zone
  type    = each.value.type
  content = each.value.content
  ttl     = each.value.ttl
}

module "cloud_dns" {
  source = "./modules/cloud_dns"

  for_each = { for k, v in local.cloud_dns_zones : v.hostname => v }

  domain     = trimsuffix(var.domain, ".us")
  project    = each.value.project
  hostname   = each.value.hostname
  visibility = each.value.visibility
  dns_name   = each.value.dns_name
}

