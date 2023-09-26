resource "azurerm_resource_group" "labrg01" {
  name     = "labrg-resources"
  location = var.region
}