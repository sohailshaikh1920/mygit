##################################################
#  Deploy Resource Group with Resource Group Lock
##################################################
resource "azurerm_resource_group" "network" {
  name     = "${var.subscriptionname}-network"
  location = var.location

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_management_lock" "network" {
  name       = "resourceGroupDoNotDelete"
  scope      = azurerm_resource_group.network.id
  lock_level = "CanNotDelete"
  notes      = "This Resource Group can not be deleted"
}

##################################################
#  Deploy Resource Group with Resource Group Lock
##################################################
resource "azurerm_resource_group" "primary" {
  name     = var.subscriptionname
  location = var.location

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_management_lock" "primary" {
  name       = "resourceGroupDoNotDelete"
  scope      = azurerm_resource_group.primary.id
  lock_level = "CanNotDelete"
  notes      = "This Resource Group can not be deleted"
}

##################################################
#  Deploy Mon Resource Group with Resource Group Lock
##################################################
resource "azurerm_resource_group" "mon" {
  name     = "${var.subscriptionname}-mon"
  location = var.location

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}



resource "azurerm_management_lock" "mon" {
  name       = "resourceGroupDoNotDelete"
  scope      = azurerm_resource_group.mon.id
  lock_level = "CanNotDelete"
  notes      = "This Resource Group can not be deleted"
}
