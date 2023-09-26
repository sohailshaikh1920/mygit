###########################################################################
# Update the hub GatewaySubnet route table with a route to the prefixes of this VNet
###########################################################################

resource "azurerm_route" "gatewaysubnet1" {
  provider               = azurerm.pwe1net
  name                   = "PublicWafBlackhole"
  resource_group_name    = data.azurerm_virtual_network.hub.resource_group_name
  route_table_name       = "${data.azurerm_virtual_network.hub.name}-GatewaySubnet-rt"
  address_prefix         = var.vnetaddress
  next_hop_type          = "None"
}
