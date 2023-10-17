#################################################
# GatewaySubnet Route Table
#################################################

resource "azurerm_route_table" "GatewaySubnet" {
  name                          = "${var.subscriptionname}-network-vnet-${azurerm_subnet.GatewaySubnet.name}-rt"
  location                      = azurerm_resource_group.network.location
  resource_group_name           = azurerm_resource_group.network.name
  disable_bgp_route_propagation = true
/*
  route { // Blackhole traffic
    name                   = "192.168.0.0-16"
    address_prefix         = "192.168.0.0/16"
    next_hop_type          = "None"
  }

  route { // Blackhole traffic
    name                   = "172.16.0.0-12"
    address_prefix         = "172.16.0.0/12"
    next_hop_type          = "None"
  }

  route { // Blackhole traffic
    name                   = "10.0.0.0-8"
    address_prefix         = "10.0.0.0/8"
    next_hop_type          = "None"
  }
*/
}


#################################################
# GatewaySubnet Route Table Association
#################################################

resource "azurerm_subnet_route_table_association" "GatewaySubnet" {
  subnet_id      = azurerm_subnet.GatewaySubnet.id
  route_table_id = azurerm_route_table.GatewaySubnet.id
}


#################################################
# GatewaySubnet Routes
#################################################

