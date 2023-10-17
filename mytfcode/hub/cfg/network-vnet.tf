################################################
#  Defining Vnet and Subnets
################################################
resource "azurerm_virtual_network" "vnet" {
  name                = "${azurerm_resource_group.network.name}-vnet"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = var.vnetaddressPrefixes
  //  dns_servers         = var.dnsservers
}


################################################
#  Network Watcher (Needed for flow logs)
################################################
resource "azurerm_network_watcher" "network" {
  name                = "${azurerm_resource_group.network.name}-networkwatcher"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
}


################################################
#  GatewaySubnet
################################################

resource "azurerm_subnet" "GatewaySubnet" {
  name                 = var.GatewaySubnetName
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.GatewaySubnetPrefixes
  service_endpoints    = var.GatewaySubnetServiceEndpoints
}


################################################
#  AzureFirewallSubnet
################################################

resource "azurerm_subnet" "AzureFirewallSubnet" {
  name                 = var.AzureFirewallSubnetName
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.AzureFirewallSubnetPrefixes
  service_endpoints    = var.AzureFirewallSubnetServiceEndpoints
}


################################################
#  AuzreBastionSubnet
################################################

resource "azurerm_subnet" "AzureBastionSubnet" {
  name                 = var.AzureBastionSubnetName
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.AzureBastionSubnetPrefixes
  service_endpoints    = var.AzureBastionSubnetServiceEndpoints
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
