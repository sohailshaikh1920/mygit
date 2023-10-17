################################################
#  Deploy Spoke Key Vault
################################################
resource "azurerm_key_vault" "keyvault" {
  name                            = "${var.subscriptionname}${random_string.random.result}-kv"
  location                        = azurerm_resource_group.primary.location
  resource_group_name             = azurerm_resource_group.primary.name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days      = 90
  purge_protection_enabled        = true
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true

  sku_name = "premium"
}

resource "azurerm_private_endpoint" "keyvault" {
  name                          = "${azurerm_key_vault.keyvault.name}-pe"
  custom_network_interface_name = "${azurerm_key_vault.keyvault.name}-pe-nic"
  resource_group_name           = azurerm_resource_group.primary.name
  location                      = azurerm_resource_group.primary.location
  subnet_id                     = azurerm_subnet.privatelink.id

  private_service_connection {
    name                           = "${azurerm_key_vault.keyvault.name}-privateserviceconnection"
    private_connection_resource_id = azurerm_key_vault.keyvault.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }
}


resource "azurerm_private_dns_a_record" "keyvault" {
  provider            = azurerm.pdns
  name                = azurerm_key_vault.keyvault.name
  zone_name           = "privatelink.vaultcore.azure.net"
  resource_group_name = "p-dns-pri"
  ttl                 = 3600
  records             = ["${azurerm_private_endpoint.keyvault.private_service_connection[0].private_ip_address}"]
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

