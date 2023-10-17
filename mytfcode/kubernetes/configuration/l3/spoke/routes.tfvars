route_tables = {
  no_internet = {
    name               = "No Internet"
    resource_group_key = "spoke_network"
  }
  everywhere_rt = {
    name               = "Everywhere"
    resource_group_key = "spoke_network"
  }
}

azurerm_routes = {
  no_internet = {
    name               = "no_internet"
    resource_group_key = "spoke_network"
    route_table_key    = "no_internet"
    address_prefix     = "0.0.0.0/0"
    next_hop_type      = "None"
  }
  gateway = {
    name               = "Everywhere"
    resource_group_key = "spoke_network"
    route_table_key    = "everywhere_rt"
    address_prefix     = "0.0.0.0/0"
    next_hop_type      = "VirtualAppliance"
    next_hop_in_ip_address = "10.78.4.1"
  }
}