##################################################
#  Microsoft Defender for Cloud
##################################################

# Plans

plan_cspm               = "Standard"
plan_server             = "Standard"
plan_server_subplan     = "P1"
plan_appservice         = "Standard"
plan_database           = "Standard"
plan_databaseservers    = "Standard"
plan_databaseopensource = "Standard"
plan_cosmosdb           = "Standard" # Not working yet
plan_storage            = "Standard"
plan_storage_subplan    = "PerTransaction"
plan_containers         = "Standard"
plan_keyvault           = "Standard"
plan_arm                = "Standard"
plan_dns                = "Standard"

# Integrations

integration_mcas     = true
integration_wdatp    = true
integration_sentinel = false

# Security Contacts

security_incident_email = "incidents@montelgroup.com"

# Auto-provisioning

auto-provisioning = "On"

#  Vulnerability Assessment Auto-provisioning

va-auto-provisioning = "mdeTvm" # Not working yet
