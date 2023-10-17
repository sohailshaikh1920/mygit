##################################################
#  Plan 1 Function App 1
##################################################

resource "azurerm_windows_function_app" "plan1-function1" {
  name                       = "${local.subscriptionname}${random_string.random.result}-${var.plan1-function1-name}-func"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.workload.name
  service_plan_id            = azurerm_service_plan.plan1.id
  storage_account_access_key = azurerm_storage_account.storage1.primary_access_key
  storage_account_name       = azurerm_storage_account.storage1.name
  virtual_network_subnet_id  = azurerm_subnet.subnet1.id

  app_settings = merge(local.plan1-function1-app_settings, local.plan1-function1-app_settings_insights)


  identity {
    type = "SystemAssigned"
  }

  site_config {
    ftps_state              = var.plan1-function1-site_config.ftps_state
    vnet_route_all_enabled  = var.plan1-function1-site_config.vnet_route_all_enabled
    scm_minimum_tls_version = var.plan1-function1-site_config.scm_minimum_tls_version
    always_on               = var.plan1-function1-site_config.always_on
    use_32_bit_worker       = var.plan1-function1-site_config.use_32_bit_worker
    application_insights_connection_string  = var.application_insights_connection_string
    application_insights_key = var.application_insights_key

    application_stack {
      dotnet_version = var.plan1-function1-application_stack.dotnet_version
    }
    cors {
      allowed_origins = var.plan1-function1-cors.allowed_origins
    }
  }

  sticky_settings {
    app_setting_names = var.plan1-function1_sticky_settings.app_setting_names
  }
}


##################################################
#  Function App Diagnostics
##################################################

resource "azurerm_monitor_diagnostic_setting" "plan1-function1" {
  name                           = data.azurerm_log_analytics_workspace.central.name
  target_resource_id             = azurerm_windows_function_app.plan1-function1.id
  log_analytics_workspace_id     = data.azurerm_log_analytics_workspace.central.id
  log_analytics_destination_type = "AzureDiagnostics"

  log {
    category = "FunctionAppLogs"
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


######################################################
#  Private DNS data source for Websites
######################################################

data "azurerm_private_dns_zone" "websites" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = "p-dns-pri"
  provider            = azurerm.pdns
}


##################################################
#  Function App Private Endpoint
##################################################

resource "azurerm_private_endpoint" "plan1-function1" {
  name                          = "${local.subscriptionname}${random_string.random.result}-${var.plan1-function1-name}-func-pe"
  custom_network_interface_name = "${local.subscriptionname}${random_string.random.result}-${var.plan1-function1-name}-func-pe-nic"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.workload.name
  subnet_id                     = azurerm_subnet.subnet2.id

  private_service_connection {
    name                           = "privateendpointconnection"
    private_connection_resource_id = azurerm_windows_function_app.plan1-function1.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }


  ip_configuration {
    name               = "ipconfig1"
    private_ip_address = var.plan1-function1-ip
    subresource_name   = "sites"
  }

  private_dns_zone_group {
    name                 = "${local.subscriptionname}${random_string.random.result}-${var.plan1-function1-name}-func-pe"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.websites.id]
  }
}


##################################################
#  Function App Private Endpoint Diagnostics
##################################################

resource "azurerm_monitor_diagnostic_setting" "plan1-function1pe" {
  name                           = data.azurerm_log_analytics_workspace.central.name
  target_resource_id             = "/subscriptions/${var.subscriptionid}/resourceGroups/${var.subscriptionname}/providers/Microsoft.Network/networkInterfaces/${azurerm_private_endpoint.plan1-function1.name}-nic"
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

