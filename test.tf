module "ssl_certificate_map" {
  source = "./modules/ssl_cert_map"

  for_each = { for k, v in local.ssl_cert_maps : v.name => v }

  ssl_certificate_map = {
    name         = each.value.name
    project_id   = each.value.project_id
    description  = each.value.description
    certificates = each.value.certificates
  }

  certificates = [for cert in each.value.certificates : {
    name              = cert.name
    domains           = cert.domains
    description       = cert.description
    dns_authorization = cert.dns_authorization
    location          = cert.location
  }]
}
