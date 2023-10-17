############################################################################################################################################
# Definition of Montel Online App Services
############################################################################################################################################
resource "azurerm_windows_web_app" "montel-xlf" {
  name                    = "${var.subscriptionname}-montelxlf-app"
  resource_group_name     = azurerm_resource_group.primary.name
  location                = azurerm_resource_group.primary.location
  service_plan_id         = azurerm_service_plan.plan.id
  client_affinity_enabled = true
  app_settings            = merge(local.app_settings, local.app_settings_insights)


  site_config {
    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v4.0"
    }
    websockets_enabled = true
    use_32_bit_worker  = false
  }

  sticky_settings {
    //A list of app_setting names that the Windows Web App will not swap between Slots when a swap operation is triggered
    app_setting_names = [
      "APPINSIGHTS_INSTRUMENTATIONKEY",
      "APPLICATIONINSIGHTS_CONNECTION_STRING ",
      "APPINSIGHTS_PROFILERFEATURE_VERSION",
      "APPINSIGHTS_SNAPSHOTFEATURE_VERSION",
      "ApplicationInsightsAgent_EXTENSION_VERSION",
      "XDT_MicrosoftApplicationInsights_BaseExtensions",
      "DiagnosticServices_EXTENSION_VERSION",
      "InstrumentationEngine_EXTENSION_VERSION",
      "SnapshotDebugger_EXTENSION_VERSION",
      "XDT_MicrosoftApplicationInsights_Mode",
      "XDT_MicrosoftApplicationInsights_PreemptSdk",
      "APPLICATIONINSIGHTS_CONFIGURATION_CONTENT",
      "XDT_MicrosoftApplicationInsightsJava",
      "XDT_MicrosoftApplicationInsights_NodeJS",
    ]
  }

  lifecycle {
    ignore_changes = [
      logs
    ]
  }
}

resource "azurerm_monitor_diagnostic_setting" "montel-xlf" {
  name                           = data.azurerm_log_analytics_workspace.central.name
  target_resource_id             = azurerm_windows_web_app.montel-xlf.id
  log_analytics_workspace_id     = data.azurerm_log_analytics_workspace.central.id
  log_analytics_destination_type = "AzureDiagnostics"

  log {
    category = "AppServiceAntivirusScanAuditLogs"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }

  log {
    category = "AppServiceHTTPLogs"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }

  log {
    category = "AppServiceConsoleLogs"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }

  log {
    category = "AppServiceAppLogs"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }

  log {
    category = "AppServiceFileAuditLogs"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }

  log {
    category = "AppServiceAuditLogs"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }

  log {
    category = "AppServiceIPSecAuditLogs"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }

  log {
    category = "AppServicePlatformLogs"
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


resource "azurerm_windows_web_app_slot" "montel-xlf" {
  name           = "${var.subscriptionname}-montelxlf-app-deploy-slot"
  app_service_id = azurerm_windows_web_app.montel-xlf.id

  site_config {
    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v4.0"
    }
    websockets_enabled = true
    use_32_bit_worker  = false
  }
}

resource "azurerm_monitor_diagnostic_setting" "montel-xlf-slot" {
  name                           = data.azurerm_log_analytics_workspace.central.name
  target_resource_id             = azurerm_windows_web_app_slot.montel-xlf.id
  log_analytics_workspace_id     = data.azurerm_log_analytics_workspace.central.id
  log_analytics_destination_type = "AzureDiagnostics"

  log {
    category = "AppServiceAntivirusScanAuditLogs"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }

  log {
    category = "AppServiceHTTPLogs"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }

  log {
    category = "AppServiceConsoleLogs"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }

  log {
    category = "AppServiceAppLogs"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }

  log {
    category = "AppServiceFileAuditLogs"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }

  log {
    category = "AppServiceAuditLogs"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }

  log {
    category = "AppServiceIPSecAuditLogs"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }

  log {
    category = "AppServicePlatformLogs"
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

############################################################################################################################################
# Section to create "Application Insghts" and associated resources
############################################################################################################################################
resource "azurerm_application_insights" "montel-xlf" {
  name                = "${var.subscriptionname}${random_string.random.result}-insights"
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name
  workspace_id        = data.azurerm_log_analytics_workspace.app_insights.id
  application_type    = "web"
}

