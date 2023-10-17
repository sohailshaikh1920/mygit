private_dns = {
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
  "privatelink.vaultcore.azure.net" = {
    name               = "privatelink.vaultcore.azure.net"
    resource_group_key = "iac_network"
    vnet_links = {
      iac_network = {
        name     = "p-iac-network"
        vnet_key = "iac_network"
      }
    }
  }
}