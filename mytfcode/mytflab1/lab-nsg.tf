
resource "azurerm_network_security_group" "labnsg01" {
  name                = "firstnsgrule"
  location            = azurerm_resource_group.labrg01.location
  resource_group_name = azurerm_resource_group.labrg01.name

  security_rule {
    name                       = "allowrdp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "denyall"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_subnet_network_security_group_association" "labsn02asoc" {
  subnet_id                 = azurerm_subnet.labsn02.id
  network_security_group_id = azurerm_network_security_group.labnsg01.id
}

resource "azurerm_subnet_network_security_group_association" "labsn03asoc" {
  subnet_id                 = azurerm_subnet.labsn03.id
  network_security_group_id = azurerm_network_security_group.labnsg01.id
}