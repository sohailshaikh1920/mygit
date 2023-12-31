public_ip_addresses = {

  aks_region1_bastion = {
    name                    = "p-we1k8s-jump-bastion-pip1"
    region                  = "region1"
    resource_group_key      = "aks_jumpbox"
    sku                     = "Standard"
    allocation_method       = "Static"
    ip_version              = "IPv4"
    idle_timeout_in_minutes = "4"

    # you can setup up to 5 key
    diagnostic_profiles = {
      central_logs_region1 = {
        definition_key   = "public_ip_address"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }
  }

}
