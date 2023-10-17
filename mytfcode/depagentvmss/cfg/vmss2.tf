################################################
#  Virtual Machine Scale Set 2
################################################


################################################
#  Create Random Password
################################################

resource "random_password" "vmss2_password" {
  length      = 16
  min_lower   = 4
  min_upper   = 4
  min_numeric = 4
  special     = false
}


################################################
# Add secrets to Key Vault
################################################

resource "azurerm_key_vault_secret" "vmss2_login" {
  name         = "${azurerm_windows_virtual_machine_scale_set.vmss2.name}-LocalAdminLogin"
  value        = azurerm_windows_virtual_machine_scale_set.vmss2.admin_username
  key_vault_id = azurerm_key_vault.keyvault.id
  depends_on = [
    azurerm_key_vault_access_policy.keyvault,
    azurerm_key_vault.keyvault
  ]
}

resource "azurerm_key_vault_secret" "vmss2_password" {
  name         = "${azurerm_windows_virtual_machine_scale_set.vmss2.name}-LocalAdminPassword"
  value        = random_password.vmss2_password.result
  key_vault_id = azurerm_key_vault.keyvault.id
  depends_on = [
    azurerm_key_vault_access_policy.keyvault,
    azurerm_key_vault.keyvault
  ]
}


################################################
#  Virtual Machine Scale Set 
################################################

resource "azurerm_windows_virtual_machine_scale_set" "vmss2" {
  name                = "${azurerm_resource_group.workload.name}-${var.vmss2-name}-vmss"
  resource_group_name = azurerm_resource_group.workload.name
  location            = var.location
  computer_name_prefix = "vmss2"

  admin_username                  = var.vmss2-admin_username
  admin_password                  = random_password.vmss2_password.result

  instances              = var.vmss2-instances
  overprovision          = false
  single_placement_group = false
  zones = [
    "1",
    "2",
    "3"
  ]
  zone_balance = true

  sku             = var.vmss2-sku
  source_image_id = azurerm_shared_image.aib-image-definition2.id

  network_interface {
    name    = "${azurerm_resource_group.workload.name}-${var.vmss2-name}-vmss-nic"
    primary = true
    ip_configuration {
      name      = "ipconfig1"
      subnet_id = azurerm_subnet.subnet1.id
    }
  }
  os_disk {
    caching              = "ReadOnly"
    storage_account_type = "Standard_LRS"
    diff_disk_settings {
      option = "Local"
    }
  }
}
