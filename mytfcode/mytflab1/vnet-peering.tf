resource "azurerm_virtual_network_peering" "vnet01-02-peer" {
  name                      = "vnet01-02-peer"
  resource_group_name       = azurerm_resource_group.labrg01.name
  virtual_network_name      = azurerm_virtual_network.labvnet01.name
  remote_virtual_network_id = azurerm_virtual_network.labvnet02.id
}

resource "azurerm_virtual_network_peering" "vnet02-01-peer" {
  name                      = "vnet02-01-peer"
  resource_group_name       = azurerm_resource_group.labrg01.name
  virtual_network_name      = azurerm_virtual_network.labvnet02.name
  remote_virtual_network_id = azurerm_virtual_network.labvnet01.id
}

resource "azurerm_virtual_network_peering" "vnet03-01-peer" {
  name                      = "vnet03-01-peer"
  resource_group_name       = azurerm_resource_group.labrg01.name
  virtual_network_name      = azurerm_virtual_network.labvnet03.name
  remote_virtual_network_id = azurerm_virtual_network.labvnet01.id
}

resource "azurerm_virtual_network_peering" "vnet01-03-peer" {
  name                      = "vnet01-03-peer"
  resource_group_name       = azurerm_resource_group.labrg01.name
  virtual_network_name      = azurerm_virtual_network.labvnet01.name
  remote_virtual_network_id = azurerm_virtual_network.labvnet03.id
}

resource "azurerm_virtual_network_peering" "vnet03-02-peer" {
  name                      = "vnet03-02-peer"
  resource_group_name       = azurerm_resource_group.labrg01.name
  virtual_network_name      = azurerm_virtual_network.labvnet03.name
  remote_virtual_network_id = azurerm_virtual_network.labvnet02.id
}

resource "azurerm_virtual_network_peering" "vnet02-03-peer" {
  name                      = "vnet02-03-peer"
  resource_group_name       = azurerm_resource_group.labrg01.name
  virtual_network_name      = azurerm_virtual_network.labvnet02.name
  remote_virtual_network_id = azurerm_virtual_network.labvnet03.id
}