################################################
# AzureFirewallSubnet Route Table
################################################

resource "azurerm_route_table" "AzureFirewallSubnet" {
  name                          = "${var.subscriptionname}-network-vnet-${azurerm_subnet.AzureFirewallSubnet.name}-rt"
  location                      = azurerm_resource_group.network.location
  resource_group_name           = azurerm_resource_group.network.name
  disable_bgp_route_propagation = false
}


################################################
# AzureFirewallSubnet Route Table Association
################################################

resource "azurerm_subnet_route_table_association" "AzureFirewallSubnet" {
  subnet_id      = azurerm_subnet.AzureFirewallSubnet.id
  route_table_id = azurerm_route_table.AzureFirewallSubnet.id

  depends_on = [
    azurerm_subnet.AzureFirewallSubnet,
  ]
}


################################################
# AzureFirewallSubnet Routes
################################################


resource "azurerm_route" "ICE" {
  address_prefix         = "156.48.15.0/26"
  name                   = "ICE"
  next_hop_in_ip_address = "10.100.17.165"
  next_hop_type          = "VirtualAppliance"
  resource_group_name    = azurerm_resource_group.network.name
  route_table_name       = azurerm_route_table.AzureFirewallSubnet.name
  depends_on = [
    azurerm_route_table.AzureFirewallSubnet,
  ]
}

resource "azurerm_route" "ICE-Backup-1" {
  address_prefix         = "156.48.15.25/32"
  name                   = "ICE-Backup-1"
  next_hop_in_ip_address = "10.100.17.165"
  next_hop_type          = "VirtualAppliance"
  resource_group_name    = azurerm_resource_group.network.name
  route_table_name       = azurerm_route_table.AzureFirewallSubnet.name
  depends_on = [
    azurerm_route_table.AzureFirewallSubnet,
  ]
}

resource "azurerm_route" "ICE-Backup-2" {
  address_prefix         = "156.48.15.26/32"
  name                   = "ICE-Backup-2"
  next_hop_in_ip_address = "10.100.17.165"
  next_hop_type          = "VirtualAppliance"
  resource_group_name    = azurerm_resource_group.network.name
  route_table_name       = azurerm_route_table.AzureFirewallSubnet.name
  depends_on = [
    azurerm_route_table.AzureFirewallSubnet,
  ]
}

resource "azurerm_route" "ICE-Primary-1" {
  address_prefix         = "156.48.15.23/32"
  name                   = "ICE-Primary-1"
  next_hop_in_ip_address = "10.100.17.165"
  next_hop_type          = "VirtualAppliance"
  resource_group_name    = azurerm_resource_group.network.name
  route_table_name       = azurerm_route_table.AzureFirewallSubnet.name
  depends_on = [
    azurerm_route_table.AzureFirewallSubnet,
  ]
}

resource "azurerm_route" "ICE-Primary-2" {
  address_prefix         = "156.48.15.24/32"
  name                   = "ICE-Primary-2"
  next_hop_in_ip_address = "10.100.17.165"
  next_hop_type          = "VirtualAppliance"
  resource_group_name    = azurerm_resource_group.network.name
  route_table_name       = azurerm_route_table.AzureFirewallSubnet.name
  depends_on = [
    azurerm_route_table.AzureFirewallSubnet,
  ]
}

resource "azurerm_route" "Internet" {
  address_prefix      = "0.0.0.0/0"
  name                = "Internet"
  next_hop_type       = "Internet"
  resource_group_name = azurerm_resource_group.network.name
  route_table_name    = azurerm_route_table.AzureFirewallSubnet.name
  depends_on = [
    azurerm_route_table.AzureFirewallSubnet,
  ]
}
