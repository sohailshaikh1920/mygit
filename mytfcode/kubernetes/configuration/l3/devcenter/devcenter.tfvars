

managed_identities = {
  devcenter_region1_usermsi = {
    name               = "p-we1devcenter-id"
    resource_group_key = "devcenter"
  }
}

role_mapping = {
  custom_role_mapping = {}

  built_in_role_mapping = {
    keyvaults = {
      devcenter = {
        "Key Vault Secrets User" = {
          # azuread_groups = {
          #   keys = ["aks_admins"]
          # }
          logged_in = {
            keys = ["user"]
          }
          managed_identities = {
            keys = ["devcenter_region1_usermsi"]
          }
        }
      }
    }
  }
}

keyvaults = {
  devcenter = {
    name                = "p-we1devcenter-kv"
    resource_group_key  = "devcenter"
    sku_name            = "premium"
    soft_delete_enabled = true
    purge_protection_enabled    = false
    enabled_for_disk_encryption = true

    creation_policies = {
      logged_in_user = {
        secret_permissions = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
      }
    }
  }
}

# DevEntironment Secrets for Catalog
dynamic_keyvault_secrets = {
  devcenter = { 
    github = {
      secret_name = "GithubPAT"
      value       = "Very@Str5ngP!44w0rdToChaNge#"
    }
  }
}

# Network Connection
network_connections = {
  devbox_aad_aks_networkconnection = {
    domainJoinType = "AzureADJoin"

    // Hybrid Options
    # domainName = "[parameters('domainName')]",
    # domainUsername = "[parameters('domainUsername')]",
    # domainPassword = "[parameters('domainPassword')]",
    # organizationUnit = "[parameters('organizationUnit')]"

    vnet_key = "aks_region1_vnet"
    subnet_key = "azure_bastion_subnet"
  }
}

# DevCenter
devcenters = {
  rg1_devcenter = {
    name = "p-we1devcenter"
    resource_group_key = "devcenter"
    identity = {
      # type = "SystemAssigned"
      type                 = "UserAssigned"
      managed_identity_key = "devcenter_region1_usermsi"
    }
    tags = {}

    catalogs = {
      # Microsoft.DevCenter/devcenters/catalogs@2023-04-01
      gitHub = {
        name = "Github"
        uri =  "https://github.com/Azure/deployment-environments.git"
        branch =  "main"
        path = "Environments"
        secretIdentifier = "https://p-we1devcenter-kv.vault.azure.net/secrets/GitHubPAT/9c3d9eaeb98c410f964e5b9d3f5c2c6d",
      }
    }

    environments = {
      # Microsoft.DevCenter/devcenters/environmentTypes@2023-04-01
      prod = {
        name = "Production"
        tags = {
          environment =  "Production"
        }
      }
      sandbox = {
        name = "Sandbox"
        tags = {
          environment =  "Sandbox"
        }
      }
    }

    network_connections = 

  }
}

# DevCenter Projects
devcenter_projects = {
  project_gemini = {
    # Microsoft.DevCenter/projects@2023-04-01
    name = "Gemini"
    description = "Project to identify the twins"
    resource_group_key  = "devcenter"
    devcenter_key = "rg1_devcenter"
    tags = {}
  }
}


# DevBox Defination
devbox = {}

# DevBox Pool
devbox_pools = {}
