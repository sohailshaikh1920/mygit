######################################################
# Create Actions Groups
######################################################
resource "azurerm_monitor_action_group" "spoke-mon-budget-ag" {
  name                = "${azurerm_resource_group.mon.name}-budget-ag"
  resource_group_name = "${azurerm_resource_group.mon.name}"
  short_name          = substr("${local.subscriptionname}monbudgetag", 0, 12)
}

resource "azurerm_monitor_action_group" "spoke-mon-ops-critical-ag" {
  name                = "${azurerm_resource_group.mon.name}-ops-critical-ag"
  resource_group_name = "${azurerm_resource_group.mon.name}"
  short_name          = substr("${local.subscriptionname}monopscriticalag", 0, 12)
}

resource "azurerm_monitor_action_group" "spoke-mon-ops-error-ag" {
  name                = "${azurerm_resource_group.mon.name}-ops-error-ag"
  resource_group_name = "${azurerm_resource_group.mon.name}"
  short_name          = substr("${local.subscriptionname}monopserrorag", 0, 12)
}

resource "azurerm_monitor_action_group" "spoke-mon-ops-warning-ag" {
  name                = "${azurerm_resource_group.mon.name}-ops-warning-ag"
  resource_group_name = "${azurerm_resource_group.mon.name}"
  short_name          = substr("${local.subscriptionname}monopswarningag", 0, 12)
  email_receiver {
    name                    = "IncidentsMontelGroup"
    email_address           = var.security_incident_email
    use_common_alert_schema = true
  }
}

resource "azurerm_monitor_action_group" "spoke-mon-ops-info-ag" {
  name                = "${azurerm_resource_group.mon.name}-ops-info-ag"
  resource_group_name = "${azurerm_resource_group.mon.name}"
  short_name          = substr("${local.subscriptionname}monopsinfoag", 0, 12)
}
