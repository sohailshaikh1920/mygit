############################################################################################################################################
# Section to create "App Services Environment V3" and associated resources
############################################################################################################################################
resource "azurerm_app_service_environment_v3" "environment" {
  name                                   = var.subscriptionname
  resource_group_name                    = azurerm_resource_group.primary.name
  subnet_id                              = azurerm_subnet.ase.id
  internal_load_balancing_mode           = "Web, Publishing"
  allow_new_private_endpoint_connections = false
}

resource "azurerm_private_dns_a_record" "add_ase_asterisk_record_private_dns_zone" {
  provider            = azurerm.pdns
  name                = "*"
  zone_name           = "${azurerm_app_service_environment_v3.environment.name}.appserviceenvironment.net"
  resource_group_name = "p-dns-pri"
  ttl                 = 3600
  records             = [join(", ", azurerm_app_service_environment_v3.environment.internal_inbound_ip_addresses)]
}

resource "azurerm_private_dns_a_record" "add_ase_atrate_record_private_dns_zone" {
  provider            = azurerm.pdns
  name                = "@"
  zone_name           = "${azurerm_app_service_environment_v3.environment.name}.appserviceenvironment.net"
  resource_group_name = "p-dns-pri"
  ttl                 = 3600
  records             = [join(", ", azurerm_app_service_environment_v3.environment.internal_inbound_ip_addresses)]
}

resource "azurerm_private_dns_a_record" "add_ase_scm_record_private_dns_zone" {
  provider            = azurerm.pdns
  name                = "*.scm"
  zone_name           = "${azurerm_app_service_environment_v3.environment.name}.appserviceenvironment.net"
  resource_group_name = "p-dns-pri"
  ttl                 = 3600
  records             = [join(", ", azurerm_app_service_environment_v3.environment.internal_inbound_ip_addresses)]
}

resource "azurerm_monitor_diagnostic_setting" "environment" {
  name                           = data.azurerm_log_analytics_workspace.central.name
  target_resource_id             = azurerm_app_service_environment_v3.environment.id
  log_analytics_workspace_id     = data.azurerm_log_analytics_workspace.central.id
  log_analytics_destination_type = "AzureDiagnostics"

  log {
    category = "AppServiceEnvironmentPlatformLogs"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
}


############################################################################################################################################
# Section to create "App Services Plan" and associated resourcescls

############################################################################################################################################
resource "azurerm_service_plan" "plan" {
  name                       = "${var.subscriptionname}-plan"
  location                   = azurerm_resource_group.primary.location
  resource_group_name        = azurerm_resource_group.primary.name
  os_type                    = var.app_service_plan.kind
  sku_name                   = var.app_service_plan.size
  app_service_environment_id = azurerm_app_service_environment_v3.environment.id
  worker_count               = var.app_service_plan.capacity
}

resource "azurerm_monitor_diagnostic_setting" "plan" {
  name                           = data.azurerm_log_analytics_workspace.central.name
  target_resource_id             = azurerm_service_plan.plan.id
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
