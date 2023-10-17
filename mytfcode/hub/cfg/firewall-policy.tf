################################################
#  Parent Azure Firewall Policy
################################################

data "azurerm_firewall_policy" "ParentAzureFirewallPolicy" {
  name                = "p-net-azfw-global-firewallpolicy"
  resource_group_name = "p-net-azfw"
  provider            = azurerm.pnet
}


################################################
#  Azure Firewall Policy
################################################

resource "azurerm_firewall_policy" "AzureFirewall-Policy" {
  name                = "${azurerm_resource_group.network.name}-fw-firewallpolicy"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name

  base_policy_id           = data.azurerm_firewall_policy.ParentAzureFirewallPolicy.id
  threat_intelligence_mode = var.AzureFirewall-Policy-threat_intelligence_mode
  dns {
    proxy_enabled = var.AzureFirewall-Policy-dns-proxy_enabled
    servers       = var.AzureFirewall-Policy-dns-servers
  }
  insights {
    default_log_analytics_workspace_id = data.azurerm_log_analytics_workspace.central.id
    enabled                            = var.AzureFirewall-Policy-insights-enabled
    retention_in_days                  = var.AzureFirewall-Policy-insights-retention_in_days
    log_analytics_workspace {
      firewall_location = azurerm_resource_group.network.location
      id                = data.azurerm_log_analytics_workspace.central.id
    }
  }
  intrusion_detection {
    mode = var.AzureFirewall-Policy-intrusion_detection-mode
  }
}
