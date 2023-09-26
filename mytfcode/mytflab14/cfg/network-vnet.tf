################################################
#  Network Watcher (Needed for flow logs)
################################################
resource "azurerm_network_watcher" "network" {
  name                = "${azurerm_resource_group.network.name}-networkwatcher"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
}



################################################
#  Defining Vnet and Subnets
################################################
resource "azurerm_virtual_network" "vnet" {
  name                = "${azurerm_resource_group.network.name}-vnet"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = [var.vnetaddress]
  dns_servers         = var.dnsservers

  depends_on = [
    azurerm_network_watcher.network,
  ]
}


################################################
#  Subnet 1
################################################

resource "azurerm_subnet" "subnet1" {
  name                 = var.subnet1Name
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet1Prefixes
  service_endpoints    = var.subnet1ServiceEndpoints
}

# Attach NSG to subnet
resource "azurerm_subnet_network_security_group_association" "subnet1" {
  subnet_id                 = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.subnet1.id
}


################################################
#  Setting VNET diagnostics
################################################

resource "azurerm_monitor_diagnostic_setting" "vnet_diagnostic_settings" {
  name                       = data.azurerm_log_analytics_workspace.central.name
  target_resource_id         = azurerm_virtual_network.vnet.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.central.id

  enabled_log {
    category = "VMProtectionAlerts"
  }
  metric {
    category = "AllMetrics"
  }
}


