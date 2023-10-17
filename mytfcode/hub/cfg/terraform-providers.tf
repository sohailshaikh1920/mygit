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

provider "azurerm" {
  subscription_id = var.subscriptionid
  features {}
  alias               = "pstorageaad"
  partner_id          = "d40f4895-5a21-5612-aa15-69cd25571694"
  storage_use_azuread = true
}



################################################
# Hub Subscription
################################################

provider "azurerm" {
  subscription_id = var.subscriptionid_vdchub
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

################################################
# GlobalNet Subscription
################################################

provider "azurerm" {
  subscription_id = var.subscriptionid_pnet
  features {}
  alias      = "pnet"
  partner_id = "d40f4895-5a21-5612-aa15-69cd25571694"
}
