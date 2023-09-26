vnets = {
  aks_region1_vnet = {
    resource_group_key = "aks_vnet"
    region             = "region1"
    vnet = {
      name          = "p-we1k8s-network-vnet"
      address_space = ["10.128.48.0/22"]
    }
    specialsubnets = {}
    subnets = {
      aks_nodepool_system = {
        name    = "NodepoolSystem"
        cidr    = ["10.128.48.0/24"]
        nsg_key = "azure_kubernetes_cluster_nsg"
      }
      aks_nodepool_user1 = {
        name    = "NodepoolUser1"
        cidr    = ["10.128.49.0/24"]
        nsg_key = "azure_kubernetes_cluster_nsg"
      }
      aks_nodepool_user2 = {
        name    = "NodepoolUser2"
        cidr    = ["10.128.50.0/24"]
        nsg_key = "azure_kubernetes_cluster_nsg"
      }
      private_endpoints_subnet = {
        name                                           = "PrivateEndpointsSubnet"
        cidr                                           = ["10.128.51.0/27"]
        enforce_private_link_endpoint_network_policies = true
      }
      azure_bastion_subnet = {
        name    = "AzureBastionSubnet" #Must be called AzureBastionSubnet
        cidr    = ["10.128.51.64/27"]
        nsg_key = "azure_bastion_nsg"
      }
      jumpbox_subnet = {
        name    = "JumpboxSubnet"
        cidr    = ["10.128.51.128/27"]
        nsg_key = "azure_bastion_nsg"
      }
    }

  }
}