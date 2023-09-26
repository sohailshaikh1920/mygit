##################################################
#  Deploy Resource Group for Azure Image Builder
##################################################

resource "azurerm_resource_group" "aib-resource-group" {
  name     = "${var.subscriptionname}-aib"
  location = var.location

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

##################################################
#  Assign a resource group lock to prevent deletion
##################################################

/*
resource "azurerm_management_lock" "primary" {
  name       = "resourceGroupDoNotDelete"
  scope      = azurerm_resource_group.aib-resource-group.id
  lock_level = "CanNotDelete"
  notes      = "This Resource Group can not be deleted"
}
*/
