################################################
#  Virtual Machine Scale Set 1
################################################


################################################
#  Create Random Password
################################################

resource "random_password" "vmss1_password" {
  length      = 16
  min_lower   = 4
  min_upper   = 4
  min_numeric = 4
  special     = false
}


################################################
# Add secrets to Key Vault
################################################

resource "azurerm_key_vault_secret" "vmss1_login" {
  name         = "${azurerm_linux_virtual_machine_scale_set.vmss1.name}-LocalAdminLogin"
  value        = azurerm_linux_virtual_machine_scale_set.vmss1.admin_username
  key_vault_id = azurerm_key_vault.keyvault.id
  depends_on = [
    azurerm_key_vault_access_policy.keyvault,
    azurerm_key_vault.keyvault
  ]
}

resource "azurerm_key_vault_secret" "vmss1_password" {
  name         = "${azurerm_linux_virtual_machine_scale_set.vmss1.name}-LocalAdminPassword"
  value        = random_password.vmss1_password.result
  key_vault_id = azurerm_key_vault.keyvault.id
  depends_on = [
    azurerm_key_vault_access_policy.keyvault,
    azurerm_key_vault.keyvault
  ]
}


################################################
#  Virtual Machine Scale Set 
################################################

resource "azurerm_linux_virtual_machine_scale_set" "vmss1" {
  name                = "${azurerm_resource_group.workload.name}-${var.vmss1-name}-vmss"
  resource_group_name = azurerm_resource_group.workload.name
  location            = var.location

  admin_username                  = var.vmss1-admin_username
  admin_password                  = random_password.vmss1_password.result
  disable_password_authentication = false

  instances              = var.vmss1-instances
  overprovision          = false
  single_placement_group = false
  zones = [
    "1",
    "2",
    "3"
  ]
  zone_balance = true

  sku             = var.vmss1-sku
  source_image_id = azurerm_shared_image.aib-image-definition1.id

  network_interface {
    name    = "${azurerm_resource_group.workload.name}-${var.vmss1-name}-vmss-nic"
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
