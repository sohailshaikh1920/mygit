terraform {

  backend "azurerm" {

    resource_group_name  = "tobedeleted"
    storage_account_name = "meraccount12345"
    container_name       = "mycontainer"
    key                  = "tfstate"

  }
}