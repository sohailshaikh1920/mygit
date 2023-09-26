subscriptions = {
  t-rg1spoke ={
    name = "t-rg1spoke"
    alias = "t-rg1spoke"
    subscription_id = "987d5cc5-6e20-47d3-8cb4-8c5989648045"
    management_group_id = "Infrastrcuture"
    tags = {
      businessUnit = "Development"
      solution = "LandingZoneScaffold"
    }
    diagnostic_profiles = {
      operations = {
        name             = "operations"
        definition_key   = "subscription_operations"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }
  }
}