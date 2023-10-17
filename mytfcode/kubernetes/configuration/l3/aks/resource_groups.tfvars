resource_groups = {
  aks = {
    name        = "p-we1k8s"
    region      = "region1"
    description = "Resource Group for the AKS"
  }
  aks_vnet = {
    name        = "p-we1k8s-network"
    region      = "region1"
    description = "Resource Group for the vNET, hosting the AKS"
  }
  aks_jumpbox = {
    name        = "p-we1k8s-jump"
    region      = "region1"
    description = "Resource Group for a Jumpbox"
    tags = {
      public_exposure = "portal"
    }
  }

}