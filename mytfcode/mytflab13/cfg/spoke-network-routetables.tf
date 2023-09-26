#################################################
# Create Frontend Subnet routetable
#################################################
resource "azurerm_route_table" "frontendsubnet" {
  name                          = "${var.subscriptionname}-network-vnet-FrontendSubnet-rt"
  location                      = azurerm_resource_group.network.location
  resource_group_name           = azurerm_resource_group.network.name
  disable_bgp_route_propagation = true

  route {
    name                   = "Everywhere"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = data.azurerm_firewall.firewall.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "frontendsubnet" {
  subnet_id      = azurerm_subnet.frontendsubnet.id
  route_table_id = azurerm_route_table.frontendsubnet.id
}


###########################################################################
# Update p-net-network-vnet-GatewaySubnet-rt with routes for this subnet. 
# Needed for Onprem to know about this vnet 
###########################################################################
resource "azurerm_route" "gatewaysubnet" {
  provider               = azurerm.pwe1net
  name                   = "${var.subscriptionname}-network-vnet"
  resource_group_name    = data.azurerm_virtual_network.hub.resource_group_name
  route_table_name       = "${data.azurerm_virtual_network.hub.name}-GatewaySubnet-rt"
  address_prefix         = var.vnetaddress
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = data.azurerm_firewall.firewall.ip_configuration[0].private_ip_address
}

