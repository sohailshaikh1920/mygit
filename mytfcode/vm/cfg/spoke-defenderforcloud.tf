##################################################
#  Deploy Defender for Cloud
##################################################
resource "azurerm_security_center_subscription_pricing" "virtualmachines" {
  tier          = "Standard" # set to Free to toggle off, destroy command itself wont do it. Set Standard to toggle it on
  resource_type = "VirtualMachines"
}
resource "azurerm_security_center_subscription_pricing" "appservices" {
  tier          = "Free" # set to Free to toggle off, destroy command itself wont do it. Set Standard to toggle it on
  resource_type = "AppServices"
}
resource "azurerm_security_center_subscription_pricing" "keyvaults" {
  tier          = "Standard" # set to Free to toggle off, destroy command itself wont do it. Set Standard to toggle it on
  resource_type = "KeyVaults"
}
resource "azurerm_security_center_subscription_pricing" "storageaccounts" {
  tier          = "Standard" # set to Free to toggle off, destroy command itself wont do it. Set Standard to toggle it on
  resource_type = "StorageAccounts"
}
resource "azurerm_security_center_subscription_pricing" "arm" {
  tier          = "Standard" # set to Free to toggle off, destroy command itself wont do it. Set Standard to toggle it on
  resource_type = "Arm"
}
resource "azurerm_security_center_subscription_pricing" "dns" {
  tier          = "Free" # set to Free to toggle off, destroy command itself wont do it. Set Standard to toggle it on
  resource_type = "Dns"
}
resource "azurerm_security_center_subscription_pricing" "sqlservers" {
  tier          = "Free"       # set to Free to toggle off, destroy command itself wont do it. Set Standard to toggle it on
  resource_type = "SqlServers" # not SQL on VMs
}
resource "azurerm_security_center_subscription_pricing" "sqlserversvirtualmachine" {
  tier          = "Free" # set to Free to toggle off, destroy command itself wont do it. Set Standard to toggle it on
  resource_type = "SqlServerVirtualMachines"
}
resource "azurerm_security_center_subscription_pricing" "opensourcerelationaldatabases" {
  tier          = "Free" # set to Free to toggle off, destroy command itself wont do it. Set Standard to toggle it on
  resource_type = "OpenSourceRelationalDatabases"
}


########################################
#  Toggle on/off Servers P1 Plan
########################################
resource "azapi_resource_action" "virtualmachines" {
  type        = "Microsoft.Security/pricings@2022-03-01"
  method      = "PUT"
  resource_id = "/subscriptions/${var.subscriptionid}/providers/Microsoft.Security/pricings/VirtualMachines"
  body = jsonencode({
    properties = {
      subPlan     = "P1"
      pricingTier = "Standard" # set Free to toggle off
    }
  })
}
########################################
#  Toggle on/off CSPM. Free as standard
########################################
resource "azapi_resource_action" "cspm" {
  type        = "Microsoft.Security/pricings@2022-03-01"
  method      = "PUT"
  resource_id = "/subscriptions/${var.subscriptionid}/providers/Microsoft.Security/pricings/CloudPosture"
  body = jsonencode({
    properties = {
      pricingTier = "Free" # set Free to toggle off
    }
  })
}
##################################################
#  Setting up security contact
##################################################
resource "azapi_resource_action" "securitycontact" {
  type        = "Microsoft.Security/securityContacts@2020-01-01-preview"
  method      = "PUT"
  resource_id = "/subscriptions/${var.subscriptionid}/providers/Microsoft.Security/securityContacts/default"
  body = jsonencode({
    properties = {
      emails = var.security_incident_email
      notificationsByRole = {
        state = "On"
        roles = ["Owner", "Contributor"]
      }
      alertNotifications = {
        state           = "On"
        minimalSeverity = "Medium"
      }
    }
  })
}


