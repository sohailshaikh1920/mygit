################################################
#  Azure Firewall Public IP Prefix
################################################


resource "azurerm_public_ip_prefix" "AzureFirewall" {
  name                = "${azurerm_resource_group.network.name}-fw-pipprefix"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name

  zones = var.zones
}


################################################
#  Azure Firewall Public IPs
################################################


resource "azurerm_public_ip" "AzureFirewall001" {
  name                = "${azurerm_resource_group.network.name}-fw-pip001"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name

  allocation_method   = "Static"
  public_ip_prefix_id = azurerm_public_ip_prefix.AzureFirewall.id
  sku                 = "Standard"
  zones               = var.zones

  depends_on = [
    azurerm_public_ip_prefix.AzureFirewall,
  ]
}


################################################
#  Azure Firewall
################################################


resource "azurerm_firewall" "AzureFirewall" {
  name                = "${azurerm_resource_group.network.name}-fw"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name

  firewall_policy_id = azurerm_firewall_policy.AzureFirewall-Policy.id
  sku_name           = var.AzureFirewall-sku_name
  sku_tier           = var.AzureFirewall-sku_tier
  ip_configuration {
    name                 = azurerm_public_ip.AzureFirewall001.name
    public_ip_address_id = azurerm_public_ip.AzureFirewall001.id
    subnet_id            = azurerm_subnet.AzureFirewallSubnet.id
  }
  zones = var.zones

  depends_on = [
    azurerm_firewall_policy.AzureFirewall-Policy,
    azurerm_subnet.AzureFirewallSubnet,
  ]
}


################################################
#  Azure Firewall Diagnostics
################################################

resource "azurerm_monitor_diagnostic_setting" "AzureFirewall" {
  name                           = data.azurerm_log_analytics_workspace.central.name
  target_resource_id             = azurerm_firewall.AzureFirewall.id
  log_analytics_workspace_id     = data.azurerm_log_analytics_workspace.central.id
  log_analytics_destination_type = "Dedicated"

  log {
    category = "AzureFirewallApplicationRule"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AzureFirewallNetworkRule"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AzureFirewallDnsProxy"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AZFWNetworkRule"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AZFWApplicationRule"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AZFWNatRule"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AZFWThreatIntel"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AZFWDnsQuery"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AZFWFqdnResolveFailure"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AZFWFatFlow"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AZFWFlowTrace"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AZFWApplicationRuleAggregation"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AZFWNetworkRuleAggregation"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AZFWNatRuleAggregation"
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
