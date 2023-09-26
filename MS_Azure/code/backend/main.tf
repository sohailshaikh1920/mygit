resource "azurerm_resource_group" "tobedeleted" {
  name     = "tobedeleted"
  location = "East US"
}

resource "azurerm_storage_account" "mystorageaccount" {

  name                     = "meraccount12345"
  resource_group_name      = azurerm_resource_group.tobedeleted.name
  location                 = azurerm_resource_group.tobedeleted.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

resource "azurerm_storage_container" "container" {
  name                  = "mycontainer"
  storage_account_name  = azurerm_storage_account.mystorageaccount.name
  container_access_type = "private"
}