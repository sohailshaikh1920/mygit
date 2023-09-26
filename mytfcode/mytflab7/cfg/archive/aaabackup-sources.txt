################################################
# VMs to backup and setting Policy
################################################
resource "azurerm_backup_protected_vm" "app01" {
  source_vm_id     = azurerm_windows_virtual_machine.app01.id
  backup_policy_id = azurerm_backup_policy_vm.vm_daily_backup.id

  resource_group_name = azurerm_resource_group.primary.name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name
}

