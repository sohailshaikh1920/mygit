terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.20.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  subscription_id = "4cce77b1-65bc-4255-9570-07178450d61f"
  client_id = "08f0d48f-1a47-4bdf-9f70-b41390c4a627"
  client_secret = "GZz8Q~l.Nw0JbGWQORN~Wi3X4t8HrsDr5VyitaWX"
  tenant_id = "67481c72-d897-4db4-a7fa-b96d76dfb545"
  features {}
}
