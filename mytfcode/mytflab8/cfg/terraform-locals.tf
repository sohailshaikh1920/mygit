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


  # Plan 1 Function App 1 Generic Application Settings

  plan1-function1-app_settings = {
    WEBSITE_TIME_ZONE                                                  = "Central European Standard Time"
    #KeyVaultUri                                                        = "https://p-we1nmlju1rjc-kv.vault.azure.net/"
    AzureFunctionsJobHost__extensions__serviceBus__maxMessageBatchSize = "10"
    AzureFunctionsJobHost__logging__logLevel__newsmail_function_app    = "Debug"
    Db__ConnectionString                                                = "@Microsoft.KeyVault(SecretUri=https://p-we1nmlju1rjc-kv.vault.azure.net/secrets/Db--ConnectionString--Dev/)"
    Debug__DebugEmailsEnabled                                           = "false"
    Debug__OutputQueueName                                              = "debug-emails"
    Debug__SendDebugEmailsTo                                            = "evgenia@montel.no"
    Debug__RunTime                                                      = "2023-06-26 07:00:00"
    NewsApi__BaseUrl                                                    = "https://mnt-d-euw-news-api-svc.azurewebsites.net"
    NewsApi__ClientId                                                   = "297e3ed5-09ec-43c6-b88b-a2a2e68f43fb"
    NewsApi__ClientSecret                                               = "@Microsoft.KeyVault(SecretUri=https://p-we1nmlju1rjc-kv.vault.azure.net/secrets/NewsApi--ClientSecret/)"
    NewsApi__TokenProviderUrl                                           = "https://account-dev.montelnews.com"
    SendGrid__AllowToSendEmails                                         = "false"
    SendGrid__ApiKey                                                    = "@Microsoft.KeyVault(SecretUri=https://p-we1nmlju1rjc-kv.vault.azure.net/secrets/SendGrid--ApiKey/)"
    SendGrid__FromEmail                                                 = "noreply@montelnews.com"
    SendGrid__FromName                                                  = "Montel Newsmail Prod"
    SendGrid__TemplateId                                                = "d-e1841408136645e689c1ff22bfc3b180"
    SendGrid__UnsubscribeGroupId                                        = "22296"
    ServiceBus__ConnectionString                                        = "@Microsoft.KeyVault(SecretUri=https://p-we1nmlju1rjc-kv.vault.azure.net/secrets/ServiceBus--ConnectionString/)"
    ServiceBus__QueueName                                               = "subscription-handler-tasks"
    TimeTriggerCronExpression__Additional                               = "0 15 16 * * 1-5"
    TimeTriggerCronExpression__Main                                     = "0 0 7,12,16,19 * * 1-5"
    WEBSITE_ENABLE_SYNC_UPDATE_SITE                                    = "true"
    WEBSITE_RUN_FROM_PACKAGE                                           = "1"
  

  }

  
  # Plan 1 Function App 1 Application Insights App Settings

  plan1-function1-app_settings_insights = {
    APPINSIGHTS_INSTRUMENTATIONKEY             = "${azurerm_application_insights.appinsights1.instrumentation_key}"
    APPLICATIONINSIGHTS_CONNECTION_STRING      = "${azurerm_application_insights.appinsights1.connection_string}"
    ApplicationInsightsAgent_EXTENSION_VERSION = "~3"
    XDT_MicrosoftApplicationInsights_Mode      = "default"
  }



}




