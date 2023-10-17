azuread_groups = {
  aks_cluster_admins = {
    name        = "AZ RBAC AKS Cluster Admins"
    description = "Group Members with delegated AKS Cluster Admin Privilages"
    members = {
      user_principal_names = [
        "damian.flynn@company.com"
      ]
      # group_names          = []
      # object_ids           = []
      # group_keys           = []
      # service_principal_keys = [
      #   "app1"
      # ]
    }
    owners = {
      user_principal_names = []
      # service_principal_keys = [
      #   "app2"
      # ]
    }
    prevent_duplicate_name = false
  }

}