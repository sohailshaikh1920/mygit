##################################################
#  Create a managed identity for working with images
##################################################

resource "azurerm_user_assigned_identity" "aib-managed-identity" {
  resource_group_name = azurerm_resource_group.aib-resource-group.name
  location            = var.location
  name                = "${azurerm_resource_group.aib-resource-group.name}-id"
}


##################################################
#  Assign a custom role to the managed identity
##################################################

resource "azurerm_role_assignment" "aib-managed-identity" {
  scope              = azurerm_resource_group.aib-resource-group.id
  role_definition_id = azurerm_role_definition.aib-customroledefinition.role_definition_resource_id
  principal_id       = azurerm_user_assigned_identity.aib-managed-identity.principal_id
}