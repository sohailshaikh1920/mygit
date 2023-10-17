################################################
#  Virtual Network Peerings
################################################


################################################
#  Legacy Dev Subscription
################################################

resource "azurerm_virtual_network_peering" "LegacyDev" {
  name                      = "mnt-d-euw-default-vnet"
  resource_group_name       = azurerm_resource_group.network.name

  remote_virtual_network_id = "/subscriptions/07e72fa1-2601-4b08-bbda-2dee4b13be3c/resourceGroups/mnt-d-euw-default-vnet-rg/providers/Microsoft.Network/virtualNetworks/mnt-d-euw-default-vnet"
  virtual_network_name      = azurerm_virtual_network.vnet.name
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}


################################################
#  Legacy Production Subscription
################################################

resource "azurerm_virtual_network_peering" "LegacyProduction" {
  name                      = "mnt-p-euw-default-vnet"
  resource_group_name       = azurerm_resource_group.network.name

  remote_virtual_network_id = "/subscriptions/3111f1af-3259-4a57-884b-6ebbbe43b415/resourceGroups/mnt-p-euw-default-vnet-rg/providers/Microsoft.Network/virtualNetworks/mnt-p-euw-default-vnet"
  virtual_network_name      = azurerm_virtual_network.vnet.name
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}


################################################
#  Legacy Test Subscription
################################################

resource "azurerm_virtual_network_peering" "LegacyTest" {
  name                      = "mnt-t-euw-default-vnet"
  resource_group_name       = azurerm_resource_group.network.name

  remote_virtual_network_id = "/subscriptions/07e72fa1-2601-4b08-bbda-2dee4b13be3c/resourceGroups/mnt-t-euw-default-vnet-rg/providers/Microsoft.Network/virtualNetworks/mnt-t-euw-default-vnet"
  virtual_network_name      = azurerm_virtual_network.vnet.name
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}


################################################
#  Legacy Hub Subscription (ICE ExpressRoute)
################################################

resource "azurerm_virtual_network_peering" "LegacyHub" {
  name                      = "vnet-h-weu-transit"
  resource_group_name       = azurerm_resource_group.network.name

  remote_virtual_network_id = "/subscriptions/a009cea3-5258-4e3e-a562-0a79ef97cbe6/resourceGroups/rg-mnth-weu-vnet-transit/providers/Microsoft.Network/virtualNetworks/vnet-h-weu-transit"
  virtual_network_name      = azurerm_virtual_network.vnet.name
  allow_forwarded_traffic = true
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}
