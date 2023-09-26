bastion_hosts = {
  aks_region1_bastion = {
    name               = "p-we1k8s-jump-bastion"
    region             = "region1"
    resource_group_key = "aks_jumpbox"
    vnet_key           = "aks_region1_vnet"
    subnet_key         = "azure_bastion_subnet"
    public_ip_key      = "aks_region1_bastion"

    # you can setup up to 5 profiles
    diagnostic_profiles = {
      central_logs_region1 = {
        definition_key   = "bastion_host"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }
  }

}