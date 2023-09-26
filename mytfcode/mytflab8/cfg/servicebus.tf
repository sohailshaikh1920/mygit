resource "azurerm_servicebus_namespace" "servicebus1" {
  name                = "${var.servicebus1-name}-sbus"
  location            = azurerm_resource_group.workload.location
  resource_group_name = azurerm_resource_group.workload.name
  sku                 = "Standard"

}

resource "azurerm_servicebus_queue" "queue1" {
  name         = var.servicebusqueue1-name
  namespace_id = azurerm_servicebus_namespace.servicebus1.id

  enable_partitioning = true
}

resource "azurerm_servicebus_queue" "queue2" {
  name         = var.servicebusqueue2-name
  namespace_id = azurerm_servicebus_namespace.servicebus1.id

  enable_partitioning = true
}