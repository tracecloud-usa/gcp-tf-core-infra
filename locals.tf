locals {
  definitions_dir = "${path.module}/definitions"
  vpcs_definition = yamldecode(file("${local.definitions_dir}/vpcs.yml"))

  routes                 = yamldecode(file("${local.definitions_dir}/fw.routes.yml"))["routes"]
  rules                  = yamldecode(file("${local.definitions_dir}/fw.rules.yml"))["rules"]
  secrets                = yamldecode(file("${local.definitions_dir}/secrets.yml"))["secrets"]
  cloudflare_txt_records = yamldecode(file("${local.definitions_dir}/dns.cloudflare.yml"))["txt_records"]
  cloudflare_ns_records  = yamldecode(file("${local.definitions_dir}/dns.cloudflare.yml"))["ns_records"]
  cloud_dns_zones        = yamldecode(file("${local.definitions_dir}/dns.google.yml"))["zones"]
  cloud_dns_records      = yamldecode(file("${local.definitions_dir}/dns.google.yml"))["records"]
  storage_buckets        = yamldecode(file("${local.definitions_dir}/buckets.yml"))["buckets"]
  ssl_cert_maps          = yamldecode(file("${local.definitions_dir}/ssl_certs.yml"))["certificate_maps"]

  # dns_authorizations = flatten([for domain in module.ssl_certificate_map : domain.dns_authz])
  # dns_authorization_records = { for dns_auth in local.dns_authorizations : dns_auth.domain_name => {
  #   zone    = regex("^.*\\.([^.]+\\.[^.]+)$", dns_auth.domain_name)[0] # extract the tld from the fqdn
  #   content = dns_auth.record_data
  #   name    = dns_auth.record_name
  #   ttl     = dns_auth.record_ttl
  #   type    = dns_auth.record_type
  # } }

  edge_project = "vpc-edge-prod-01"

  cloudflare_dns = merge(
    { for k, v in local.cloudflare_txt_records : v.key => v },
  )

  cloudflare_ns_record_params = { for k, v in local.cloudflare_ns_records : v.host => v }

  # pull the nameserver records from the gcp managed dns zone if the hosts are listed in ns_records
  nameserver_records = [for host, zone in module.cloud_dns_zone : {
    for index, name_server in zone.nameservers : "${host}-nameserver-${index + 1}" => {
      name    = host
      ttl     = lookup(local.cloudflare_ns_record_params[host], "ttl", 1)
      type    = lookup(local.cloudflare_ns_record_params[host], "type", "NS")
      zone    = trimsuffix(lookup(local.cloudflare_ns_record_params[host], "zone", var.domain), ".")
      content = trimsuffix(name_server, ".")
    }
    } if contains(keys(local.cloudflare_ns_record_params), host)
  ]

  google_ns_cloudflare_records = merge(
    [for k, v in local.nameserver_records : v]...
  )
}

