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


################################################
#  Setting Key Vault Diagnostics
################################################
resource "azurerm_monitor_diagnostic_setting" "keyvault" {
  name                       = data.azurerm_log_analytics_workspace.central.name
  target_resource_id         = azurerm_key_vault.keyvault.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.central.id

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
