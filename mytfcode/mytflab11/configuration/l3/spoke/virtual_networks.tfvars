vnets = {
  spoke_region1_vnet = {
    resource_group_key = "spoke_network"
    vnet = {
      name          = "t-rg1spoke-network-vnet"
      address_space = ["10.128.52.0/24"]
      dns_servers   = ["10.128.6.5", "10.128.6.6"] # p-we1dc
    }
    subnets = {
      IntegrationSubnet = {
        name = "IntegrationSubnet"
        cidr = ["10.128.52.0/26"]
        nsg_key = "integration_subnet_nsg"
        route_table_key = "everywhere_rt"
        delegation = {
          name               = "appsvc-delegation"
          service_delegation = "Microsoft.Web/serverFarms"
          actions = [
            "Microsoft.Network/virtualNetworks/subnets/action"
          ]
        }
      }
      # PrivateEndpointSubnet = {
      #   name = "PrivateEndpointSubnet"
      #   cidr = ["10.128.52.128/26"]
      #   nsg_key = "private_endpoint_subnet_nsg"
      #   route_table_key = "everywhere_rt"
      # }
    }

    diagnostic_profiles = {
      operation = {
        definition_key   = "networking_all"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
        # destination_type = "storage" # if using storage account
        # destination_key  = "central_storage"
      }
    }
  }
}