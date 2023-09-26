
keyvaults = {
  level0 = {
    name                      = "p-iac-statelevel0-619-kv"
    resource_group_key        = "level0"
    sku_name                  = "standard"
    soft_delete_enabled       = true
    purge_protection_enabled  = false
    enable_rbac_authorization = true
    tags = {
      ## Those tags must never be changed after being set as they are used by the rover to locate the launchpad and the tfstates.
      # Only adjust the environment value at creation time
      tfstate     = "level0"
      environment = "power"
      launchpad   = "launchpad"
      ##
      workload = "ACF Platform"
      service  = "ACF State Management"
      purpose  = "This resource is part of core infrastructure. Do not delete."
    }

    creation_policies = {
      logged_in_user = {
        # if the key is set to "logged_in_user" add the user running terraform in the keyvault policy
        # More examples in /examples/keyvault
        secret_permissions = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
      }
    }
    network = {
      default_action = "Deny"
      bypass         = "AzureServices"
      ip_rules       = ["88.81.97.90"]
    }
    private_endpoints = {
      level0 = {
        name               = "p-iac-statelevel0-kv"
        resource_group_key = "level0"
        vnet_key           = "iac_network"
        subnet_key         = "level0"
        private_service_connection = {
          name                 = "p-iac-statelevel0-kv-link"
          is_manual_connection = false
          subresource_names    = ["vault"]
        }
        private_dns = {
          zone_group_name = "default"
          keys            = ["privatelink.vaultcore.azure.windows.net"]
        }
      }
    }
  }

  level1 = {
    name                      = "p-iac-statelevel1-619-kv"
    resource_group_key        = "level1"
    sku_name                  = "standard"
    soft_delete_enabled       = true
    purge_protection_enabled  = false
    enable_rbac_authorization = true
    tags = {
      ## Those tags must never be changed after being set as they are used by the rover to locate the launchpad and the tfstates.
      # Only adjust the environment value at creation time
      tfstate     = "level1"
      environment = "power"
      launchpad   = "launchpad"
      ##
      workload = "ACF Platform"
      service  = "ACF State Management"
      purpose  = "This resource is part of core infrastructure. Do not delete."
    }

    creation_policies = {
      logged_in_user = {
        # if the key is set to "logged_in_user" add the user running terraform in the keyvault policy
        # More examples in /examples/keyvault
        secret_permissions = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
      }
    }
    network = {
      default_action = "Deny"
      bypass         = "AzureServices"
      ip_rules       = ["88.81.97.90"]
    }
    private_endpoints = {
      level1 = {
        name               = "p-iac-statelevel1-kv"
        resource_group_key = "level1"
        vnet_key           = "iac_network"
        subnet_key         = "level1"
        private_service_connection = {
          name                 = "p-iac-statelevel1-kv-link"
          is_manual_connection = false
          subresource_names    = ["vault"]
        }
        private_dns = {
          zone_group_name = "default"
          keys            = ["privatelink.vaultcore.azure.windows.net"]
        }
      }
    }
  }

  level2 = {
    name                      = "p-iac-statelevel2-619-kv"
    resource_group_key        = "level2"
    sku_name                  = "standard"
    soft_delete_enabled       = true
    purge_protection_enabled  = false
    enable_rbac_authorization = true
    tags = {
      ## Those tags must never be changed after being set as they are used by the rover to locate the launchpad and the tfstates.
      # Only adjust the environment value at creation time
      tfstate     = "level2"
      environment = "power"
      launchpad   = "launchpad"
      ##
      workload = "ACF Platform"
      service  = "ACF State Management"
      purpose  = "This resource is part of core infrastructure. Do not delete."
    }

    creation_policies = {
      logged_in_user = {
        # if the key is set to "logged_in_user" add the user running terraform in the keyvault policy
        # More examples in /examples/keyvault
        secret_permissions = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
      }
    }
    network = {
      default_action = "Deny"
      bypass         = "AzureServices"
      ip_rules       = ["88.81.97.90"]
    }
    private_endpoints = {
      level0 = {
        name               = "p-iac-statelevel2-kv"
        resource_group_key = "level2"
        vnet_key           = "iac_network"
        subnet_key         = "level2"
        private_service_connection = {
          name                 = "p-iac-statelevel2-kv-link"
          is_manual_connection = false
          subresource_names    = ["vault"]
        }
        private_dns = {
          zone_group_name = "default"
          keys            = ["privatelink.vaultcore.azure.windows.net"]
        }
      }
    }
  }

  level3 = {
    name                      = "p-iac-statelevel3-619-kv"
    resource_group_key        = "level3"
    sku_name                  = "standard"
    soft_delete_enabled       = true
    purge_protection_enabled  = false
    enable_rbac_authorization = true
    tags = {
      ## Those tags must never be changed after being set as they are used by the rover to locate the launchpad and the tfstates.
      # Only adjust the environment value at creation time
      tfstate     = "level3"
      environment = "power"
      launchpad   = "launchpad"
      ##
      workload = "ACF Platform"
      service  = "ACF State Management"
      purpose  = "This resource is part of core infrastructure. Do not delete."
    }

    creation_policies = {
      logged_in_user = {
        # if the key is set to "logged_in_user" add the user running terraform in the keyvault policy
        # More examples in /examples/keyvault
        secret_permissions = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
      }
    }
    network = {
      default_action = "Deny"
      bypass         = "AzureServices"
      ip_rules       = ["88.81.97.90"]
    }
    private_endpoints = {
      level0 = {
        name               = "p-iac-statelevel3-kv"
        resource_group_key = "level3"
        vnet_key           = "iac_network"
        subnet_key         = "level3"
        private_service_connection = {
          name                 = "p-iac-statelevel3-kv-link"
          is_manual_connection = false
          subresource_names    = ["vault"]
        }
        private_dns = {
          zone_group_name = "default"
          keys            = ["privatelink.vaultcore.azure.windows.net"]
        }
      }
    }
  }

  level4 = {
    name                      = "p-iac-statelevel4-619-kv"
    resource_group_key        = "level4"
    sku_name                  = "standard"
    soft_delete_enabled       = true
    purge_protection_enabled  = false
    enable_rbac_authorization = true
    tags = {
      ## Those tags must never be changed after being set as they are used by the rover to locate the launchpad and the tfstates.
      # Only adjust the environment value at creation time
      tfstate     = "level4"
      environment = "power"
      launchpad   = "launchpad"
      ##
      workload = "ACF Platform"
      service  = "ACF State Management"
      purpose  = "This resource is part of core infrastructure. Do not delete."
    }

    creation_policies = {
      logged_in_user = {
        # if the key is set to "logged_in_user" add the user running terraform in the keyvault policy
        # More examples in /examples/keyvault
        secret_permissions = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
      }
    }
    network = {
      default_action = "Deny"
      bypass         = "AzureServices"
      ip_rules       = ["88.81.97.90"]
    }
    private_endpoints = {
      level4 = {
        name               = "p-iac-statelevel4-kv"
        resource_group_key = "level4"
        vnet_key           = "iac_network"
        subnet_key         = "level4"
        private_service_connection = {
          name                 = "p-iac-statelevel4-kv-link"
          is_manual_connection = false
          subresource_names    = ["vault"]
        }
        private_dns = {
          zone_group_name = "default"
          keys            = ["privatelink.vaultcore.azure.windows.net"]
        }
      }
    }
  }
}
