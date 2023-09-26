
keyvaults = {
  level0 = {
    name                = "p-iac-statelevel0-pwr-kv"
    resource_group_key  = "level0"
    sku_name            = "standard"
    soft_delete_enabled = true
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
      service = "ACF State Management"
      purpose =  "This resource is part of core infrastructure. Do not delete."
    }

    creation_policies = {
      logged_in_user = {
        # if the key is set to "logged_in_user" add the user running terraform in the keyvault policy
        # More examples in /examples/keyvault
        secret_permissions = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
      }
    }

  }

  level1 = {
    name                = "p-iac-statelevel1-pwr-kv"
    resource_group_key  = "level1"
    sku_name            = "standard"
    soft_delete_enabled = true
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
      service = "ACF State Management"
      purpose =  "This resource is part of core infrastructure. Do not delete."
    }
    
    creation_policies = {
      logged_in_user = {
        # if the key is set to "logged_in_user" add the user running terraform in the keyvault policy
        # More examples in /examples/keyvault
        secret_permissions = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
      }
    }
  }

  level2 = {
    name                = "p-iac-statelevel2-pwr-kv"
    resource_group_key  = "level2"
    sku_name            = "standard"
    soft_delete_enabled = true
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
      service = "ACF State Management"
      purpose =  "This resource is part of core infrastructure. Do not delete."
    }
    
    creation_policies = {
      logged_in_user = {
        # if the key is set to "logged_in_user" add the user running terraform in the keyvault policy
        # More examples in /examples/keyvault
        secret_permissions = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
      }
    }
  }

  level3 = {
    name                = "p-iac-statelevel3-pwr-kv"
    resource_group_key  = "level3"
    sku_name            = "standard"
    soft_delete_enabled = true
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
      service = "ACF State Management"
      purpose =  "This resource is part of core infrastructure. Do not delete."
    }
    
    creation_policies = {
      logged_in_user = {
        # if the key is set to "logged_in_user" add the user running terraform in the keyvault policy
        # More examples in /examples/keyvault
        secret_permissions = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
      }
    }
  }

  level4 = {
    name                = "p-iac-statelevel4-pwr-kv"
    resource_group_key  = "level4"
    sku_name            = "standard"
    soft_delete_enabled = true
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
      service = "ACF State Management"
      purpose =  "This resource is part of core infrastructure. Do not delete."
    }
    
    creation_policies = {
      logged_in_user = {
        # if the key is set to "logged_in_user" add the user running terraform in the keyvault policy
        # More examples in /examples/keyvault
        secret_permissions = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
      }
    }
  }
}
