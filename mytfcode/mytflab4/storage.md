resource "azurerm_storage_account" "labstorage" {
  name                     = "importtestkaro"
  resource_group_name      = azurerm_resource_group.labrg01.name
  location                 = azurerm_resource_group.labrg01.location
  account_tier             = "Standard"
  account_replication_type = "LRS"


}

resource "azurerm_storage_container" "labcontainer1" {
  name                  = var.container1
  storage_account_name  = azurerm_storage_account.labstorage.name
  container_access_type = "container"
}


resource "azurerm_storage_container" "labcontainer2" {
  name                  = "$web"
  storage_account_name  = azurerm_storage_account.labstorage.name
  container_access_type = "container"
}



