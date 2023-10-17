
################################################
#  Key Vault
################################################

locals {
  
  # Key Vault Policies Created Using IDs From Created Resources 

  current_subscription_kv_policy = {
    "${data.azurerm_client_config.current.object_id}" = {
      key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey"]
      secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
      certificate_permissions = ["Get", "List"]
    }
  }
}