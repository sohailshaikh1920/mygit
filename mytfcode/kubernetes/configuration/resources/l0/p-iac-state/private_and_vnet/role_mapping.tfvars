role_mapping = {
  built_in_role_mapping = {
    management_group = {
      "vdcroot" = {
        "User Access Administrator" = {
          azuread_groups = {
            keys = ["level0"]
          }
        }
        "Management Group Contributor" = {
          azuread_groups = {
            keys = ["alz", "acf_platform_maintainers"]
          }
        }
        "Owner" = {
          azuread_groups = {
            keys = ["alz", "acf_platform_maintainers"]
          }
        }
        "Contributor" = {
          azuread_groups = {
            # keys = ["identity", "management", "security"]
            keys = ["management"]
          }
        }
        "Reader" = {
          azuread_groups = {
            keys = ["acf_platform_contributors"]
          }
        }
      }
    }
    subscriptions = {
      "logged_in_subscription" = {
        "Owner" = {
          azuread_groups = {
            # keys = ["level0", "subscription_creation_platform", "acf_platform_maintainers"]
            keys = ["level0", "acf_platform_maintainers"]
          }
        }
        "Reader" = {
          azuread_groups = {
            # keys = ["identity"]
            keys = []
          }
        }
      }
    }
    resource_groups = {
      "level0" = {
        "Reader" = {
          azuread_groups = {
            # keys = ["identity", "subscription_creation_platform", "acf_platform_contributors"]
            keys = ["acf_platform_contributors"]
          }
        }
      }
      "level1" = {
        "Reader" = {
          azuread_groups = {
            # keys = ["identity", "management", "connectivity", "alz", "security", "subscription_creation_platform", "acf_platform_contributors"]
            keys = [ "management", "connectivity", "alz", "acf_platform_contributors"]
          }
        }
      }
      "level2" = {
        "Reader" = {
          azuread_groups = {
            # keys = ["identity", "management", "connectivity", "security", "subscription_creation_platform", "acf_platform_contributors"]
            keys = ["management", "connectivity", "acf_platform_contributors"]
          }
        }
      }
      "level3" = {
        "Reader" = {
          azuread_groups = {
            # keys = ["identity", "management", "connectivity", "security", "subscription_creation_platform", "acf_platform_contributors"]
            keys = ["management", "connectivity", "acf_platform_contributors"]
          }
        }
      }
      "level4" = {
        "Reader" = {
          azuread_groups = {
            # keys = ["identity", "management", "connectivity", "security", "subscription_creation_platform", "acf_platform_contributors"]
            keys = [ "management", "connectivity", "acf_platform_contributors"]
          }
        }
      }
    }
    storage_accounts = {
      "level0" = {
        "Storage Blob Data Contributor" = {
          azuread_groups = {
            # keys = ["level0", "identity", "acf_platform_maintainers"]
            keys = ["level0", "acf_platform_maintainers"]
          }
        }
        "Storage Blob Data Reader" = {
          azuread_groups = {
            # keys = ["management", "alz", "security", "subscription_creation_platform", "acf_platform_contributors"]
            keys = ["management", "alz", "acf_platform_contributors"]
          }
        }
      }
      "level1" = {
        "Storage Blob Data Contributor" = {
          azuread_groups = {
            # keys = ["acf_platform_maintainers", "identity", "management", "alz", "security", "subscription_creation_platform"]
            keys = ["acf_platform_maintainers",  "management", "alz"]
          }
        }
        "Storage Blob Data Reader" = {
          azuread_groups = {
            keys = ["acf_platform_contributors", "level0", "connectivity"]
          }
        }
      }
      "level2" = {
        "Storage Blob Data Contributor" = {
          azuread_groups = {
            # keys = ["identity", "connectivity", "management", "security", "acf_platform_maintainers", "level0"]
            keys = ["connectivity", "management", "acf_platform_maintainers", "level0"]
          }
        }
        "Storage Blob Data Reader" = {
          azuread_groups = {
            # keys = ["subscription_creation_landingzones", "acf_platform_contributors"]
            keys = [ "acf_platform_contributors"]
          }
        }
      }
      "level3" = {
        "Storage Blob Data Contributor" = {
          azuread_groups = {
            # keys = ["identity", "connectivity", "management", "security", "acf_platform_maintainers", "level0"]
            keys = ["connectivity", "management", "acf_platform_maintainers", "level0"]
          }
        }
        "Storage Blob Data Reader" = {
          azuread_groups = {
            keys = ["subscription_creation_landingzones", "acf_platform_contributors"]
            keys = ["acf_platform_contributors"]
          }
        }
      }
      "level4" = {
        "Storage Blob Data Contributor" = {
          azuread_groups = {
            # keys = ["identity", "connectivity", "management", "security", "acf_platform_maintainers", "level0"]
            keys = ["connectivity", "management", "acf_platform_maintainers", "level0"]
          }
        }
        "Storage Blob Data Reader" = {
          azuread_groups = {
            # keys = ["subscription_creation_landingzones", "acf_platform_contributors"]
            keys = ["acf_platform_contributors"]
          }
        }
      }
    }
    keyvaults = {
      "level0" = {
        "Key Vault Secrets Officer" = {
          azuread_groups = {
            keys = ["level0", "acf_platform_maintainers"]
          }
        }
        "Key Vault Secrets User" = {
          azuread_groups = {
            # keys = ["identity", "acf_platform_maintainers"]
            keys = ["acf_platform_maintainers"]
          }
        }
      }
      "level1" = {
        "Key Vault Secrets Officer" = {
          azuread_groups = {
            keys = ["level0", "acf_platform_maintainers"]
          }
        }
        "Key Vault Secrets User" = {
          azuread_groups = {
            # keys = ["identity", "management", "alz", "security", "subscription_creation_platform", "acf_platform_contributors"]
            keys = ["management", "alz", "acf_platform_contributors"]
          }
        }
      }
      "level2" = {
        "Key Vault Secrets Officer" = {
          azuread_groups = {
            keys = ["level0", "acf_platform_maintainers"]
          }
        }
        "Key Vault Secrets User" = {
          azuread_groups = {
            # keys = ["identity", "management", "alz", "security", "connectivity", "subscription_creation_platform", "acf_platform_contributors"]
            keys = ["management", "alz", "connectivity", "acf_platform_contributors"]
          }
        }
      }
      "level3" = {
        "Key Vault Secrets Officer" = {
          azuread_groups = {
            keys = ["level0", "acf_platform_maintainers"]
          }
        }
        "Key Vault Secrets User" = {
          azuread_groups = {
            # keys = ["identity", "management", "alz", "security", "connectivity", "subscription_creation_platform", "acf_platform_contributors"]
            keys = ["management", "alz", "connectivity", "acf_platform_contributors"]
          }
        }
      }
      "level4" = {
        "Key Vault Secrets Officer" = {
          azuread_groups = {
            keys = ["level0", "acf_platform_maintainers"]
          }
        }
        "Key Vault Secrets User" = {
          azuread_groups = {
            # keys = ["identity", "management", "alz", "security", "connectivity", "subscription_creation_platform", "acf_platform_contributors"]
            keys = ["management", "alz", "connectivity", "acf_platform_contributors"]
          }
        }
      }
    }

  }
}