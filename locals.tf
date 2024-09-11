locals {
  definitions_dir = "${path.module}/definitions"
  vpcs_definition = yamldecode(file("${local.definitions_dir}/vpcs.yml"))

  routes                 = yamldecode(file("${local.definitions_dir}/fw.routes.yml"))["routes"]
  rules                  = yamldecode(file("${local.definitions_dir}/fw.rules.yml"))["rules"]
  secrets                = yamldecode(file("${local.definitions_dir}/secrets.yml"))["secrets"]
  cloudflare_dns_records = yamldecode(file("${local.definitions_dir}/dns.cloudflare.yml"))["txt_records"]
  cloud_dns_zones        = yamldecode(file("${local.definitions_dir}/dns.google.yml"))["zones"]

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
