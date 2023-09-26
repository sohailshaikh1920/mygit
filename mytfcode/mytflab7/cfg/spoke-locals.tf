locals {
  subscriptionname = replace(var.subscriptionname, "-", "")

  current_subscription_kv_policy = {
    "${data.azurerm_client_config.current.object_id}" = {
      key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey"]
      secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
      certificate_permissions = ["Get", "List"]
    }
  }

  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY        = "${azurerm_application_insights.montel-xlf.instrumentation_key}"
    APPLICATIONINSIGHTS_CONNECTION_STRING = "${azurerm_application_insights.montel-xlf.connection_string}"
    //WEBSITE_TIME_ZONE                     = "W. Europe Standard Time"
  }

  app_settings_insights = {
    APPINSIGHTS_PROFILERFEATURE_VERSION             = "1.0.0"
    APPINSIGHTS_SNAPSHOTFEATURE_VERSION             = "1.0.0"
    ApplicationInsightsAgent_EXTENSION_VERSION      = "~2"
    DiagnosticServices_EXTENSION_VERSION            = "~3"
    InstrumentationEngine_EXTENSION_VERSION         = "disabled"
    SnapshotDebugger_EXTENSION_VERSION              = "disabled"
    XDT_MicrosoftApplicationInsights_BaseExtensions = "disabled"
    XDT_MicrosoftApplicationInsights_Java           = "1"
    XDT_MicrosoftApplicationInsights_Mode           = "recommended"
    XDT_MicrosoftApplicationInsights_NodeJS         = "1"
    XDT_MicrosoftApplicationInsights_PreemptSdk     = "disabled"
  }
}
