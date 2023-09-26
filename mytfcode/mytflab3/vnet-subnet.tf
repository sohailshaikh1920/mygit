resource "azurerm_virtual_network" "labvnet" {
  name                = "labvnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.labrg01.location
  resource_group_name = azurerm_resource_group.labrg01.name
}

resource "azurerm_subnet" "labsn01" {
  name                 = "labsn01"
  resource_group_name  = azurerm_resource_group.labrg01.name
  virtual_network_name = azurerm_virtual_network.labvnet.name
  address_prefixes     = ["10.0.2.0/27"]
}

/*
resource "azurerm_subnet" "privateendpointsubnet" {
  name                 = "privateendpointsubnet"
  resource_group_name  = azurerm_resource_group.labrg01.name
  virtual_network_name = azurerm_virtual_network.labvnet.name
  address_prefixes     = ["10.0.2.32/27"]
}

resource "azurerm_subnet" "integrationsubnet" {
  name                 = "integrationsubnet"
  resource_group_name  = azurerm_resource_group.labrg01.name
  virtual_network_name = azurerm_virtual_network.labvnet.name
  address_prefixes     = ["10.0.2.64/27"]
}
*/
