
##################################################
#  Defender Plans
##################################################

#  Defender CSPM

resource "azurerm_security_center_subscription_pricing" "plan_cspm" {
  tier          = var.plan_cspm
  resource_type = "CloudPosture"
}


#  Servers

resource "azurerm_security_center_subscription_pricing" "plan_servers" {
  tier          = var.plan_server
  resource_type = "VirtualMachines"
  subplan       = var.plan_server_subplan #  P1 or P2
}


#  App Service

resource "azurerm_security_center_subscription_pricing" "plan_appservice" {
  tier          = var.plan_appservice
  resource_type = "AppServices"
}


#  Database - Azure SQL


resource "azurerm_security_center_subscription_pricing" "plan_database" {
  tier          = var.plan_database
  resource_type = "SqlServers"
}

#  Database - SQL Server on VMs


resource "azurerm_security_center_subscription_pricing" "plan_databaseservers" {
  tier          = var.plan_databaseservers
  resource_type = "SqlServerVirtualMachines"
}

#  Database - Opensource PaaS


resource "azurerm_security_center_subscription_pricing" "plan_databaseopensource" {
  tier          = var.plan_databaseopensource
  resource_type = "OpenSourceRelationalDatabases"
}

#  Database - Cosmos DB

/*

#  The native provider doesn't support it yet

resource "azapi_resource_action" "plan_cosmosdb" {
  type        = "Microsoft.Security/pricings@2022-03-01"
  method      = "PUT"
  resource_id = "/subscriptions/${var.subscriptionid}/providers/Microsoft.Security/pricings/CosmosDbs"
  body = jsonencode({
    properties = {
      pricingTier = "Standard"
    }
  })
}

*/


#  Storage

resource "azurerm_security_center_subscription_pricing" "plan_storage" {
  tier          = var.plan_storage
  resource_type = "StorageAccounts"
  subplan       = var.plan_storage_subplan #  PerTransaction (default) or PerStorageAccount (only when >4.5 million transactions/month)
}


#  Containers 

resource "azurerm_security_center_subscription_pricing" "plan_containers" {
  tier          = var.plan_containers
  resource_type = "Containers"
}

#  Key Vault

resource "azurerm_security_center_subscription_pricing" "plan_keyvault" {
  tier          = var.plan_keyvault
  resource_type = "KeyVaults"
}


#  Resource Manager

resource "azurerm_security_center_subscription_pricing" "plan_arm" {
  tier          = var.plan_arm
  resource_type = "Arm"
}


#  DNS

resource "azurerm_security_center_subscription_pricing" "plan_dns" {
  tier          = var.plan_dns
  resource_type = "Dns"
}



##################################################
# Integrations
##################################################

#  Microsoft Defender for Cloud Apps 

#  This is enabled by default. Setting it to true again causes a state import failure.

/*
resource "azurerm_security_center_setting" "integration_mcas" {
  setting_name = "MCAS"
  enabled      = var.integration_mcas
}
*/


/*
#  Microsoft Defender for Endpoint

#  This is enabled by default. Setting it to true again causes a state import failure.

resource "azurerm_security_center_setting" "integration_wdatp" {
  setting_name = "WDATP"
  enabled      = var.integration_wdatp
}
*/


/*
#  Sentinel

#  This is disabled by default. Setting it to true again causes a state import failure.

resource "azurerm_security_center_setting" "integration_sentinel" {
  setting_name = "Sentinel"
  enabled      = var.integration_sentinel
}
*/


##################################################
#  Security Contacts
##################################################

resource "azurerm_security_center_contact" "contact" {
  email               = var.security_incident_email
  alert_notifications = true
  alerts_to_admins    = true
}

##################################################
#  Auto-provisioning
##################################################

#  Enable or disable

resource "azurerm_security_center_auto_provisioning" "auto-provisioning" {
  auto_provision = var.auto-provisioning
}


#  Custom Log Analytics Workspace

resource "azurerm_security_center_workspace" "la_workspace" {
  scope        = "/subscriptions/${var.subscriptionid}"
  workspace_id = data.azurerm_log_analytics_workspace.central.id
}

##################################################
#  Vulnerability Assessment Auto-provisioning
##################################################

#  Enable auto-provisioining

#  MDE should use "mdeTvm" as vaType value in the parameters block
#  Qualys should use "default" as vaType value in the parameters block

resource "azurerm_subscription_policy_assignment" "va-auto-provisioning" {
  name                 = "mdc-va-autoprovisioning"
  display_name         = "Configure machines to receive a vulnerability assessment provider"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/13ce0167-8ca6-4048-8e6b-f996402e3c1b"
  subscription_id      = "/subscriptions/${var.subscriptionid}"
  identity {
    type = "SystemAssigned"
  }
  location   = var.location
  parameters = <<PARAMS
{ "vaType": { "value": "mdeTvm" } }
PARAMS
}

#  Assign the Security Admin role to the Managed Identity that will be used to perform the automatic provisioning of the Vulnerability Assessment solution

resource "azurerm_role_assignment" "va-auto-provisioning-identity-role" {
  scope              = "/subscriptions/${var.subscriptionid}"
  role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/fb1c8493-542b-48eb-b624-b4c8fea62acd"
  principal_id       = azurerm_subscription_policy_assignment.va-auto-provisioning.identity[0].principal_id
}
