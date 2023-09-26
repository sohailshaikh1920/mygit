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
#  App Services Environment - Subnet
################################################
resource "azurerm_subnet" "ase" {
  name                 = "AseSubnet"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.100.13.192/27"]

  delegation {
    name = "ase-delegation"

    service_delegation {
      name    = "Microsoft.Web/hostingEnvironments"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# Attach NSG to subnet
resource "azurerm_subnet_network_security_group_association" "ase" {
  subnet_id                 = azurerm_subnet.ase.id
  network_security_group_id = azurerm_network_security_group.ase.id
}



################################################
#  Private Link - Subnet
################################################
resource "azurerm_subnet" "privatelink" {
  name                 = "PrivateLinkSubnet"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.100.13.224/27"]
}

# Attach NSG to subnet
resource "azurerm_subnet_network_security_group_association" "privatelink" {
  subnet_id                 = azurerm_subnet.privatelink.id
  network_security_group_id = azurerm_network_security_group.privatelink.id
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


