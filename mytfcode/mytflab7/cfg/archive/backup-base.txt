################################################
#  Creating Recovery Service Vault
################################################
resource "azurerm_recovery_services_vault" "vault" {
  name                         = "${azurerm_resource_group.primary.name}${random_string.random.result}-rsv"
  location                     = azurerm_resource_group.primary.location
  resource_group_name          = azurerm_resource_group.primary.name
  sku                          = "Standard"
  cross_region_restore_enabled = true

  soft_delete_enabled = true
}


################################################
#  setting diagnostics
################################################
resource "azurerm_monitor_diagnostic_setting" "vault_diagnostic_settings" {
  name                           = data.azurerm_log_analytics_workspace.central.name
  target_resource_id             = azurerm_recovery_services_vault.vault.id
  log_analytics_workspace_id     = data.azurerm_log_analytics_workspace.central.id
  log_analytics_destination_type = "Dedicated"

  log {
    category = "AzureBackupReport"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "CoreAzureBackup"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  # log {
  #   category = "AddonAzureBackupJobs" #Not supported yet
  # }
  log {
    category = "AddonAzureBackupAlerts"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AddonAzureBackupPolicy"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AddonAzureBackupStorage"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AddonAzureBackupProtectedInstance"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AzureSiteRecoveryReplicationDataUploadRate"
    enabled  = false
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AzureSiteRecoveryReplicatedItems"
    enabled  = false
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AzureSiteRecoveryRecoveryPoints"
    enabled  = false
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AzureSiteRecoveryProtectedDiskDataChurn"
    enabled  = false
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AddonAzureBackupJobs"
    enabled  = false
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AzureSiteRecoveryJobs"
    enabled  = false
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AzureSiteRecoveryEvents"
    enabled  = false
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AzureSiteRecoveryReplicationStats"
    enabled  = false
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  metric {
    category = "Health"
    retention_policy {
      days    = 0
      enabled = false
    }
  }
}