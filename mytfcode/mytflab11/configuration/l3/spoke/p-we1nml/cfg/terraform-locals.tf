locals {
  subscriptionname = replace(var.subscriptionname, "-", "")

  # Key Vault Policies Created Using IDs From Created Resources 

  current_subscription_kv_policy = {
    "${data.azurerm_client_config.current.object_id}" = {
      key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey"]
      secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
      certificate_permissions = ["Get", "List"]
    }
  }

/* 
  # Plan 1 Function App 1 Generic Application Settings

  plan1-function1-app_settings = {
    WEBSITE_TIME_ZONE                                 = "W. Europe Standard Time"
    "AzureWebJobs.Fetch_HEL_DeutschlandWest.Disabled" = "1"
    "AzureWebJobs.Fetch_HEL_Rheinschiene.Disabled"    = "1"
    "AzureWebJobs.Fetch_HSL_DeutschlandWest.Disabled" = "1"
    "AzureWebJobs.Fetch_HSL_Rheinschiene.Disabled"    = "1"
    ASPNETCORE_ENVIRONMENT                            = "Production"
    KeyVaultUri                                       = "https://p-we1gnx5ouupz-kv.vault.azure.net/"
    GanexoBaseUrl                                     = "http://13.93.53.230:4100/ganexo_api/fwd/"
    Montel__Logging__ApplicationName                  = "GanexoFunctions"
    Montel__Logging__ElasticSearchEnabled             = "true"
    Montel__Logging__ElasticSearchIndexFormat         = "log-serilog-development"
    Montel__Logging__ElasticSearchUri                 = "https://mnt-p-euw-elasticsearch-cl.es.westeurope.azure.elastic-cloud.com:9243/"
  }

  # Plan 1 Function App 1 Application Insights App Settings

  plan1-function1-app_settings_insights = {
    APPINSIGHTS_INSTRUMENTATIONKEY             = "${azurerm_application_insights.appinsights1.instrumentation_key}"
    APPLICATIONINSIGHTS_CONNECTION_STRING      = "${azurerm_application_insights.appinsights1.connection_string}"
    ApplicationInsightsAgent_EXTENSION_VERSION = "~3"
    XDT_MicrosoftApplicationInsights_Mode      = "default"
  }

*/

}




