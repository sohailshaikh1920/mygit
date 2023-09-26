data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "labkv" {
  name                       = "merelabkakv"
  location                   = azurerm_resource_group.labrg01.location
  resource_group_name        = azurerm_resource_group.labrg01.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "premium"
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover"
    ]
  }
}

resource "azurerm_key_vault_secret" "vmpass" {
  name         = "vmpass"
  value        = azurerm_windows_virtual_machine.vm1.admin_password
  key_vault_id = azurerm_key_vault.labkv.id
}