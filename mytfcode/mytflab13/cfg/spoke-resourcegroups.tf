##################################################
#  Deploy Network Resource Group with Resource Group Lock
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



##################################################
#  Deploy Primary Resource Group with Resource Group Lock
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


################################################
#  VM Diagnostics Storage Account
################################################
resource "azurerm_storage_account" "vm_diagnostics" {
  name                = "${local.subscriptionname}diag${random_string.random.result}"
  resource_group_name = azurerm_resource_group.primary.name
  location            = azurerm_resource_group.primary.location

  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "ZRS"
  enable_https_traffic_only = true
}
