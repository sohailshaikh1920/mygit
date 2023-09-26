resource "azurerm_resource_group" "myrg" {
  location = "norwayeast"
  name     = "aztfexport"
}
resource "azurerm_windows_virtual_machine" "myvm" {
  admin_password        = "Speedy@98765"
  admin_username        = "sohail"
  location              = "norwayeast"
  name                  = "vm02"
  network_interface_ids = ["/subscriptions/4cce77b1-65bc-4255-9570-07178450d61f/resourceGroups/aztfexport/providers/Microsoft.Network/networkInterfaces/vm02VMNic"]
  resource_group_name   = "aztfexport"
  size                  = "Standard_DS1_v2"
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface.mynic,
  ]
}
resource "azurerm_network_interface" "mynic" {
  location            = "norwayeast"
  name                = "vm02VMNic"
  resource_group_name = "aztfexport"
  ip_configuration {
    name                          = "ipconfigvm02"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "/subscriptions/4cce77b1-65bc-4255-9570-07178450d61f/resourceGroups/aztfexport/providers/Microsoft.Network/publicIPAddresses/vm02PublicIP"
    subnet_id                     = "/subscriptions/4cce77b1-65bc-4255-9570-07178450d61f/resourceGroups/aztfexport/providers/Microsoft.Network/virtualNetworks/vm02VNET/subnets/vm02Subnet"
  }
  depends_on = [
    azurerm_public_ip.mypip,
    azurerm_subnet.mysn,
  ]
}
resource "azurerm_network_interface_security_group_association" "assoc" {
  network_interface_id      = "/subscriptions/4cce77b1-65bc-4255-9570-07178450d61f/resourceGroups/aztfexport/providers/Microsoft.Network/networkInterfaces/vm02VMNic"
  network_security_group_id = "/subscriptions/4cce77b1-65bc-4255-9570-07178450d61f/resourceGroups/aztfexport/providers/Microsoft.Network/networkSecurityGroups/vm02NSG"
  depends_on = [
    azurerm_network_interface.mynic,
    azurerm_network_security_group.mynsg,
  ]
}
resource "azurerm_network_security_group" "mynsg" {
  location            = "norwayeast"
  name                = "vm02NSG"
  resource_group_name = "aztfexport"
  depends_on = [
    azurerm_resource_group.myrg,
  ]
}
resource "azurerm_network_security_rule" "rule" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "3389"
  direction                   = "Inbound"
  name                        = "rdp"
  network_security_group_name = "vm02NSG"
  priority                    = 1000
  protocol                    = "Tcp"
  resource_group_name         = "aztfexport"
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.mynsg,
  ]
}
resource "azurerm_public_ip" "mypip" {
  allocation_method   = "Dynamic"
  location            = "norwayeast"
  name                = "vm02PublicIP"
  resource_group_name = "aztfexport"
  depends_on = [
    azurerm_resource_group.myrg,
  ]
}
resource "azurerm_virtual_network" "myvnet" {
  address_space       = ["10.0.0.0/16"]
  location            = "norwayeast"
  name                = "vm02VNET"
  resource_group_name = "aztfexport"
  depends_on = [
    azurerm_resource_group.myrg,
  ]
}
resource "azurerm_subnet" "mysn" {
  address_prefixes     = ["10.0.0.0/24"]
  name                 = "vm02Subnet"
  resource_group_name  = "aztfexport"
  virtual_network_name = "vm02VNET"
  depends_on = [
    azurerm_virtual_network.myvnet,
  ]
}
