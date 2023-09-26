locals {
  galleryName = replace("${azurerm_resource_group.aib-resource-group.name}-gal", "-", "")
}