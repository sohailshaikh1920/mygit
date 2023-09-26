##################################################
#  Automation Account 1 PowerShell Modules
##################################################


##################################################
#  Add Az.Accounts PowerShell Module to Automation Account
##################################################

resource "azurerm_automation_module" "az-accounts" {
  automation_account_name = azurerm_automation_account.aib-automation-account.name
  name                    = "Az.Accounts"
  resource_group_name     = azurerm_resource_group.aib-resource-group.name

  module_link {
    uri = "https://www.powershellgallery.com/api/v2/package/az.accounts"
  }
}


##################################################
#  Add Az.ImageBuilder PowerShell Module to Automation Account
##################################################

resource "azurerm_automation_module" "az-imagebuilder" {
  automation_account_name = azurerm_automation_account.aib-automation-account.name
  name                    = "Az.ImageBuilder"
  resource_group_name     = azurerm_resource_group.aib-resource-group.name

  module_link {
    uri = "https://www.powershellgallery.com/api/v2/package/az.imageBuilder"
  }

  depends_on = [
    azurerm_automation_module.az-accounts,
  ]
}
