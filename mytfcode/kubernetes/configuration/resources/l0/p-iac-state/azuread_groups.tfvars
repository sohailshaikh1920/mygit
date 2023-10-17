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
}