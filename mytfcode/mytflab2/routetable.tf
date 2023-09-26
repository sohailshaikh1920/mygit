
resource "azurerm_route_table" "rtlabspoke01tolabhub" {
  name                          = "rtlabspoke01tolabhub"
  location                      = azurerm_resource_group.labrg01.location
  resource_group_name           = azurerm_resource_group.labrg01.name
  disable_bgp_route_propagation = "true" ## this is very important to route traffic through FW ##

  route {
    name                   = "everywhere"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "192.168.1.4"

  }
}

resource "azurerm_subnet_route_table_association" "rtlabspoke01assoc" {
  subnet_id      = azurerm_subnet.labsn02.id
  route_table_id = azurerm_route_table.rtlabspoke01tolabhub.id
}

resource "azurerm_route_table" "rtlabspoke02tolabhub" {
  name                          = "rtlabspoke02tolabhub"
  location                      = azurerm_resource_group.labrg01.location
  resource_group_name           = azurerm_resource_group.labrg01.name
  disable_bgp_route_propagation = "true" ## this is very important to route traffic through FW ##

  route {
    name                   = "everywhere"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "192.168.1.4"

  }
}

resource "azurerm_subnet_route_table_association" "rtlabspoke02assoc" {
  subnet_id      = azurerm_subnet.labsn03.id
  route_table_id = azurerm_route_table.rtlabspoke02tolabhub.id
}