##################################################
#  Azure Automation Account 1 Schedule 1
##################################################

resource "azurerm_automation_schedule" "schedule1" {
  name                    = var.aib-automationrunbook-schedule1-name
  resource_group_name     = azurerm_resource_group.aib-resource-group.name
  automation_account_name = azurerm_automation_account.aib-automation-account.name
  frequency               = var.aib-automationrunbook-schedule1-frequency
  month_days              = var.aib-automationrunbook-schedule1-month_days
  timezone                = var.aib-automationrunbook-schedule1-timezone
}