module "vpcs" {
  source = "./modules/vpc"

  vpcs = local.vpcs
}

locals {
  definitions_dir      = "${path.module}/definitions"
  vpcs_definition_file = file("${local.definitions_dir}/vpcs.yml")
  vpcs_definition      = yamldecode(local.vpcs_definition_file)
  vpcs                 = { for k, v in local.vpcs_definition["vpcs"] : v.name => v }
}
