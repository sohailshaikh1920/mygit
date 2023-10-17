vnet_peerings_v1 = {
  hub_re1_TO_adds_region1_vnet = {
    name = "hub_re1_TO_adds_region1_vnet"
    from = {
      vnet_key = "hub_re1"
      lz_key = "net-hub-region1"
    }
    to = {
      vnet_key = "adds_region1_vnet"
    }
    allow_virtual_network_access = true
    allow_forwarded_traffic      = false
    allow_gateway_transit        = false
    use_remote_gateways          = false
  }

  adds_region1_vnet_TO_hub_re1 = {
    name = "adds_region1_vnet_TO_hub_re1"
    from = {
      vnet_key = "adds_region1_vnet"
    }
    to = {
      vnet_key = "hub_re1"
      lz_key = "net-hub-region1"
    }
    allow_virtual_network_access = true
    allow_forwarded_traffic      = false
    allow_gateway_transit        = false
    use_remote_gateways          = false
  }

}
