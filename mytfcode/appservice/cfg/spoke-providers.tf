################################################
# Central Log Analytics Subscription
################################################
provider "azurerm" {
  subscription_id = var.subscriptionid_mgt
  features {}
  alias      = "pmgt"
  partner_id = "d40f4895-5a21-5612-aa15-69cd25571694"
}


################################################
# Governance Storage Account Subscription
################################################
provider "azurerm" {
  subscription_id = var.subscriptionid_gov
  features {}
  alias      = "pgov"
  partner_id = "d40f4895-5a21-5612-aa15-69cd25571694"
}


################################################
# Autenticate to Azure on Spoke subscription
################################################
provider "azurerm" {
  subscription_id = var.subscriptionid
  features {}
  partner_id = "d40f4895-5a21-5612-aa15-69cd25571694"
}



################################################
# Hub Subscription
################################################
provider "azurerm" {
  subscription_id = var.subscriptionid_we1net
  features {}
  alias      = "pwe1net"
  partner_id = "d40f4895-5a21-5612-aa15-69cd25571694"
}



################################################
# DNS Subscription
################################################
provider "azurerm" {
  subscription_id = var.subscriptionid_pdns
  features {}
  alias      = "pdns"
  partner_id = "d40f4895-5a21-5612-aa15-69cd25571694"
}

