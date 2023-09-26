private_dns = {
  "privatelink.azurecr.io" = {
    name               = "privatelink.azurecr.io"
    resource_group_key = "iac_network"
    vnet_links = {
      vnet_region1 = {
        name     = "gitops-region1"
        vnet_key = "iac_network"
      }
    }
  }
  "privatelink.blob.core.windows.net" = {
    name               = "privatelink.blob.core.windows.net"
    resource_group_key = "iac_network"
    vnet_links = {
      iac_network = {
        name     = "p-iac-network"
        vnet_key = "iac_network"
      }
    }
  }
  "privatelink.queue.core.windows.net" = {
    name               = "privatelink.queue.core.windows.net"
    resource_group_key = "iac_network"
    vnet_links = {
      vnet_region1 = {
        name     = "gitops-region1"
        vnet_key = "iac_network"
      }
    }
  }
  "privatelink.vaultcore.azure.net" = {
    name               = "privatelink.vaultcore.azure.net"
    resource_group_key = "iac_network"
    vnet_links = {
      vnet_region1 = {
        name     = "gitops-region1"
        vnet_key = "iac_network"
      }
    }
  }
}