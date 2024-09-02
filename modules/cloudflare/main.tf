module "secrets" {
  source = "../modules/secrets"

  for_each = { for k, v in var.secrets : k => v }

  name    = each.value.name
  project = each.value.project
  region  = var.region
}
