
############################################################################################################################################
# Section to create "Application Insghts" and associated resources
############################################################################################################################################

resource "azurerm_application_insights" "appinsights1" {
  name                = "${var.subscriptionname}${random_string.random.result}-insights"
  location            = azurerm_resource_group.workload.location
  resource_group_name = azurerm_resource_group.workload.name
  workspace_id        = data.azurerm_log_analytics_workspace.app_insights.id
  application_type    = "web"
}

