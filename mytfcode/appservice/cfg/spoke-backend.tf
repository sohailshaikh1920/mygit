######################################################
# CONFIGURE TERRAFORM AND THE BACKEND STATE STORAGE
######################################################
terraform {
  required_version = ">= 1.2.8"
  backend "azurerm" {
    resource_group_name  = "p-iac-state"
    storage_account_name = "piacdatab6cbef"
    container_name       = "p-we1xlf"
    key                  = "terraform.tfstate"
    subscription_id      = "eeebd4fc-9d93-49d0-9f17-f197ffcafb44"
  }
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.28.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.35.0"
    }
    random = {
      source = "hashicorp/random"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "1.0.0"
    }
  }
}

