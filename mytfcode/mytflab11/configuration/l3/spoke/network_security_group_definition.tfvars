
network_security_group_definition = {
  # This entry is applied to all subnets with no NSG defined
  empty_nsg = {}

  integration_subnet_nsg = {
    resource_group_key = "spoke_network"
    name               = "t-rg1spoke-network-vnet-integration-subnet-nsg"

    nsg = [
      {
        name                       = "integration-dns-in-allow",
        description = "Allow Dns From Firewall To Integration Subnet"
        priority                   = "1000"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Udp"
        source_port_range          = "*"
        destination_port_range     = "53" //DNS
        source_address_prefix      = "10.75.1.4" //Hub Firewall
        destination_address_prefix = "10.75.6.0/27"
      },

      ################################################
      # Start Workload Rules
      ################################################


      ################################################
      # End Workload Rules
      ################################################

      {
        name                       = "integration-lb-probe-in-allow",
        description = "Allow Probe From Azureloadbalancer To Integration Subnet"
        priority                   = "3900"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*" //All
        source_address_prefix      = "AzureLoadBalancer" //Load Balancer service tag
        destination_address_prefix = "10.75.6.0/27"
      },      
      {
        name                       = "DenyAll",
        description = "Deny all other traffic"
        priority                   = "4000"
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*" // Allo
        source_port_range          = "*" // All
        destination_port_range     = "*" // All
        source_address_prefix      = "*" // All
        destination_address_prefix = "*" // All
      }
    ]

    # flow_logs block is optionnal
    flow_logs = {
      name = "t-rg1spoke-network-vnet-integration-subnet-nsg-flowlog"
      version = 2
      enabled = true
      # we pick the default network watcher inside #NetworkWatcherRG or
      network_watcher_key = "network_watcher_1"
      # network_watcher_rg_key = "spoke_network"
      # lz_key = "spoke"
      storage_account = {
        storage_account_destination = "all_regions"
        retention = {
          enabled = true
          days = 3
        }
      }
      traffic_analytics = {
        enabled = false
        log_analytics_workspace_destination = "central_logs"
        interval_in_minutes = "10"
      }
    }
  }

  private_endpoint_subnet_nsg = {
    resource_group_key = "spoke_network"
    name               = "t-rg1spoke-network-vnet-private-endpoint-subnet-nsg"

    nsg = [
      {
        name                       = "private-endpoint-dns-in-allow",
        description = "Allow Dns From Firewall To Private Endpoint Subnet"
        priority                   = "1000"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Udp"
        source_port_range          = "*"
        destination_port_range     = "53" //DNS
        source_address_prefix      = "10.75.1.4" //Hub Firewall
        destination_address_prefix = "10.75.6.32/27"
      },

      ################################################
      # Start Workload Rules
      ################################################

      ## Destination: Web Apps
      /*
      {
        name                       = "AllowHttpsFromWafToFunctionapp1"
        description                = "Allow HTTPS from the Public WAF Subnet to Function App 1 Private Endpoint"
        priority                   = 1100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"                  // TCP
        source_address_prefix      = "10.100.4.0/24"        // p-we1waf-network-vnet-PublicWafSubnet
        destination_address_prefix = var.plan1-function1-ip // Plan 1 Function App 1
      },
      {
        name                         = "AllowWebdeployFromDevopsagentToFunctionapp1"
        description                  = "Allow HTTPS from the Public WAF Subnet to Function App 1 Private Endpoint"
        priority                     = 1200
        direction                    = "Inbound"
        access                       = "Allow"
        protocol                     = "Tcp"
        source_port_range            = "*"
        destination_port_range       = "443"                  // TCP
        source_address_prefix        = "10.100.13.0/26"       // p-we1dep-network-vnet
        destination_address_prefix = var.plan1-function1-ip // Plan 1 Function App 1
      }, 

      */

      ## Destination: Key Vault

      /*
      {
        name                       = "AllowHttpsFromAppserviceplanToKeyvault"
        description                = "Allow SQL from ASE to Key Vault"
        priority                   = 1300
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"                                   // TCP
        source_address_prefixes    = azurerm_subnet.subnet1.address_prefixes // App Service Plan 
        destination_address_prefix = azurerm_private_endpoint.keyvault.private_dns_zone_configs[0].record_sets[0].ip_addresses[0] // Key Vault Private Endpoint
      },

      */

      ################################################
      # End Workload Rules
      ################################################

      {
        name                       = "integration-lb-probe-in-allow",
        description = "Allow Probe From Azureloadbalancer To Integration Subnet"
        priority                   = "3900"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*" //All
        source_address_prefix      = "AzureLoadBalancer" //Load Balancer service tag
        destination_address_prefix = "10.75.6.32/27"
      }, 
      {
        name                       = "DenyAll",
        description = "Deny all other traffic"
        priority                   = "4000"
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*" // Allo
        source_port_range          = "*" // All
        destination_port_range     = "*" // All
        source_address_prefix      = "*" // All
        destination_address_prefix = "*" // All
      }
    ]

    # flow_logs block is optionnal
    flow_logs = {
      name = "t-rg1spoke-network-vnet-integration-subnet-nsg-flowlog"
      version = 2
      enabled = true
      network_watcher_key = "network_watcher_1"
      storage_account = {
        storage_account_destination = "all_regions"
        retention = {
          enabled = true
          days = 3
        }
      }
      traffic_analytics = {
        enabled = false
        log_analytics_workspace_destination = "central_logs"
        interval_in_minutes = "10"
      }
    }

    diagnostic_profiles = {
      nsg = {
        definition_key   = "network_security_group"
        destination_type = "storage"
        destination_key  = "all_regions"
      }
      operations = {
        name             = "operations"
        definition_key   = "network_security_group"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }

  }

}
