##################################################
#  Automation Account 1
##################################################

resource "azurerm_automation_account" "aib-automation-account" {
  location            = var.location
  name                = "${azurerm_resource_group.aib-resource-group.name}-aa"
  resource_group_name = azurerm_resource_group.aib-resource-group.name
  sku_name            = "Basic"
  identity {
    type = "SystemAssigned"
  }
}


##################################################
#  Grant the Automation Account rights to the subscription
##################################################

resource "azurerm_role_assignment" "aib-automation-account-rbac" {
  scope                = "/subscriptions/${var.subscriptionid}"
  role_definition_name = "Contributor"
  principal_id         = azurerm_automation_account.aib-automation-account.identity[0].principal_id
}
