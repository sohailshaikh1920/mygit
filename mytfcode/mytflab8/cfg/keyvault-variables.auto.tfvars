##################################################
#  Key vault Policies
##################################################

keyvault_access_policies = {

  /*

 "3c59943f-1a13-4369-907d-9712d9718f06" = { // Backup Management Service
    key_permissions         = ["Backup", "Get", "List"]
    secret_permissions      = ["Backup", "Get", "List"]
    certificate_permissions = []
  }

  */

  "b76c262d-e368-425b-b9d3-f48249d3444e" = { // AZ RBAC sub p-we1gnx Owner
    key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
    secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
    certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"]
  }
  "53bfe47b-a9c9-4c8f-a87e-94c16944c1f3" = { // AZ RBAC sub p-we1gnx Contributor
    key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
    secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
    certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"]
  }
  "e1e3b3f0-75de-4912-babd-91221ecc22e7" = { // AZ RBAC sub p-we1gnx Reader
    key_permissions         = ["Get", "List"]
    secret_permissions      = ["Get", "List"]
    certificate_permissions = ["Get", "List"]
  }

  
  "a2d62fcc-72df-44d8-adb4-68977fa7ede6" = { // Plan 1 Function App 1
    key_permissions         = ["Get", "List"]
    secret_permissions      = ["Get", "List"]
    certificate_permissions = []
  } 

}
