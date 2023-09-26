# Defines different repositories for the diagnostics logs
# Storage accounts, log analytics, event hubs

diagnostic_storage_accounts = {
  # Stores diagnostic logging for region1
  diaglogs_region1 = {
    name                     = "p-mgt-audit-619-diag"
    region                   = "region1"
    resource_group_key       = "mgt_audit"
    account_kind             = "StorageV2"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    access_tier              = "Cool"
  }

}