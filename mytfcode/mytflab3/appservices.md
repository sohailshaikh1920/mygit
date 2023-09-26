

resource "azurerm_service_plan" "labserviceplan" {
  name                = "labappserviceplan"
  location            = azurerm_resource_group.labrg01.location
  resource_group_name = azurerm_resource_group.labrg01.name
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "linuxappservice" {
  name                = "linuxappservice"
  location            = azurerm_resource_group.labrg01.location
  resource_group_name = azurerm_resource_group.labrg01.name
  service_plan_id     = azurerm_service_plan.labserviceplan.id

  site_config {}
}

resource "azurerm_windows_web_app" "winappservice" {
  name                = "mywinappservice"
  location            = azurerm_resource_group.labrg01.location
  resource_group_name = azurerm_resource_group.labrg01.name
  service_plan_id     = azurerm_service_plan.labserviceplan.id

  site_config {}
}

