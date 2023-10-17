################################################
# Defining VM Daily Backup Policy
################################################
resource "azurerm_backup_policy_vm" "vm_daily_backup" {
  name                = "VM-Daily-Backup"
  resource_group_name = azurerm_resource_group.primary.name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name

  timezone = "W. Europe Standard Time"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 30
  }

  retention_weekly {
    count    = 35
    weekdays = ["Friday"]
  }

  retention_monthly {
    count    = 13
    weekdays = ["Friday"]
    weeks    = ["Last"]
  }

  retention_yearly {
    count    = 10
    weekdays = ["Friday"]
    weeks    = ["Last"]
    months   = ["December"]
  }
}


