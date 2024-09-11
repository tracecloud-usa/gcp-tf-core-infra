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
  cloudflare_dns_records = yamldecode(file("${local.definitions_dir}/dns.cloudflare.yml"))["txt_records"]
  cloud_dns_zones        = yamldecode(file("${local.definitions_dir}/dns.google.yml"))["zones"]
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

locals {
  google_ns_records    = merge(local.nameservers["test"], local.nameservers["ai"])
  cloudflare_dns       = { for k, v in local.cloudflare_dns_records : v.key => v }
  combined_dns_records = merge(local.cloudflare_dns, local.google_ns_records)
  trimmed_domain       = trimsuffix(var.domain, ".")

  nameservers = merge(
    { for k, v in module.cloud_dns : k => {
      for index, value in v.nameservers : "${k}-nameserver-${index + 1}" => {
        name    = k
        ttl     = 1
        type    = "NS"
        zone    = local.trimmed_domain
        content = trimsuffix(value, ".")
      }
      }
    }
  )
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

