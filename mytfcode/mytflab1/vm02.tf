

resource "azurerm_virtual_network" "labvnet03" {
  name                = "labvnet03"
  address_space       = ["192.168.3.0/24"]
  location            = azurerm_resource_group.labrg01.location
  resource_group_name = azurerm_resource_group.labrg01.name
}


resource "azurerm_subnet" "labsn03" {
  name                 = "labsn03"
  resource_group_name  = azurerm_resource_group.labrg01.name
  virtual_network_name = azurerm_virtual_network.labvnet03.name
  address_prefixes     = ["192.168.3.0/25"]
}

resource "azurerm_network_interface" "nic3" {
  name                = "nic3"
  location            = azurerm_resource_group.labrg01.location
  resource_group_name = azurerm_resource_group.labrg01.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.labsn03.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm2" {
  name                = "vm2"
  resource_group_name = azurerm_resource_group.labrg01.name
  location            = azurerm_resource_group.labrg01.location
  size                = "Standard_DS1_v2"
  admin_username      = "sohail"
  admin_password      = "Speedy@98765"
  network_interface_ids = [
    azurerm_network_interface.nic3.id,
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