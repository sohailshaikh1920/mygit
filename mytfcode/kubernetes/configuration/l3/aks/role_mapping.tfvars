#
role_mapping = {
  custom_role_mapping = {}

  built_in_role_mapping = {
    aks_clusters = {
      aks_region1_custer = {
        "Azure Kubernetes Service RBAC Cluster Admin" = {
          # azuread_groups = {
          #   keys = ["aks_cluster_admins"]
          # }
          logged_in = {
            keys = ["user"]
          }
          managed_identities = {
            keys = ["aks_jumpbox"]
          }
        }
      }
    }
    azure_container_registries = {
      acr_region1 = {
        # lz_key = "" to be defined when the keyvault is created in a different lz
        lz_key = "acr-region1"
        "AcrPull" = {
          aks_clusters = {
            # lz_key = "" to be defined when the msi is created in a different lz
            keys = ["aks_region1_custer"]
          }
        }
      }
    }

    networking = {
      # AKS Cluster needs permission to connect to the node pool network
      aks_region1_vnet = {
        "Contributor" = {
          managed_identities = {
            keys = ["aks_region1_custer"]
          }
          # azuread_service_principals = {
          #   keys = ["sp1"]
          # }
          # object_ids = {
          #   keys = ["004c3094-aa2e-47f3-87aa-f82a155ada54"]
          # }
        }
      }
    }

    # virtual_subnets = {
    #   # subcription level access
    #   subnet1 = {
    #     "Contributor" = {
    #       managed_identities = {
    #         keys = ["aks_region1_custer"]
    #       }
    #     }
    #   }
    # }

  }
}