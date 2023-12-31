aks_clusters = {
  aks_region1_custer = {
    name               = "p-we1k8s-akscluster"
    resource_group_key = "aks"
    os_type            = "Linux"

    diagnostic_profiles = {
      operations = {
        name             = "aksoperations"
        definition_key   = "azure_kubernetes_cluster"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }
    
    identity = {
      # type = "SystemAssigned"
      type                 = "UserAssigned"
      managed_identity_key = "aks_region1_usermsi"
    }

    role_based_access_control = {
      enabled = true
      azure_active_directory = {
        managed            = true
        azure_rbac_enabled = true
      }
    }

    vnet_key = "aks_region1_vnet"
    network_profile = {
      network_plugin    = "azure"
      load_balancer_sku = "Standard"
    }
    network_policy = {
      network_plugin    = "azure"
      load_balancer_sku = "standard"
    }

    private_cluster_enabled = true
    private_cluster_public_fqdn_enabled = true
    enable_rbac             = true
    outbound_type           = "userDefinedRouting"

    admin_groups = {
      # ids = []
      # azuread_group_keys = ["aks_admins"]
    }
    load_balancer_profile = {
      # Only one option can be set
      managed_outbound_ip_count = 1
    }


    # private_endpoints = {
    #   pe1 = {
    #     name = "aks-pe"
    #     vnet_key   = "aks_region1_vnet"
    #     subnet_key = "private_endpoints_subnet"
    #     private_service_connection = {
    #       name                 = "aks-psc"
    #       is_manual_connection = false
    #       subresource_names    = ["management"]
    #     }
    #   }
    # }

    default_node_pool = {
      name                  = "sharedsvc"
      vm_size               = "Standard_F4s_v2"
      subnet_key            = "aks_nodepool_system"
      enabled_auto_scaling  = false
      enable_node_public_ip = false
      max_pods              = 30
      node_count            = 1
      os_disk_size_gb       = 512
      tags = {
        "project" = "system services"
      }
    }


    node_resource_group_name = "p-we1k8s-nodes"

    node_pools = {
      pool1 = {
        name                = "nodepool1"
        mode                = "User"
        subnet_key          = "aks_nodepool_user1"
        max_pods            = 30
        vm_size             = "Standard_DS2_v2"
        node_count          = 1
        enable_auto_scaling = false
        os_disk_size_gb     = 512
        tags = {
          "project" = "user services"
        }
      }
    }

    tags = {
      cluster = "finance"
    }

  }
}
