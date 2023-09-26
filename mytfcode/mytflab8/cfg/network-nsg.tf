################################################
#  Subnet 1 NSG
################################################

resource "azurerm_network_security_group" "subnet1" {
  name                = "${var.subscriptionname}-network-vnet-${azurerm_subnet.subnet1.name}-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.network.name

  security_rule {
    name                       = "AllowDnsFrom${azurerm_subnet.subnet1.name}toFirewall"
    description                = "Allow Dns From ${azurerm_subnet.subnet1.name} to Firewall"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "53"                                       // DNS
    source_address_prefix      = azurerm_subnet.subnet1.address_prefixes[0] // Subnet 1
    destination_address_prefix = "10.100.1.4"                               // Hub firewall
  }

  
  security_rule {
    name                   = "AllowDeployFromDevopsagentsTo${azurerm_subnet.subnet1.name}"
    description            = "Allow deployment from the self-hosted DevOps agents to ${azurerm_subnet.subnet1.name}"
    priority               = 1100
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "Tcp"
    source_port_range      = "*"
    destination_port_range = "443" // HTTPS
    source_address_prefixes = [
      "10.100.13.0/26", // p-we1dep-network-vnet
      "10.100.16.0/26"  // p-we1dep-network-vnet (VMSS)
    ]
    destination_address_prefixes = azurerm_subnet.subnet1.address_prefixes
  }

  ################################################
  # Start Workload Rules
  ################################################

  ## Destination: Key Vault

  security_rule {
    name                       = "AllowHttpsFromAppserviceplanToKeyvault"
    description                = "Allow SQL from ASE to Key Vault"
    priority                   = 1200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"                                   // TCP
    source_address_prefixes    = azurerm_subnet.subnet1.address_prefixes // App Service Plan 
    destination_address_prefix = azurerm_private_endpoint.keyvault.private_dns_zone_configs[0].record_sets[0].ip_addresses[0] // Key Vault Private Endpoint
  }

    security_rule {
    name                       = "AllowHttpsFromnewsmailToStorageblobprivateendpoint"
    description                = "Allow Https from the newsmail Private Endpoint subnet to the Storage Account Blob Private Endpoint"
    priority                   = 1300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"                       // HTTPS
    source_address_prefixes    = var.subnet1Prefixes         // App Service VNet Integration Subnet
    destination_address_prefix = var.plan1-function1-blob-ip // Storage Account Blob Private Endpoint
  }

  security_rule {
    name              = "AllowFilesFromnewsmailToStoragefileprivateendpoint"
    description       = "Allow Https and SMB from the newsmail Private Endpoint subnet to the Storage Account Azure Files Private Endpoint"
    priority          = 1400
    direction         = "Inbound"
    access            = "Allow"
    protocol          = "Tcp"
    source_port_range = "*"
    destination_port_ranges = [
      "443", // HTTPS
      "445"  // SMB
    ]
    source_address_prefixes    = var.subnet1Prefixes               // App Service VNet Integration Subnet
    destination_address_prefix = var.plan1-function1-fileshare1-ip // Storage Account Azure Files Private Endpoint
  }

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

  security_rule {
    name                   = "AllowDeployFromDevopsagentsTo${azurerm_subnet.subnet2.name}"
    description            = "Allow deployment from the self-hosted DevOps agents to ${azurerm_subnet.subnet2.name}"
    priority               = 1100
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "Tcp"
    source_port_range      = "*"
    destination_port_range = "443" // HTTPS
    source_address_prefixes = [
      "10.100.13.0/26", // p-we1dep-network-vnet
      "10.100.16.0/26"  // p-we1dep-network-vnet (VMSS)
    ]
    destination_address_prefixes = azurerm_subnet.subnet2.address_prefixes
  }

  ################################################
  # Start Workload Rules
  ################################################

## Destination: Web Apps

security_rule {
    name                       = "AllowHttpsFromWafToFunctionapp1"
    description                = "Allow HTTPS from the Public WAF Subnet to Function App 1 Private Endpoint"
    priority                   = 1200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"                  // TCP
    source_address_prefix      = "10.100.4.0/24"        // p-we1waf-network-vnet-PublicWafSubnet
    destination_address_prefix = var.plan1-function1-ip // Plan 1 Function App 1
  }

  ## Destination: Key Vault

  security_rule {
    name                       = "AllowHttpsFromAppserviceplanToKeyvault"
    description                = "Allow ASE to Key Vault"
    priority                   = 1300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"                                                                                        // TCP
    source_address_prefixes    = azurerm_subnet.subnet1.address_prefixes                                                      // App Service Plan 
    destination_address_prefix = azurerm_private_endpoint.keyvault.private_dns_zone_configs[0].record_sets[0].ip_addresses[0] // Key Vault Private Endpoint
  }

  ## Destination: Storage Account

  security_rule {
    name                       = "AllowHttpsFromnewsmailToStorageblobprivateendpoint"
    description                = "Allow Https from the Ganexo Webhook Private Endpoint subnet to the Storage Account Blob Private Endpoint"
    priority                   = 1400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"                       // HTTPS
    source_address_prefixes    = var.subnet1Prefixes         // App Service VNet Integration Subnet
    destination_address_prefix = var.plan1-function1-blob-ip // Storage Account Blob Private Endpoint
  }

  security_rule {
    name              = "AllowFilesFromnewsmailToStoragefileprivateendpoint"
    description       = "Allow Https and SMB from the Ganexo Webhook Private Endpoint subnet to the Storage Account Azure Files Private Endpoint"
    priority          = 1500
    direction         = "Inbound"
    access            = "Allow"
    protocol          = "Tcp"
    source_port_range = "*"
    destination_port_ranges = [
      "443", // HTTPS
      "445"  // SMB
    ]
    source_address_prefixes    = var.subnet1Prefixes               // App Service VNet Integration Subnet
    destination_address_prefix = var.plan1-function1-fileshare1-ip // Storage Account Azure Files Private Endpoint
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
