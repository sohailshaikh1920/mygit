##################################################
#  Key vault Policies
##################################################

keyvault_access_policies = {
  "3c59943f-1a13-4369-907d-9712d9718f06" = { // Backup Management Service
    key_permissions         = ["Backup", "Get", "List"]
    secret_permissions      = ["Backup", "Get", "List"]
    certificate_permissions = []
  }
  "f9a888a9-c7a6-4aaa-912c-64398afd0372" = { // AZ RBAC sub p-we1mkt Owner
    key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
    secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
    certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"]
  }
  "10a09c90-027f-4cc4-9e4a-d78cb15abe1f" = { // AZ RBAC sub p-we1mkt Contributor
    key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
    secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
    certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"]
  }
  "1452d904-c7d0-4f6b-affc-8dd39bc76544" = { // AZ RBAC sub p-we1mkt Reader
    key_permissions         = ["Get", "List"]
    secret_permissions      = ["Get", "List"]
    certificate_permissions = ["Get", "List"]
  }
}
