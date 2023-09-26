vnet_peerings_v1 = {
  hub_re1_TO_acr_region1_vnet = {
    name = "hub_re1_TO_acr_region1_vnet"
    from = {
      vnet_key = "hub_re1"
      lz_key = "net-hub-region1"
    }
    to = {
      vnet_key = "acr_region1_vnet"
    }
    allow_virtual_network_access = true
    allow_forwarded_traffic      = false
    allow_gateway_transit        = false
    use_remote_gateways          = false
  }

  acr_region1_vnet_TO_hub_re1 = {
    name = "acr_region1_vnet_TO_hub_re1"
    from = {
      vnet_key = "acr_region1_vnet"
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


  # to peer with a vnet in a different subscription you can reference the id in from or to
  # or use vnet_key and lz_key
  #
  # uncomment and adjust the following example for cross subscripiton vnet peering
  #
  # test_TO_hub_re1 = {
  #   name = "test_TO_hub_re1"
  #   from = {
  #     id = "/subscriptions/xxxxxxxxxxxx/resourceGroups/vnet/providers/Microsoft.Network/virtualNetworks/vnet1"
  #   }
  #   to = {
  #     vnet_key = "hub_re1"
  #   }
  #   allow_virtual_network_access = true
  #   allow_forwarded_traffic      = false
  #   allow_gateway_transit        = false
  #   use_remote_gateways          = false
  # }

  # hub_re1_TO_test = {
  #   name = "hub_re1_TO_test"
  #   from = {
  #     vnet_key = "hub_re1"
  #   }
  #   to = {
  #     id = "/subscriptions/xxxxxxxxxxxxx/resourceGroups/vnet/providers/Microsoft.Network/virtualNetworks/vnet1"
  #   }
  #   allow_virtual_network_access = true
  #   allow_forwarded_traffic      = false
  #   allow_gateway_transit        = false
  #   use_remote_gateways          = false
  # }
  # test_TO_hub_re1 = {
  #   name = "test_TO_hub_re1"
  #   from = {
  #     id = "/subscriptions/xxxxxxxxxxxx/resourceGroups/vnet/providers/Microsoft.Network/virtualNetworks/vnet1"
  #   }
  #   to = {
  #     vnet_key = "hub_re1"
  #   }
  #   allow_virtual_network_access = true
  #   allow_forwarded_traffic      = false
  #   allow_gateway_transit        = false
  #   use_remote_gateways          = false
  # }

  # hub_re1_TO_test = {
  #   name = "hub_re1_TO_test"
  #   from = {
  #     vnet_key = "hub_re1"
  #   }
  #   to = {
  #     id = "/subscriptions/xxxxxxxxxxxxx/resourceGroups/vnet/providers/Microsoft.Network/virtualNetworks/vnet1"
  #   }
  #   allow_virtual_network_access = true
  #   allow_forwarded_traffic      = false
  #   allow_gateway_transit        = false
  #   use_remote_gateways          = false
  # }

}
