###########################################################################
# Update the hub GatewaySubnet route table with a route to the prefixes of this VNet
###########################################################################

resource "azurerm_route" "gatewaysubnet1" {
  provider               = azurerm.pwe1net
  name                   = "p-we1depv2-network-vnet" // "${azurerm_virtual_network.vnet.name}"
  resource_group_name    = data.azurerm_virtual_network.hub.resource_group_name
  route_table_name       = "${data.azurerm_virtual_network.hub.name}-GatewaySubnet-rt"
  address_prefix         = var.vnetaddress
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = data.azurerm_firewall.firewall.ip_configuration[0].private_ip_address
}
