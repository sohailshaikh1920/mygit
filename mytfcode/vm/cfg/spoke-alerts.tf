######################################################
# Create Actions Groups
######################################################
resource "azurerm_monitor_action_group" "spoke-mon-budget-ag" {
  name                = "${var.subscriptionname}-mon-budget-ag"
  resource_group_name = "${var.subscriptionname}-mon"
  short_name          = substr("${local.subscriptionname}monbudgetag", 0, 12)
}

resource "azurerm_monitor_action_group" "spoke-mon-ops-critical-ag" {
  name                = "${var.subscriptionname}-mon-ops-critical-ag"
  resource_group_name = "${var.subscriptionname}-mon"
  short_name          = substr("${local.subscriptionname}monopscriticalag", 0, 12)
}

resource "azurerm_monitor_action_group" "spoke-mon-ops-error-ag" {
  name                = "${var.subscriptionname}-mon-ops-error-ag"
  resource_group_name = "${var.subscriptionname}-mon"
  short_name          = substr("${local.subscriptionname}monopserrorag", 0, 12)
}

resource "azurerm_monitor_action_group" "spoke-mon-ops-warning-ag" {
  name                = "${var.subscriptionname}-mon-ops-warning-ag"
  resource_group_name = "${var.subscriptionname}-mon"
  short_name          = substr("${local.subscriptionname}monopswarningag", 0, 12)
  email_receiver {
    name                    = "IncidentsMontelGroup"
    email_address           = var.security_incident_email
    use_common_alert_schema = true
  }
}

resource "azurerm_monitor_action_group" "spoke-mon-ops-info-ag" {
  name                = "${var.subscriptionname}-mon-ops-info-ag"
  resource_group_name = "${var.subscriptionname}-mon"
  short_name          = substr("${local.subscriptionname}monopsinfoag", 0, 12)
}
