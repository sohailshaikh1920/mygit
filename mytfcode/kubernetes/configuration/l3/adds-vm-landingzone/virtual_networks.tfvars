vnets = {
  adds_region1_vnet = {
    resource_group_key = "adds_network"
    vnet = {
      name          = "p-we1dc-network-vnet"
      address_space = ["10.128.6.0/24"]
    }
    subnets = {
      frontend = {
        name = "frontendSubnet"
        cidr = ["10.128.6.0/25"]
      }
    }

  }
}