##################################################
#  Plan 1
##################################################

resource "azurerm_service_plan" "plan1" {
  location            = var.location
  resource_group_name = azurerm_resource_group.workload.name
  name                = "${local.subscriptionname}${random_string.random.result}-asp"
  os_type             = var.plan1-os_type
  sku_name            = var.plan1-sku_name
}


##################################################
#  Plan 1 Diagnostics
##################################################

resource "azurerm_monitor_diagnostic_setting" "plan1" {
  name                           = data.azurerm_log_analytics_workspace.central.name
  target_resource_id             = azurerm_service_plan.plan1.id
  log_analytics_workspace_id     = data.azurerm_log_analytics_workspace.central.id
  log_analytics_destination_type = "AzureDiagnostics"

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
}
