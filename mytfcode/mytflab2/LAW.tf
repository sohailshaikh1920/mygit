resource "azurerm_log_analytics_workspace" "lablaw" {
  name                = "lablaw"
  location            = azurerm_resource_group.labrg01.location
  resource_group_name = azurerm_resource_group.labrg01.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}