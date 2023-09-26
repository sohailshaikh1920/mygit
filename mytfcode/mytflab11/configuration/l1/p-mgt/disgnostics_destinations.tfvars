diagnostics_destinations = {
  log_analytics = {
    central_logs = {
      log_analytics_key              = "mgt_logs"
      log_analytics_destination_type = "Dedicated"
    }
  }

  storage = {
    all_regions = {
      westeurope = {
        storage_account_key = "diaglogs_region1"
      }
      # northeurope = {
      #   storage_account_key = "diaglogs_region2"
      # }
    }
  }
}