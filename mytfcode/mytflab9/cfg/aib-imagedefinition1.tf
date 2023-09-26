##################################################
#  Image Definition 1
##################################################

resource "azurerm_shared_image" "aib-image-definition1" {
  gallery_name        = azurerm_shared_image_gallery.aib-compute-gallery.name
  location            = var.location
  name                = "${azurerm_resource_group.aib-resource-group.name}-${var.aib-imagedefinition1-definition-name}-idef"
  os_type             = var.aib-imagedefinition1-definition-ostype
  resource_group_name = azurerm_resource_group.aib-resource-group.name
  hyper_v_generation  = var.aib-imagedefinition1-definition-hyper_v_generation

  identifier {
    offer     = var.aib-imagedefinition1-definition-offer
    publisher = var.subscriptionname
    sku       = var.aib-imagedefinition1-definition-sku
  }
}
