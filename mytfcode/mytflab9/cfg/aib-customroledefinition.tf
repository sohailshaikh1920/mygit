##################################################
#  Custom role Definition for Azure Image Builder
##################################################

resource "azurerm_role_definition" "aib-customroledefinition" {
  name        = "Azure Image Builder Custom Role"
  scope       = azurerm_resource_group.aib-resource-group.id
  description = "Image Builder access to create resources for the image build, you should delete or split out as appropriate"

  permissions {
    actions = [
      "Microsoft.Compute/galleries/read",
      "Microsoft.Compute/galleries/images/read",
      "Microsoft.Compute/galleries/images/versions/read",
      "Microsoft.Compute/galleries/images/versions/write",

      "Microsoft.Compute/images/write",
      "Microsoft.Compute/images/read",
      "Microsoft.Compute/images/delete"
    ]
    not_actions = []
  }
}