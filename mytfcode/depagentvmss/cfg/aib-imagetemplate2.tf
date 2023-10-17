##################################################
#  Image Template 2
##################################################

## NOTE ##

# This code should be implemented once only. An upgrade of an image template is not supported.
# The use of ignore_changes = all marks the state of this object to deploy once and then to ignore it until destruction.

resource "azurerm_resource_group_template_deployment" "image-template2" {
  lifecycle {
    ignore_changes = all
  }
  name                = "image-template2"
  resource_group_name = azurerm_resource_group.aib-resource-group.name
  deployment_mode     = "Incremental"
  parameters_content = jsonencode({
    "imageTemplateName" = {
      value = "${azurerm_resource_group.aib-resource-group.name}-${var.aib-imagedefinition2-definition-name}-it"
    },
    "managedUserId" = {
      value = azurerm_user_assigned_identity.aib-managed-identity.id
    },
    "imageDefinitionId" = {
      value = azurerm_shared_image.aib-image-definition2.id
    },
    "location" = {
      value = var.location
    }
  })
  template_content = "${file("aib-imagetemplate2.json")}"
}
