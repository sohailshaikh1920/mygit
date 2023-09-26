################################################
#  Storage account for network diagnosts data
################################################

resource "azurerm_storage_account" "networkdiag" {
  # name                = "${local.subscriptionname}networkdiag${random_string.random.result}"
  name                = "pwe1netnetworkdiagff5bl"
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location

  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "ZRS"
  enable_https_traffic_only = true
}

