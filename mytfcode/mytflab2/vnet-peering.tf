################### hub to spoke1 #########################

resource "azurerm_virtual_network_peering" "vnet01-02-peer" {
  name                      = "vnet01-02-peer"
  resource_group_name       = azurerm_resource_group.labrg01.name
  virtual_network_name      = azurerm_virtual_network.labhub.name
  remote_virtual_network_id = azurerm_virtual_network.labspoke01.id
}

################### hub to spoke2 #########################

resource "azurerm_virtual_network_peering" "vnet01-03-peer" {
  name                      = "vnet01-03-peer"
  resource_group_name       = azurerm_resource_group.labrg01.name
  virtual_network_name      = azurerm_virtual_network.labhub.name
  remote_virtual_network_id = azurerm_virtual_network.labspoke02.id
}

################### spoke1 to hub #########################

resource "azurerm_virtual_network_peering" "vnet02-01-peer" {
  name                      = "vnet02-01-peer"
  resource_group_name       = azurerm_resource_group.labrg01.name
  virtual_network_name      = azurerm_virtual_network.labspoke01.name
  remote_virtual_network_id = azurerm_virtual_network.labhub.id
}


################### spoke2 to hub #########################

resource "azurerm_virtual_network_peering" "vnet03-01-peer" {
  name                      = "vnet02-01-peer"
  resource_group_name       = azurerm_resource_group.labrg01.name
  virtual_network_name      = azurerm_virtual_network.labspoke02.name
  remote_virtual_network_id = azurerm_virtual_network.labhub.id
}

