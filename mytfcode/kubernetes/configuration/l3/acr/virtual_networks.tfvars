vnets = {
  acr_region1_vnet = {
    resource_group_key = "acr_region1_vnet"
    region             = "region1"
    vnet = {
      name          = "p-we1acr-network-vnet"
      address_space = ["10.128.44.0/22"]
    }
    specialsubnets = {}
    subnets = {
      jumpbox_subnet = {
        name    = "JumpboxSubnet"
        cidr    = ["10.128.44.0/27"]
        service_endpoints = ["Microsoft.ContainerRegistry"]
        enforce_private_link_endpoint_network_policies = "true"
      }
    }

  }
}

