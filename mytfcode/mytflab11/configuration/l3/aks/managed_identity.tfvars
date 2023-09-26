managed_identities = {
  ## Jumpbox

  aks_jumpbox = {
    name               = "p-we1k8s-jump-box01-id"
    resource_group_key = "aks_jumpbox"
  }

  ## AKS Cluster

  aks_region1_usermsi = {
    name               = "p-we1k8s-akscluster-msi"
    resource_group_key = "aks"
  }
}