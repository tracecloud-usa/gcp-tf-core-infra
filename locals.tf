locals {
  definitions_dir = "${path.module}/definitions"
  vpcs_definition = yamldecode(file("${local.definitions_dir}/vpcs.yml"))

  routes                 = yamldecode(file("${local.definitions_dir}/fw.routes.yml"))["routes"]
  rules                  = yamldecode(file("${local.definitions_dir}/fw.rules.yml"))["rules"]
  secrets                = yamldecode(file("${local.definitions_dir}/secrets.yml"))["secrets"]
  cloudflare_dns_records = yamldecode(file("${local.definitions_dir}/dns.cloudflare.yml"))["txt_records"]
  cloud_dns_zones        = yamldecode(file("${local.definitions_dir}/dns.google.yml"))["zones"]
  storage_buckets        = yamldecode(file("${local.definitions_dir}/buckets.yml"))["buckets"]
  ssl_cert_maps          = yamldecode(file("${local.definitions_dir}/ssl_certs.yml"))["certificate_maps"]

  dns_authorizations = flatten([for domain in module.ssl_certificate_map : domain.dns_authz])
  dns_authorization_records = { for dns_auth in local.dns_authorizations : dns_auth.domain_name => {
    zone    = regex("^.*\\.([^.]+\\.[^.]+)$", dns_auth.domain_name)[0] # extract the tld from the fqdn
    content = dns_auth.record_data
    name    = dns_auth.record_name
    ttl     = dns_auth.record_ttl
    type    = dns_auth.record_type
  } }

  google_ns_records = merge(local.nameservers["test"], local.nameservers["ai"])
  cloudflare_dns    = { for k, v in local.cloudflare_dns_records : v.key => v }

  nameservers = merge(
    { for k, v in module.cloud_dns : k => {
      for index, value in v.nameservers : "${k}-nameserver-${index + 1}" => {
        name    = k
        ttl     = 1
        type    = "NS"
        zone    = trimsuffix(var.domain, ".")
        content = trimsuffix(value, ".")
      }
      }
    }
  )
}
