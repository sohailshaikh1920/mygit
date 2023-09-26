##################################################
#  Shared Compute Gallery
##################################################



resource "azurerm_shared_image_gallery" "aib-compute-gallery" {
  location            = var.location
  name                = local.galleryName
  resource_group_name = azurerm_resource_group.aib-resource-group.name
}