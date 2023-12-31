
#
# Services supported: subscriptions, storage accounts and resource groups
# Can assign roles to: AD groups, AD object ID, AD applications, Managed identities
#
role_mapping = {
  built_in_role_mapping = {
    keyvaults = {
      "level0" = {
        "Key Vault Secrets Officer" = {
          logged_in = {
            keys = ["user"]
          }
        }
      }
      "level1" = {
        "Key Vault Secrets Officer" = {
          logged_in = {
            keys = ["user"]
          }
        }
      }
      "level2" = {
        "Key Vault Secrets Officer" = {
          logged_in = {
            keys = ["user"]
          }
        }
      }
      "level3" = {
        "Key Vault Secrets Officer" = {
          logged_in = {
            keys = ["user"]
          }
        }
      }
      "level4" = {
        "Key Vault Secrets Officer" = {
          logged_in = {
            keys = ["user"]
          }
        }
      }
    }
    storage_accounts = {
      level0 = {
        "Storage Blob Data Contributor" = {
          logged_in = {
            keys = ["user"]
          }
        }
      }
      level1 = {
        "Storage Blob Data Contributor" = {
          logged_in = {
            keys = ["user"]
          }
        }
      }
      level2 = {
        "Storage Blob Data Contributor" = {
          logged_in = {
            keys = ["user"]
          }
        }
      }
      level3 = {
        "Storage Blob Data Contributor" = {
          logged_in = {
            keys = ["user"]
          }
        }
      }
      level4 = {
        "Storage Blob Data Contributor" = {
          logged_in = {
            keys = ["user"]
          }
        }
      }
    }
  }

}
