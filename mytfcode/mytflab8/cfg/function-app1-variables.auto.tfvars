##################################################
#  Plan 1 Function App 1
##################################################

plan1-function1-name = "newsmail"

plan1-function1-client_certificate_mode     = "Required"
plan1-function1-functions_extension_version = "~4"
plan1-function1-builtin_logging_enabled     = false
plan1-function1-https_only                  = true

plan1-function1-site_config = {
  ftps_state              = "AllAllowed"
  scm_minimum_tls_version = "1.2"
  vnet_route_all_enabled  = true
  always_on               = false
  use_32_bit_worker       = false
}

plan1-function1-application_stack = {
  dotnet_version = "v6.0"
}

plan1-function1-cors = {
  allowed_origins = ["https://portal.azure.com"]
}

plan1-function1_sticky_settings = {
  app_setting_names = [
    "APPINSIGHTS_INSTRUMENTATIONKEY",
    "APPINSIGHTS_PROFILERFEATURE_VERSION",
    "APPINSIGHTS_SNAPSHOTFEATURE_VERSION",
    "ApplicationInsightsAgent_EXTENSION_VERSION",
    "APPLICATIONINSIGHTS_CONFIGURATION_CONTENT",
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
    "XDT_MicrosoftApplicationInsights_BaseExtensions",


  ]

}

application_insights_connection_string = "InstrumentationKey=dfae0464-c33f-446f-b0c4-93fa40ba797b;IngestionEndpoint=https://westeurope-5.in.applicationinsights.azure.com/;LiveEndpoint=https://westeurope.livediagnostics.monitor.azure.com/"
application_insights_key = "dfae0464-c33f-446f-b0c4-93fa40ba797b"


