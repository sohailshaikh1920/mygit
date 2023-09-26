################################################
#  Subnet 1 NSG
################################################

resource "azurerm_network_security_group" "subnet1" {
  name                = "${var.subscriptionname}-network-vnet-${azurerm_subnet.subnet1.name}-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.network.name

  security_rule {
    name                       = "AllowDnsFromFirewallTo${azurerm_subnet.subnet1.name}"
    description                = "Allow Dns From Firewall To ${azurerm_subnet.subnet1.name}"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "53"                                       // DNS
    source_address_prefix      = "10.100.1.4"                               // Hub firewall
    destination_address_prefix = azurerm_subnet.subnet1.address_prefixes[0] // Subnet 1
  }

  security_rule {
    name                       = "AllowSshFromAzureBastionsubnetTo${azurerm_subnet.subnet1.name}"
    description                = "Allow SSH from the hub Azure Bastion To ${azurerm_subnet.subnet1.name}"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"                                       // SSH
    source_address_prefix      = "10.100.3.128/26"                          // Hub Bastion
    destination_address_prefix = azurerm_subnet.subnet1.address_prefixes[0] // Subnet 1
  }

  security_rule {
    name                       = "AllowRdpFromAzureBastionsubnetTo${azurerm_subnet.subnet1.name}"
    description                = "Allow RDP from the hub Azure Bastion To ${azurerm_subnet.subnet1.name}"
    priority                   = 1200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"                                       // SSH
    source_address_prefix      = "10.100.3.128/26"                          // Hub Bastion
    destination_address_prefix = azurerm_subnet.subnet1.address_prefixes[0] // Subnet 1
  }

  ################################################
  # Start Workload Rules
  ################################################

  ################################################
  # End Workload Rules
  ################################################

  security_rule {
    name                       = "AllowProbeFromAzureloadbalancerTo${azurerm_subnet.subnet1.name}"
    description                = "Allow Probe From Azureloadbalancer To ${azurerm_subnet.subnet1.name}"
    priority                   = 3900
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"                                        // All
    source_address_prefix      = "AzureLoadBalancer"                        // Azure Load Balancer service tag
    destination_address_prefix = azurerm_subnet.subnet1.address_prefixes[0] // Subnet 1
  }
  security_rule {
    name                       = "DenyAll"
    description                = "Deny all other traffic"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*" // All
    source_address_prefix      = "*" // All
    destination_address_prefix = "*" // All
  }
}



###################################################################
#  Subnet 1 NSG Flow Logs and Traffic Analytics
###################################################################
resource "azurerm_network_watcher_flow_log" "subnet1_flowfront" {
  name                 = "Vnet${azurerm_subnet.subnet1.name}-flowlog"
  location             = var.location
  network_watcher_name = azurerm_network_watcher.network.name
  resource_group_name  = azurerm_resource_group.network.name

  network_security_group_id = azurerm_network_security_group.subnet1.id
  storage_account_id        = azurerm_storage_account.networkdiag.id
  enabled                   = true
  version                   = 2

  retention_policy {
    enabled = true
    days    = 3
  }
  traffic_analytics {
    enabled               = true
    workspace_id          = data.azurerm_log_analytics_workspace.central.workspace_id
    workspace_region      = data.azurerm_log_analytics_workspace.central.location
    workspace_resource_id = data.azurerm_log_analytics_workspace.central.id
    interval_in_minutes   = 10
  }
}


################################################
#  Subnet 2 NSG
################################################

resource "azurerm_network_security_group" "subnet2" {
  name                = "${var.subscriptionname}-network-vnet-${azurerm_subnet.subnet2.name}-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.network.name

  security_rule {
    name                       = "AllowDnsFromFirewallTo${azurerm_subnet.subnet2.name}"
    description                = "Allow Dns From Firewall To ${azurerm_subnet.subnet2.name}"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "53"                                       // DNS
    source_address_prefix      = "10.100.1.4"                               // Hub firewall
    destination_address_prefix = azurerm_subnet.subnet2.address_prefixes[0] // Subnet 2
  }

  ################################################
  # Start Workload Rules
  ################################################

  ## Destination: Key Vault

  security_rule {
    name                       = "AllowHttpsFromDevopssubnetToKeyvault"
    description                = "Allow SQL from ASE to Key Vault"
    priority                   = 1400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"                                                                                        // TCP
    source_address_prefixes    = azurerm_subnet.subnet1.address_prefixes                                                      // DevopsSubnet 
    destination_address_prefix = azurerm_private_endpoint.keyvault.private_dns_zone_configs[0].record_sets[0].ip_addresses[0] // Key Vault Private Endpoint
  }

  ################################################
  # End Workload Rules
  ################################################

  security_rule {
    name                       = "AllowProbeFromAzureloadbalancerTo${azurerm_subnet.subnet2.name}"
    description                = "Allow Probe From Azureloadbalancer To ${azurerm_subnet.subnet2.name}"
    priority                   = 3900
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"                                        // All
    source_address_prefix      = "AzureLoadBalancer"                        // Azure Load Balancer service tag
    destination_address_prefix = azurerm_subnet.subnet2.address_prefixes[0] // Subnet 2
  }
  security_rule {
    name                       = "DenyAll"
    description                = "Deny all other traffic"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*" // All
    source_address_prefix      = "*" // All
    destination_address_prefix = "*" // All
  }
}


###################################################################
#  Subnet 2 NSG Flow Logs and Traffic Analytics
###################################################################
resource "azurerm_network_watcher_flow_log" "subnet2_flowfront" {
  name                 = "Vnet${azurerm_subnet.subnet2.name}-flowlog"
  location             = var.location
  network_watcher_name = azurerm_network_watcher.network.name
  resource_group_name  = azurerm_resource_group.network.name

  network_security_group_id = azurerm_network_security_group.subnet2.id
  storage_account_id        = azurerm_storage_account.networkdiag.id
  enabled                   = true
  version                   = 2

  retention_policy {
    enabled = true
    days    = 3
  }
  traffic_analytics {
    enabled               = true
    workspace_id          = data.azurerm_log_analytics_workspace.central.workspace_id
    workspace_region      = data.azurerm_log_analytics_workspace.central.location
    workspace_resource_id = data.azurerm_log_analytics_workspace.central.id
    interval_in_minutes   = 10
  }
}
