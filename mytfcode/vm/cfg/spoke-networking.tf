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
}



################################################
#  Frontend Subnet
################################################
resource "azurerm_subnet" "frontendsubnet" {
  name                 = "FrontendSubnet"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.100.11.192/27"]
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
}

# Attach NSG to subnet
resource "azurerm_subnet_network_security_group_association" "frontendsubnet" {
  subnet_id                 = azurerm_subnet.frontendsubnet.id
  network_security_group_id = azurerm_network_security_group.frontendsubnet.id
}

################################################
#  Setting VNET diagnostics
################################################
resource "azurerm_monitor_diagnostic_setting" "vnet_diagnostic_settings" {
  name                       = data.azurerm_log_analytics_workspace.central.name
  target_resource_id         = azurerm_virtual_network.vnet.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.central.id

  log {
    category = "VMProtectionAlerts"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
}


