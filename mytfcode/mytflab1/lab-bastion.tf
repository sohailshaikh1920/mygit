resource "azurerm_resource_group" "labrg01" {
  name     = "labrg-resources"
  location = var.region
}

resource "azurerm_virtual_network" "labvnet01" {
  name                = "labvnet01"
  address_space       = ["192.168.1.0/24"]
  location            = azurerm_resource_group.labrg01.location
  resource_group_name = azurerm_resource_group.labrg01.name
}

resource "azurerm_subnet" "labsn01" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.labrg01.name
  virtual_network_name = azurerm_virtual_network.labvnet01.name
  address_prefixes     = ["192.168.1.224/27"]
}

resource "azurerm_public_ip" "labpip01" {
  name                = "labpip01"
  location            = azurerm_resource_group.labrg01.location
  resource_group_name = azurerm_resource_group.labrg01.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "labbastion01" {
  name                = "labbastion01"
  location            = azurerm_resource_group.labrg01.location
  resource_group_name = azurerm_resource_group.labrg01.name

  ip_configuration {
    name                 = "bastionip"
    subnet_id            = azurerm_subnet.labsn01.id
    public_ip_address_id = azurerm_public_ip.labpip01.id
  }
}