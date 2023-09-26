################################################
#  Create spoke RBAC Groups
################################################

resource "azuread_group" "owner" {
  display_name     = "AZ RBAC sub ${var.subscriptionname} Owner"
  description      = "Lets you manage everything in this subscription, including access to resources."
  prevent_duplicate_names  = true
  security_enabled = true
}

resource "azuread_group" "contributor" {
  display_name     = "AZ RBAC sub ${var.subscriptionname} Contributor"
  description      = "Lets you contribute in this subscription."
  prevent_duplicate_names  = true
  security_enabled = true
}

resource "azuread_group" "reader" {
  display_name     = "AZ RBAC sub ${var.subscriptionname} Reader"
  description      = "Lets you read resources in this subscription."
  prevent_duplicate_names  = true
  security_enabled = true
}


################################################
#  Add RBAC to subscription roles
################################################

resource "azurerm_role_assignment" "subscriptionowner" {
  scope                = "/subscriptions/${var.subscriptionid}"
  role_definition_name = "Owner"
  principal_id         = azuread_group.owner.id
}

resource "azurerm_role_assignment" "subscriptioncontributor" {
  scope                = "/subscriptions/${var.subscriptionid}"
  role_definition_name = "Contributor"
  principal_id         = azuread_group.contributor.id
}

resource "azurerm_role_assignment" "subscriptionreader" {
  scope                = "/subscriptions/${var.subscriptionid}"
  role_definition_name = "Reader"
  principal_id         = azuread_group.reader.id
}
