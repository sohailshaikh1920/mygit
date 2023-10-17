module "dynamic_keyvault_secrets" {
  # source = "../aztfmod/modules/security/dynamic_keyvault_secrets"
  source = "git::https://github.com/innofactororg/terraform-azure-iac.git//modules/security/dynamic_keyvault_secrets?ref=fix-azurerm-355"

  for_each = {
    for keyvault_key, secrets in try(var.dynamic_keyvault_secrets, {}) : keyvault_key => {
      for key, value in secrets : key => value
      if try(value.value, null) == null
    }
  }

  settings = each.value
  keyvault = module.solution.keyvaults[each.key]
  objects  = module.solution
}