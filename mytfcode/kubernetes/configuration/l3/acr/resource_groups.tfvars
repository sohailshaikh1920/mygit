resource_groups = {
  acr_region1 = {
    name        = "p-we1acr"
    region      = "region1"
    description = "Resource Group for the AKS"
  }
  acr_region1_vnet = {
    name        = "p-we1acr-network"
    region      = "region1"
    description = "Resource Group for the vNET, hosting the AKS"
  }

}
