######################################################
# Create Actions Groups
######################################################
resource "azurerm_monitor_action_group" "budget" {
  name                = "${azurerm_resource_group.monitor.name}-budget-ag"
  resource_group_name = azurerm_resource_group.monitor.name
  short_name          = substr("${local.subscriptionname}monbudgetag", 0, 12)
  email_receiver {
    name                    = "IncidentsMontelGroup"
    email_address           = var.security_incident_email
    use_common_alert_schema = true
  }
}

resource "azurerm_monitor_action_group" "ops-critical" {
  name                = "${azurerm_resource_group.monitor.name}-ops-critical-ag"
  resource_group_name = azurerm_resource_group.monitor.name
  short_name          = substr("${local.subscriptionname}monopscriticalag", 0, 12)
  email_receiver {
    name                    = "IncidentsMontelGroup"
    email_address           = var.security_incident_email
    use_common_alert_schema = true
  }
}

resource "azurerm_monitor_action_group" "ops-error" {
  name                = "${azurerm_resource_group.monitor.name}-ops-error-ag"
  resource_group_name = azurerm_resource_group.monitor.name
  short_name          = substr("${local.subscriptionname}monopserrorag", 0, 12)
  email_receiver {
    name                    = "IncidentsMontelGroup"
    email_address           = var.security_incident_email
    use_common_alert_schema = true
  }
}

resource "azurerm_monitor_action_group" "ops-warning" {
  name                = "${azurerm_resource_group.monitor.name}-ops-warning-ag"
  resource_group_name = azurerm_resource_group.monitor.name
  short_name          = substr("${local.subscriptionname}monopswarningag", 0, 12)
  email_receiver {
    name                    = "IncidentsMontelGroup"
    email_address           = var.security_incident_email
    use_common_alert_schema = true
  }
}

resource "azurerm_monitor_action_group" "ops-info" {
  name                = "${azurerm_resource_group.monitor.name}-ops-info-ag"
  resource_group_name = azurerm_resource_group.monitor.name
  short_name          = substr("${local.subscriptionname}monopsinfoag", 0, 12)
  email_receiver {
    name                    = "IncidentsMontelGroup"
    email_address           = var.security_incident_email
    use_common_alert_schema = true
  }
}
