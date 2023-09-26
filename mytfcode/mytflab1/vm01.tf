
resource "azurerm_virtual_network" "labvnet02" {
  name                = "labvnet02"
  address_space       = ["192.168.2.0/24"]
  location            = azurerm_resource_group.labrg01.location
  resource_group_name = azurerm_resource_group.labrg01.name
}

resource "azurerm_subnet" "labsn02" {
  name                 = "labsn02"
  resource_group_name  = azurerm_resource_group.labrg01.name
  virtual_network_name = azurerm_virtual_network.labvnet02.name
  address_prefixes     = ["192.168.2.0/26"]
}

resource "azurerm_network_interface" "nic1" {
  name                = "nic1"
  location            = azurerm_resource_group.labrg01.location
  resource_group_name = azurerm_resource_group.labrg01.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.labsn02.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm1" {
  name                = "vm1"
  resource_group_name = azurerm_resource_group.labrg01.name
  location            = azurerm_resource_group.labrg01.location
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