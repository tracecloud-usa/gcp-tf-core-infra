module "network" {
  source = "./modules/vpc"

  vpcs     = { for k, v in local.vpcs_definition["vpcs"] : v.name => v }
  peerings = { for k, v in local.vpcs_definition["peerings"] : k => v }
}

locals {
  definitions_dir = "${path.module}/definitions"
  vpcs_definition = yamldecode(file("${local.definitions_dir}/vpcs.yml"))

  routes                 = yamldecode(file("${local.definitions_dir}/fw.routes.yml"))["routes"]
  rules                  = yamldecode(file("${local.definitions_dir}/fw.rules.yml"))["rules"]
  secrets                = yamldecode(file("${local.definitions_dir}/secrets.yml"))["secrets"]
  cloudflare_dns_records = yamldecode(file("${local.definitions_dir}/cloudflare.dns_records.yml"))["dns_records"]
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

  for_each = { for k, v in local.cloudflare_dns_records : v.key => v }

  name    = each.value.name
  zone    = each.value.zone
  type    = each.value.type
  content = each.value.content
  ttl     = each.value.ttl
}
