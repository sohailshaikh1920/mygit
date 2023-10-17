################################################
#  S2S Gateway Public IP
################################################

resource "azurerm_public_ip" "S2sGateway001" {
  name                = "${azurerm_resource_group.network.name}-vpn-pip001"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name

  allocation_method = "Static"
  sku               = "Standard"
  zones             = var.zones
}


################################################
#  S2S Gateway
################################################

resource "azurerm_virtual_network_gateway" "S2sGateway" {
  name                = "${azurerm_resource_group.network.name}-vpn"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name

  sku  = var.S2sGateway-sku
  type = "Vpn"
  ip_configuration {
    public_ip_address_id = azurerm_public_ip.S2sGateway001.id
    subnet_id            = azurerm_subnet.GatewaySubnet.id
  }
  depends_on = [
    azurerm_subnet.GatewaySubnet,
  ]
}

################################################
#  S2S Gateway Diagnostics Settings
################################################

resource "azurerm_monitor_diagnostic_setting" "S2sGateway" {
  name                       = data.azurerm_log_analytics_workspace.central.name
  target_resource_id         = azurerm_virtual_network_gateway.S2sGateway.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.central.id

  log {
    category = "GatewayDiagnosticLog"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "TunnelDiagnosticLog"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "RouteDiagnosticLog"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "IKEDiagnosticLog"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "P2SDiagnosticLog"
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
