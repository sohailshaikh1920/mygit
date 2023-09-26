diagnostics_destinations = {
  # Storage keys must reference the azure region name
  # For storage, reference "all_regions" and we will send the logs to the storage account
  # in the region of the deployment


  log_analytics = {
    central_logs = {
      log_analytics_resource_id  = "/subscriptions/a807b50a-70fd-4c19-9ad7-b39226d231f3/resourcegroups/p-mgt-logs/providers/microsoft.operationalinsights/workspaces/p-mgt-logs-ws"
      log_analytics_workspace_id = "ee0ee198-ffca-4cce-81ac-92438f7c947f"
    }
  }

  # use existing storage account
  storage = {
    all_regions = {
      westeurope = {
        storage_account_resource_id = "/subscriptions/a807b50a-70fd-4c19-9ad7-b39226d231f3/resourceGroups/p-mgt-audit/providers/Microsoft.Storage/storageAccounts/pmgtauditpwrdiag"
      }
    }
  }
}
