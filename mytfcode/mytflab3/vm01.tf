
resource "azurerm_network_interface" "nic1" {
  name                = "nic1"
  location            = azurerm_resource_group.labrg01.location
  resource_group_name = azurerm_resource_group.labrg01.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.labsn01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vmpip.id
  }
}

resource "azurerm_public_ip" "vmpip" {
  name                = "vmpip"
  resource_group_name = azurerm_resource_group.labrg01.name
  location            = azurerm_resource_group.labrg01.location
  allocation_method   = "Static"

}

resource "azurerm_windows_virtual_machine" "vm1" {
  name                = "vm01"
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