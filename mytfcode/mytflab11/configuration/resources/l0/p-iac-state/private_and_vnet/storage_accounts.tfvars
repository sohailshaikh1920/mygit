
storage_accounts = {
  level0 = {
    name                     = "p-iac-statelevel0-pwr"
    resource_group_key       = "level0"
    account_kind             = "BlobStorage"
    account_tier             = "Standard"
    shared_access_key_enabled = false
    account_replication_type = "GRS"
    tags = {
      tfstate     = "level0"
      environment = "opus"
      launchpad   = "launchpad"
    }
    blob_properties = {
      versioning_enabled                = true
      last_access_time_enabled = true
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
    network = {
      default_action = "Deny"
      bypass         = ["Logging", "Metrics", "AzureServices"]
      ip_rules       = ["88.81.97.90"]
    }

    private_endpoints = {
      level0 = {
        name               = "p-iac-statelevel0-stg"
        resource_group_key = "level0"
        vnet_key           = "iac_network"
        subnet_key         = "level0"
        private_service_connection = {
          name                 = "p-iac-statelevel0-stg-link"
          is_manual_connection = false
          subresource_names    = ["blob"]
        }
        private_dns = {
          zone_group_name = "default"
          keys            = ["privatelink.blob.core.windows.net"]
        }
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
      tfstate     = "level1"
      environment = "opus"
      launchpad   = "launchpad"
    }
    blob_properties = {
      versioning_enabled                = true
      last_access_time_enabled = true
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
    network = {
      default_action = "Deny"
      bypass         = ["Logging", "Metrics", "AzureServices"]
      ip_rules       = ["88.81.97.90"]
    }
  
    private_endpoints = {
      level1 = {
        name               = "p-iac-statelevel1-stg"
        resource_group_key = "level1"
        vnet_key           = "iac_network"
        subnet_key         = "level1"
        private_service_connection = {
          name                 = "p-iac-statelevel1-stg-link"
          is_manual_connection = false
          subresource_names    = ["blob"]
        }
        private_dns = {
          zone_group_name = "default"
          keys            = ["privatelink.blob.core.windows.net"]
        }
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
      tfstate     = "level2"
      environment = "opus"
      launchpad   = "launchpad"
    }
    blob_properties = {
      versioning_enabled                = true
      last_access_time_enabled = true
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
    network = {
      default_action = "Deny"
      bypass         = ["Logging", "Metrics", "AzureServices"]
      ip_rules       = ["88.81.97.90"]
    }

    private_endpoints = {
      level2 = {
        name               = "p-iac-statelevel2-stg"
        resource_group_key = "level2"
        vnet_key           = "iac_network"
        subnet_key         = "level2"
        private_service_connection = {
          name                 = "p-iac-statelevel2-stg-link"
          is_manual_connection = false
          subresource_names    = ["blob"]
        }
        private_dns = {
          zone_group_name = "default"
          keys            = ["privatelink.blob.core.windows.net"]
        }
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
      tfstate     = "level3"
      environment = "opus"
      launchpad   = "launchpad"
    }
    blob_properties = {
      versioning_enabled                = true
      last_access_time_enabled = true
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
    network = {
      default_action = "Deny"
      bypass         = ["Logging", "Metrics", "AzureServices"]
      ip_rules       = ["88.81.97.90"]
    }

    private_endpoints = {
      level3 = {
        name               = "p-iac-statelevel3-stg"
        resource_group_key = "level3"
        vnet_key           = "iac_network"
        subnet_key         = "level3"
        private_service_connection = {
          name                 = "p-iac-statelevel3-stg-link"
          is_manual_connection = false
          subresource_names    = ["blob"]
        }
        private_dns = {
          zone_group_name = "default"
          keys            = ["privatelink.blob.core.windows.net"]
        }
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
      tfstate     = "level4"
      environment = "opus"
      launchpad   = "launchpad"
      ##
    }
    blob_properties = {
      versioning_enabled                = true
      last_access_time_enabled = true
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
    network = {
      default_action = "Deny"
      bypass         = ["Logging", "Metrics", "AzureServices"]
      ip_rules       = ["88.81.97.90"]
    }

    private_endpoints = {
      level4 = {
        name               = "p-iac-statelevel4-stg"
        resource_group_key = "level4"
        vnet_key           = "iac_network"
        subnet_key         = "level4"
        private_service_connection = {
          name                 = "p-iac-statelevel4-stg-link"
          is_manual_connection = false
          subresource_names    = ["blob"]
        }
        private_dns = {
          zone_group_name = "default"
          keys            = ["privatelink.blob.core.windows.net"]
        }
      }
    }
  }

}