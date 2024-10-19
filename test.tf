module "ssl_certificate_map" {
  source = "./modules/certificate_map"

  for_each = { for index, cert_map in local.ssl_cert_maps : cert_map.name => cert_map }

  ssl_certificate_map = {
    name         = each.value.name
    project_id   = each.value.project_id
    description  = each.value.description
    certificates = each.value.certificates
  }

  certificates = [for cert in each.value.certificates :
    {
      name              = cert.name
      domains           = cert.domains
      description       = cert.description
      dns_authorization = cert.dns_authorization
      location          = cert.location
  }]
}

locals { # for each domain in a cert, output the dns authorization as dns record
  dns_authorizations = flatten([for domain in module.ssl_certificate_map : domain.dns_authz])
}
