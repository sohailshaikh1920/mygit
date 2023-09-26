######################################################
# Central loganalytics data source
######################################################

data "azurerm_log_analytics_workspace" "central" {
  name                = var.central_log_analytics_workspace_name
  resource_group_name = "p-mgt-mon"
  provider            = azurerm.pmgt
}


######################################################
#App Insights loganalytics data source
######################################################

data "azurerm_log_analytics_workspace" "app_insights" {
  name                = var.app_insights_log_analytics_workspace_name
  resource_group_name = "p-mgt-apm"
  provider            = azurerm.pmgt
}


######################################################
# Governance Storage Account data source
######################################################

data "azurerm_storage_account" "governance" {
  name                = var.governance_storage_account_name
  resource_group_name = "p-gov-log"
  provider            = azurerm.pgov
}


######################################################
# Get Tenant and current subscription details
######################################################

data "azurerm_client_config" "current" {}



################################################################
# Get Management Group under which current Sub needs to be added
################################################################

data "azurerm_management_group" "managementgroup" {
  name = var.managementgroup
}


################################################################
# Get shared networking Key Vault from p-net
################################################################

data "azurerm_key_vault" "SharedNetworkingKeyVault" {
  name                = var.shared_networking_key_vault_name
  resource_group_name = "p-net-kv"
  provider            = azurerm.pnet
}