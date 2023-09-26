
################## statefile on storage account ###############################

terraform {

  backend "azurerm" {

    resource_group_name  = "iacstate"
    storage_account_name = "terraformiacsohail"
    container_name       = "iacstate"
    key                  = "terraform.tfstate"

  }
}