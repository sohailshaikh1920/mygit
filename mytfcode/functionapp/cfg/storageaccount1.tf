################################################
#  Storage Account 1
################################################

resource "azurerm_storage_account" "storage1" {
  name                = "${local.subscriptionname}data${random_string.random.result}"
  resource_group_name = azurerm_resource_group.workload.name
  location            = var.location

  account_tier              = var.storage1_account_tier
  account_kind              = var.storage1_account_kind
  account_replication_type  = var.storage1_account_replication_type
  enable_https_traffic_only = var.storage1_enable_https_traffic_only
}


