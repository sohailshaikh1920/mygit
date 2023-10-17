keyvaults = {

  # Jumpbox

  aks_jumpbox = {
    name                = "p-we1k8s-jump-box01-kv"
    resource_group_key  = "aks_jumpbox"
    sku_name            = "premium"
    soft_delete_enabled = true
    purge_protection_enabled    = false
    enabled_for_disk_encryption = true

    creation_policies = {
      logged_in_user = {
        secret_permissions = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
      }
      # aks_admins = {
      #   azuread_group_key  = "aks_admins"
      #   secret_permissions = ["Get", "List"]
      # }
    }

    # # you can setup up to 5 profiles
    # diagnostic_profiles = {
    #   operations = {
    #     definition_key   = "default_all"
    #     destination_type = "log_analytics"
    #     destination_key  = "central_logs"
    #   }
    # }

  }

  # AKS Cluster

  aks_cluster = {
    name                = "p-we1k8s-akscluster-kv"
    resource_group_key  = "aks"
    sku_name            = "premium"
    soft_delete_enabled = true
    purge_protection_enabled    = false
    enabled_for_disk_encryption = false

    creation_policies = {
      logged_in_user = {
        certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update" ]
        secret_permissions      = ["Set", "Get", "List", "Delete", "Purge"]
      }
      # aks_admins = {
      #   azuread_group_key  = "aks_admins"
      #   secret_permissions = ["Get", "List"]
      # }
    }


    # # you can setup up to 5 profiles
    # diagnostic_profiles = {
    #   operations = {
    #     definition_key   = "default_all"
    #     destination_type = "log_analytics"
    #     destination_key  = "central_logs"
    #   }
    # }

  }

}