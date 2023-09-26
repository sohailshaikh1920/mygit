################################################
#  All Frontend ASG
################################################
resource "azurerm_application_security_group" "app" {
  name                = "${var.subscriptionname}-network-app-asg"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
}