
resource "azurerm_resource_group" "tobedeleted" {
  name     = "tobedeleted"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.tobedeleted.location
  resource_group_name = azurerm_resource_group.tobedeleted.name
}

resource "azurerm_subnet" "sn1" {
  name                 = "sn1"
  resource_group_name  = azurerm_resource_group.tobedeleted.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nic1" {
  name                = "nic1"
  location            = azurerm_resource_group.tobedeleted.location
  resource_group_name = azurerm_resource_group.tobedeleted.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sn1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm1" {
  name                = "vm1"
  resource_group_name = azurerm_resource_group.tobedeleted.name
  location            = azurerm_resource_group.tobedeleted.location
  size                = "Standard_DS1_v2"
  admin_username      = "sohail"
  admin_password      = "Speedy@98765"
  network_interface_ids = [
    azurerm_network_interface.nic1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
