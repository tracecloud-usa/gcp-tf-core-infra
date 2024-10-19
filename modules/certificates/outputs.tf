output "dns_authz" {
  value = [
    for domain, authorization in google_certificate_manager_dns_authorization.this : {
      domain_name = domain
      record_name = authorization.dns_resource_record[0].name
      record_type = authorization.dns_resource_record[0].type
      record_data = authorization.dns_resource_record[0].data
      record_ttl  = "60"
    }
  ]
}



