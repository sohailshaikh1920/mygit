vnets = {
  hub_vnet = {
    resource_group_key = "hub_vnet"
    region             = "region1"
    vnet = {
      name          = "p-rg1net-network-vnet"
      address_space = ["10.128.0.0/22"]
    }
    specialsubnets = {
      GatewaySubnet = {
        name = "GatewaySubnet" #Must be called GateWaySubnet in order to host a Virtual Network Gateway
        cidr = ["10.128.0.0/26"]
      }
      AzureFirewallSubnet = {
        name = "AzureFirewallSubnet" #Must be called AzureFirewallSubnet
        cidr = ["10.128.1.0/26"]
      }
    }
    subnets = {
      AzureBastionSubnet = {
        name    = "AzureBastionSubnet" #Must be called AzureBastionSubnet
        cidr    = ["10.128.3.128/26"]
        nsg_key = "azure_bastion_nsg"
      }
      jumpbox = {
        name    = "jumpbox"
        cidr    = ["10.128.3.0/27"]
        nsg_key = "jumpbox"
      }

    }
  }

}