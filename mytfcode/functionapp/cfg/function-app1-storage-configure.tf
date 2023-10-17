##################################################
#  Plan 1 Function App 1 Storage Account Configuration
##################################################

/* DISABLED BECAUSE WE MUST CHANGE TO A LINUX BUILD AGENT AND CONFIGURE FIREWALL/NSG/STORAGE ACCOUNT RULES TO ALLOW THE AGENT ACCESS TO THE STORAGE ACCOUNT
##################################################
#  Function App Storage Account Network Access Rules
##################################################

resource "azurerm_storage_account_network_rules" "storage1rules" {
  storage_account_id = azurerm_storage_account.storage1.id
  default_action     = "Deny"
}
*/


######################################################
#  Private DNS data source for Blob
######################################################

data "azurerm_private_dns_zone" "storageblob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = "p-dns-pri"
  provider            = azurerm.pdns
}


##################################################
#  Function App Storage Account Blob Private Endpoint
##################################################

resource "azurerm_private_endpoint" "plan1-function1-blob" {
  name                          = "${azurerm_storage_account.storage1.name}-blob-pe"
  custom_network_interface_name = "${azurerm_storage_account.storage1.name}-blob-pe-nic"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.workload.name
  subnet_id                     = azurerm_subnet.subnet2.id

  private_service_connection {
    name                           = "privateendpointconnection"
    private_connection_resource_id = azurerm_storage_account.storage1.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  ip_configuration {
    name               = "ipconfig1"
    private_ip_address = var.plan1-function1-blob-ip
    subresource_name   = "blob"
  }

  private_dns_zone_group {
    name                 = "${azurerm_storage_account.storage1.name}-blob-pe"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.storageblob.id]
  }
}


##################################################
#  Function App Storage Account Blob Private Endpoint Diagnostics
##################################################

resource "azurerm_monitor_diagnostic_setting" "plan1-function1-blob" {
  name                           = data.azurerm_log_analytics_workspace.central.name
  target_resource_id             = "/subscriptions/${var.subscriptionid}/resourceGroups/${var.subscriptionname}/providers/Microsoft.Network/networkInterfaces/${azurerm_private_endpoint.plan1-function1-blob.name}-nic"
  log_analytics_workspace_id     = data.azurerm_log_analytics_workspace.central.id
  log_analytics_destination_type = "AzureDiagnostics"

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
}



##################################################
#  Function App Storage Account File Share
##################################################

resource "azurerm_storage_share" "plan1-function1-fileshare1" {
  name                 = var.plan1-function1-name
  storage_account_name = azurerm_storage_account.storage1.name
  quota                = 50
}


######################################################
#  Private DNS data source for Blob
######################################################

data "azurerm_private_dns_zone" "storagefile" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = "p-dns-pri"
  provider            = azurerm.pdns
}


##################################################
#  Function App Storage Account File Private Endpoint
##################################################

resource "azurerm_private_endpoint" "storage1plan1-function1-fileshare1" {
  name                          = "${azurerm_storage_account.storage1.name}-${azurerm_storage_share.plan1-function1-fileshare1.name}-pe"
  custom_network_interface_name = "${azurerm_storage_account.storage1.name}-${azurerm_storage_share.plan1-function1-fileshare1.name}-pe-nic"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.workload.name
  subnet_id                     = azurerm_subnet.subnet2.id

  private_service_connection {
    name                           = "privateendpointconnection"
    private_connection_resource_id = azurerm_storage_account.storage1.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  ip_configuration {
    name               = "ipconfig1"
    private_ip_address = var.plan1-function1-fileshare1-ip
    subresource_name   = "file"
  }

  private_dns_zone_group {
    name                 = "${azurerm_storage_account.storage1.name}-${azurerm_storage_share.plan1-function1-fileshare1.name}-pe"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.storagefile.id]
  }
}


##################################################
#  Function App Storage Account File Private Endpoint Diagnostics
##################################################

resource "azurerm_monitor_diagnostic_setting" "storage1plan1-function1-fileshare1" {
  name                           = data.azurerm_log_analytics_workspace.central.name
  target_resource_id             = "/subscriptions/${var.subscriptionid}/resourceGroups/${var.subscriptionname}/providers/Microsoft.Network/networkInterfaces/${azurerm_private_endpoint.storage1plan1-function1-fileshare1.name}-nic"
  log_analytics_workspace_id     = data.azurerm_log_analytics_workspace.central.id
  log_analytics_destination_type = "AzureDiagnostics"

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
}
