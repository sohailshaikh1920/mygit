keyvault_access_policies = {
  aks_cluster = {
    agw_keyvault_certs = {
      managed_identity_key    = "aks_region1_usermsi"
      certificate_permissions = ["Get"]
      secret_permissions      = ["Get"]
    }
  }
}