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
#  Subnet 1
################################################

resource "azurerm_subnet" "subnet1" {
  name                 = var.subnet1Name
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet1Prefixes
  service_endpoints    = var.subnet1ServiceEndpoints

  delegation {
    name = "appsvc-delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# Attach NSG to subnet
resource "azurerm_subnet_network_security_group_association" "subnet1" {
  subnet_id                 = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.subnet1.id
}


################################################
#  Subnet 2
################################################

resource "azurerm_subnet" "subnet2" {
  name                 = var.subnet2Name
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet2Prefixes
  service_endpoints    = var.subnet2ServiceEndpoints

}

# Attach NSG to subnet
resource "azurerm_subnet_network_security_group_association" "subnet2" {
  subnet_id                 = azurerm_subnet.subnet2.id
  network_security_group_id = azurerm_network_security_group.subnet2.id
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


