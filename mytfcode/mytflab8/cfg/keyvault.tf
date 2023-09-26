################################################
#  Key Vault
################################################

resource "azurerm_key_vault" "keyvault" {
  name                            = "${var.subscriptionname}${random_string.random.result}-kv"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.workload.name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days      = 90
  purge_protection_enabled        = true
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true

  sku_name = "premium"
}


######################################################
#  Private DNS data source
######################################################

data "azurerm_private_dns_zone" "keyvault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = "p-dns-pri"
  provider            = azurerm.pdns
}


################################################
#  Key Vault Private Endpoint
################################################

resource "azurerm_private_endpoint" "keyvault" {
  name                          = "${azurerm_key_vault.keyvault.name}-pe"
  custom_network_interface_name = "${azurerm_key_vault.keyvault.name}-pe-nic"
  resource_group_name           = azurerm_resource_group.workload.name
  location                      = azurerm_resource_group.workload.location
  subnet_id                     = azurerm_subnet.subnet2.id

  private_service_connection {
    name                           = "${azurerm_key_vault.keyvault.name}-privateserviceconnection"
    private_connection_resource_id = azurerm_key_vault.keyvault.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = "${azurerm_key_vault.keyvault.name}-pe-nml"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.keyvault.id]
  }
}


##################################################
#  Private Endpoint Diagnostics
##################################################

resource "azurerm_monitor_diagnostic_setting" "keyvaultpe" {
  name                           = data.azurerm_log_analytics_workspace.central.name
  target_resource_id             = "/subscriptions/${var.subscriptionid}/resourceGroups/${var.subscriptionname}/providers/Microsoft.Network/networkInterfaces/${azurerm_key_vault.keyvault.name}-pe-nic"
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

  depends_on = [
    azurerm_private_endpoint.keyvault,
  ]
}


################################################
#  Setting Key Vault Access Policies
################################################
resource "azurerm_key_vault_access_policy" "keyvault" {
  for_each                = merge(local.current_subscription_kv_policy, var.keyvault_access_policies)
  key_vault_id            = azurerm_key_vault.keyvault.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = each.key
  certificate_permissions = each.value.certificate_permissions
  key_permissions         = each.value.key_permissions
  secret_permissions      = each.value.secret_permissions
}


################################################
#  Setting Key Vault Diagnostics
################################################
resource "azurerm_monitor_diagnostic_setting" "keyvault" {
  name                           = data.azurerm_log_analytics_workspace.central.name
  target_resource_id             = azurerm_key_vault.keyvault.id
  log_analytics_workspace_id     = data.azurerm_log_analytics_workspace.central.id
  log_analytics_destination_type = "AzureDiagnostics"

  log {
    category = "AuditEvent"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }

  log {
    category = "AzurePolicyEvaluationDetails"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
}
