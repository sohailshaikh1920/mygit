resource "azurerm_public_ip" "labfwpip" {
  name                = "labfwpip"
  location            = azurerm_resource_group.labrg01.location
  resource_group_name = azurerm_resource_group.labrg01.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall_policy" "labfwpolicy01" {
  name                = "labfwpolicy01"
  resource_group_name = azurerm_resource_group.labrg01.name
  location            = azurerm_resource_group.labrg01.location

  # Define your Azure Firewall Policy rules
  # Example: allow outbound traffic from the VNet

}


resource "azurerm_firewall" "labfirewall" {
  name                = "labfirewall"
  location            = azurerm_resource_group.labrg01.location
  resource_group_name = azurerm_resource_group.labrg01.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  # Associate the Firewall with a Firewall Policy
  firewall_policy_id = azurerm_firewall_policy.labfwpolicy01.id

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.AzureFirewallSubnet.id
    public_ip_address_id = azurerm_public_ip.labfwpip.id

  }
}

/*
############### diagnostic settings ############################

resource "azurerm_monitor_diagnostic_setting" "fwdiag" {
  name               = "fwdiag"
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.lablaw.workspace_id
  target_resource_id = azurerm_firewall.labfirewall.id


  enabled_log {
    category = "Azure Firewall Network Rule"
   

    retention_policy {
      enabled = true
      days    = 3
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}

*/
