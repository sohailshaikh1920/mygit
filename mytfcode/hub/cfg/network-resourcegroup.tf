##################################################
#  Deploy Resource Group
##################################################

resource "azurerm_resource_group" "network" {
  name     = "${var.subscriptionname}-network"
  location = var.location
}

/*
##################################################
#  Deploy Resource Group Lock
##################################################

resource "azurerm_management_lock" "network" {
  name       = "resourceGroupDoNotDelete"
  scope      = azurerm_resource_group.network.id
  lock_level = "CanNotDelete"
  notes      = "This Resource Group can not be deleted"
}*/