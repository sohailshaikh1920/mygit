
storage_accounts = {
  level0 = {
    name                     = "p-iac-statelevel0-pwr"
    resource_group_key       = "level0"
    account_kind             = "BlobStorage"
    account_tier             = "Standard"
    shared_access_key_enabled = false
    account_replication_type = "GRS"
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
    blob_properties = {
      versioning_enabled                = true
      last_access_time_enabled          = true
            container_delete_retention_policy = {
        days = 7
      }
      delete_retention_policy = {
        days = 7
      }
    }
    containers = {
      tfstate = {
        name = "tfstate"
      }
    }
  }


  level1 = {
    name                     = "p-iac-statelevel1-pwr"
    resource_group_key       = "level1"
    account_kind             = "BlobStorage"
    account_tier             = "Standard"
    shared_access_key_enabled = false
    account_replication_type = "GRS"
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
    blob_properties = {
      versioning_enabled                = true
      last_access_time_enabled          = true
            container_delete_retention_policy = {
        days = 7
      }
      delete_retention_policy = {
        days = 7
      }
    }
    containers = {
      tfstate = {
        name = "tfstate"
      }
    }
  }

  level2 = {
    name                     = "p-iac-statelevel2-pwr"
    resource_group_key       = "level2"
    account_kind             = "BlobStorage"
    account_tier             = "Standard"
    shared_access_key_enabled = false
    account_replication_type = "GRS"
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
    blob_properties = {
      versioning_enabled                = true
      last_access_time_enabled          = true
            container_delete_retention_policy = {
        days = 7
      }
      delete_retention_policy = {
        days = 7
      }
    }
    containers = {
      tfstate = {
        name = "tfstate"
      }
    }
  }

  level3 = {
    name                     = "p-iac-statelevel3-pwr"
    resource_group_key       = "level3"
    account_kind             = "BlobStorage"
    account_tier             = "Standard"
    shared_access_key_enabled = false
    account_replication_type = "GRS"
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
    blob_properties = {
      versioning_enabled                = true
      last_access_time_enabled          = true
            container_delete_retention_policy = {
        days = 7
      }
      delete_retention_policy = {
        days = 7
      }
    }
    containers = {
      tfstate = {
        name = "tfstate"
      }
    }
  }

  level4 = {
    name                     = "p-iac-statelevel4-pwr"
    resource_group_key       = "level4"
    account_kind             = "BlobStorage"
    account_tier             = "Standard"
    shared_access_key_enabled = false
    account_replication_type = "GRS"
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
    blob_properties = {
      versioning_enabled                = true
      last_access_time_enabled          = true
            container_delete_retention_policy = {
        days = 7
      }
      delete_retention_policy = {
        days = 7
      }
    }
    containers = {
      tfstate = {
        name = "tfstate"
      }
    }

  }

}