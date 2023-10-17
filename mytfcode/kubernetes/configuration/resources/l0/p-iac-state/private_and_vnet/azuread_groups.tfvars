azuread_groups = {
  acf_platform_maintainers = {
    name        = "AZ RBAC ACF Platform Maintainers"
    description = "High privileged group to run all ACF deployments from vscode. Can be used to bootstrap or troubleshoot deployments."
    members = {
      object_ids = ["1d28ce0f-4447-44a1-a730-e49e37628ec4"]
    }
    owners                 = ["1d28ce0f-4447-44a1-a730-e49e37628ec4"]
    prevent_duplicate_name = true
  }
  acf_platform_contributors = {
    name        = "AZ RBAC ACF Platform Contributors"
    description = "Can only execute terraform plans for level1 and level2. They can test platform improvements and propose PR."
    members = {
      object_ids = ["1d28ce0f-4447-44a1-a730-e49e37628ec4"]
    }
    owners                 = ["1d28ce0f-4447-44a1-a730-e49e37628ec4"]
    prevent_duplicate_name = true
  }
  level0 = {
    name = "AZ RBAC ACF Level 0"
    members = {
      azuread_service_principal_keys = ["level0"]
    }
    owners                 = ["1d28ce0f-4447-44a1-a730-e49e37628ec4"]
    prevent_duplicate_name = true
  }
  alz = {
    name = "AZ RBAC ACF VDC Core"
    members = {
      azuread_service_principal_keys = ["alz"]
    }
    owners                 = ["1d28ce0f-4447-44a1-a730-e49e37628ec4"]
    prevent_duplicate_name = true
  }
  # identity = {
  #   name = "caf-identity"
  #   members = {
  #     azuread_service_principal_keys = ["identity"]
  #   }
  #   owners                 = ["1d28ce0f-4447-44a1-a730-e49e37628ec4"]
  #   prevent_duplicate_name = true
  # }
  management = {
    name = "AZ RBAC ACF Management"
    members = {
      azuread_service_principal_keys = ["management"]
    }
    owners                 = ["1d28ce0f-4447-44a1-a730-e49e37628ec4"]
    prevent_duplicate_name = true
  }
  connectivity = {
    name = "AZ RBAC ACF Cnnectivity"
    members = {
      azuread_service_principal_keys = ["connectivity"]
    }
    owners                 = ["1d28ce0f-4447-44a1-a730-e49e37628ec4"]
    prevent_duplicate_name = true
  }
  # security = {
  #   name = "security"
  #   members = {
  #     azuread_service_principal_keys = ["security"]
  #   }
  #   owners                 = ["1d28ce0f-4447-44a1-a730-e49e37628ec4"]
  #   prevent_duplicate_name = true
  # }
  # subscription_creation_platform = {
  #   name = "subscription_creation_platform"
  #   members = {
  #     azuread_service_principal_keys = ["subscription_creation_platform"]
  #   }
  #   owners                 = ["1d28ce0f-4447-44a1-a730-e49e37628ec4"]
  #   prevent_duplicate_name = true
  # }
  # subscription_creation_landingzones = {
  #   name = "subscription_creation_landingzones"
  #   members = {
  #     azuread_service_principal_keys = ["subscription_creation_landingzones"]
  #   }
  #   owners                 = ["1d28ce0f-4447-44a1-a730-e49e37628ec4"]
  #   prevent_duplicate_name = true
  # }
}