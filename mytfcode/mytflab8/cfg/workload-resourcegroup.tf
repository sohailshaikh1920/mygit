##################################################
#  Deploy Resource Group
##################################################

resource "azurerm_resource_group" "workload" {
  name     = var.subscriptionname
  location = var.location

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}


##################################################
#  Deploy Resource Group Lock
##################################################

resource "azurerm_management_lock" "workload" {
  name       = "resourceGroupDoNotDelete"
  scope      = azurerm_resource_group.monitor.id
  lock_level = "CanNotDelete"
  notes      = "This Resource Group can not be deleted"
}