################################################
#  Setting subscription diagnostics
################################################

resource "azurerm_monitor_diagnostic_setting" "subscription_diagnostic_settings" {
  name                       = data.azurerm_log_analytics_workspace.central.name
  target_resource_id         = "/subscriptions/${var.subscriptionid}"
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.central.id
  storage_account_id         = data.azurerm_storage_account.governance.id

  enabled_log {
    category = "Administrative"
  }
  enabled_log {
    category = "Security"
  }
  enabled_log {
    category = "ServiceHealth"
  }
  enabled_log {
    category = "Alert"
  }
  enabled_log {
    category = "Recommendation"
  }
  enabled_log {
    category = "Policy"
  }
  enabled_log {
    category = "Autoscale"
  }
  enabled_log {
    category = "ResourceHealth"
  }
}
