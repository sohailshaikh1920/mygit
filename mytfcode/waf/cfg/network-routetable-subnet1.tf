#################################################
# Subnet 1 routetable
#################################################

resource "azurerm_route_table" "subnet1" {
  name                          = "${var.subscriptionname}-network-vnet-${azurerm_subnet.subnet1.name}-rt"
  location                      = azurerm_resource_group.network.location
  resource_group_name           = azurerm_resource_group.network.name
  disable_bgp_route_propagation = true

  route {
    name                   = "we1"
    address_prefix         = var.vdc_address_space
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = data.azurerm_firewall.firewall.ip_configuration[0].private_ip_address
  }

  route {
    name                   = "Everywhere"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "Internet"
  }
}

resource "azurerm_subnet_route_table_association" "subnet1" {
  subnet_id      = azurerm_subnet.subnet1.id
  route_table_id = azurerm_route_table.subnet1.id
}
