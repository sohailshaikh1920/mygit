###### hub vnet ########################
resource "azurerm_virtual_network" "labhub" {
  name                = "labhub"
  address_space       = ["192.168.0.0/22"]
  location            = azurerm_resource_group.labrg01.location
  resource_group_name = azurerm_resource_group.labrg01.name
}

resource "azurerm_subnet" "AzureBastionSubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.labrg01.name
  virtual_network_name = azurerm_virtual_network.labhub.name
  address_prefixes     = ["192.168.0.0/27"]
}

resource "azurerm_subnet" "AzureFirewallSubnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.labrg01.name
  virtual_network_name = azurerm_virtual_network.labhub.name
  address_prefixes     = ["192.168.1.0/24"]
}

###### spoke vnet ########################
resource "azurerm_virtual_network" "labspoke01" {
  name                = "labspoke01"
  address_space       = ["192.168.10.0/24"]
  location            = azurerm_resource_group.labrg01.location
  resource_group_name = azurerm_resource_group.labrg01.name
}

resource "azurerm_subnet" "labsn02" {
  name                 = "labsn02"
  resource_group_name  = azurerm_resource_group.labrg01.name
  virtual_network_name = azurerm_virtual_network.labspoke01.name
  address_prefixes     = ["192.168.10.0/26"]
}

###### spoke vnet ########################

resource "azurerm_virtual_network" "labspoke02" {
  name                = "labspoke02"
  address_space       = ["192.168.11.0/24"]
  location            = azurerm_resource_group.labrg01.location
  resource_group_name = azurerm_resource_group.labrg01.name
}


resource "azurerm_subnet" "labsn03" {
  name                 = "labsn03"
  resource_group_name  = azurerm_resource_group.labrg01.name
  virtual_network_name = azurerm_virtual_network.labspoke02.name
  address_prefixes     = ["192.168.11.0/26"]
}

