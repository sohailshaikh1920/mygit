network_connections = {
  
  aad_aks_networkconnection = {
    domainJoinType = "AzureADJoin"
    // Hybrid Options
    # domainName = "[parameters('domainName')]",
    # domainUsername = "[parameters('domainUsername')]",
    # domainPassword = "[parameters('domainPassword')]",
    # organizationUnit = "[parameters('organizationUnit')]"
    vnet_key           = "aks_region1_vnet"
    subnet_key         = "azure_bastion_subnet"
  }

}