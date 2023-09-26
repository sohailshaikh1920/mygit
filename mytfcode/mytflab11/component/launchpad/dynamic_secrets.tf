
module "dynamic_keyvault_secrets" {
  //source = "../aztfmod/modules/security/dynamic_keyvault_secrets"
  # source = "git::https://github.com/innofactororg/azure-iac-tf.git//modules/security/dynamic_keyvault_secrets?ref=inno-main"
  # source = "git::https://github.com/innofactororg/azure-iac-tf.git//modules/security/dynamic_keyvault_secrets?ref=v20230505"
  # source = "git::https://github.com/innofactororg/azure-iac-tf.git//modules/security/dynamic_keyvault_secrets?ref=inno-main-sentinel"
  source = "git::https://github.com/innofactororg/terraform-azure-iac.git//modules/security/dynamic_keyvault_secrets?ref=main"
  
  for_each = try(var.dynamic_keyvault_secrets, {})

  settings = each.value
  keyvault = module.launchpad.keyvaults[each.key]
  objects  = module.launchpad
}
