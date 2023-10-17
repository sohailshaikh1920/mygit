################################################
#  Setting subscription diagnostics
################################################

resource "azurerm_monitor_diagnostic_setting" "subscription_diagnostic_settings" {
  name                       = data.azurerm_log_analytics_workspace.central.name
  target_resource_id         = "/subscriptions/${var.subscriptionid}"
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.central.id
  storage_account_id         = data.azurerm_storage_account.governance.id

  log {
    category = "Administrative"
    enabled  = true
  }
  log {
    category = "Security"
    enabled  = true
  }
  log {
    category = "ServiceHealth"
    enabled  = true
  }
  log {
    category = "Alert"
    enabled  = true
  }
  log {
    category = "Recommendation"
    enabled  = true
  }
  log {
    category = "Policy"
    enabled  = true
  }
  log {
    category = "Autoscale"
    enabled  = true
  }
  log {
    category = "ResourceHealth"
    enabled  = true
  }
}
