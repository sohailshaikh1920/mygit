################################################
#  ASE NSG
################################################
resource "azurerm_network_security_group" "ase" {
  name                = "${var.subscriptionname}-network-vnet-AseSubnet-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.network.name

  security_rule {
    name                       = "AllowDnsFromFirewallToAseSubnet"
    description                = "Allow Dns From Firewall To AseSubnet"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "53"               // DNS
    source_address_prefix      = "10.100.1.4"       // Hub firewall
    destination_address_prefix = "10.100.13.192/27" // Ase subnet
  }

  security_rule {
    name                   = "AllowDeployFromDevopsagentsTo${azurerm_subnet.ase.name}"
    description            = "Allow deployment from the self-hosted DevOps agents to ${azurerm_subnet.ase.name}"
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
    destination_address_prefixes = azurerm_subnet.ase.address_prefixes
  }

  ################################################
  # Start Workload Rules
  ################################################

  security_rule {
    name                       = "AllowHttpsFromOsloClientNetworkToMontelXLF" //Temporary.TBD
    description                = "Allow SCM From Oslo Client Network To Montel XLF"
    priority                   = 1200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"              // HTTPS
    source_address_prefix      = "192.168.40.0/24"  // Oslo Client Network
    destination_address_prefix = "10.100.13.192/27" //  p-we1xlf ASE Subnet
  }

  security_rule {
    name                       = "AllowHttpsFromWafToMontelXlf"
    description                = "Allow SSL Traffic From Waf To Montel Xlf"
    priority                   = 1300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"              // HTTPS
    source_address_prefix      = "10.100.4.0/24"    // WAF
    destination_address_prefix = "10.100.13.192/27" // p-we1xlf ASE Subnet
  }

  ################################################
  # End Workload Rules
  ################################################

  security_rule {
    name                       = "AllowProbeFromAzureloadbalancerToAseSubnet"
    description                = "Allow Probe From Azureloadbalancer To AseSubnet"
    priority                   = 3900
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"                                    // All
    source_address_prefix      = "AzureLoadBalancer"                    // Azure Load Balancer service tag
    destination_address_prefix = azurerm_subnet.ase.address_prefixes[0] // Ase subnet
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


################################################
#  PrivateLink NSG
################################################

resource "azurerm_network_security_group" "privatelink" {
  name                = "${var.subscriptionname}-network-vnet-PrivateLinkSubnet-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.network.name

  security_rule {
    name                       = "AllowDnsFromFirewallToPrivateLinksubnet"
    description                = "Protect the PrivateLinkSubnet"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "53"               // DNS
    source_address_prefix      = "10.100.1.4"       // Hub firewall
    destination_address_prefix = "10.100.13.224/27" // p-we1xlf PrivateLink subnet
  }

  security_rule {
    name                   = "AllowDeployFromDevopsagentsTo${azurerm_subnet.privatelink.name}"
    description            = "Allow deployment from the self-hosted DevOps agents to ${azurerm_subnet.privatelink.name}"
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
    destination_address_prefixes = azurerm_subnet.privatelink.address_prefixes
  }

  ################################################
  # Start Workload Rules
  ################################################

  security_rule {
    name                       = "AllowHttpFromWafToMontelOnline"
    description                = "Allow HTTP Traffic From Waf To Welxlf"
    priority                   = 1200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"               // HTTPS
    source_address_prefix      = "10.100.4.0/24"    // WAF
    destination_address_prefix = "10.100.13.224/27" // p-we1xlf subnet
  }

  ################################################
  # End Workload Rules
  ################################################

  security_rule {
    name                       = "AllowProbeFromAzureloadbalancerToPrivateLinkSubnet"
    description                = "Allow Probe From Azureloadbalancer To PrivateLinkSubnet"
    priority                   = 3900
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"                                            // All
    source_address_prefix      = "AzureLoadBalancer"                            // Azure Load Balancer service tag
    destination_address_prefix = azurerm_subnet.privatelink.address_prefixes[0] // PrivateLink subnet
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


############################################################################################################################################
# Create "Random string" to assist creation of resource unique names
############################################################################################################################################
resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
  numeric = true
}


################################################
#  NSG Flow Logs storage account
################################################
resource "azurerm_storage_account" "saflowlogs" {
  name                = "${local.subscriptionname}networkdiag${random_string.random.result}"
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location

  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "ZRS"
  enable_https_traffic_only = true
}



###################################################################
#  Enable traffic Analytics on ASE and send to Log Analytics
###################################################################
resource "azurerm_network_watcher_flow_log" "ase_flowfront" {
  name                 = "AseSubnet-flowlog"
  location             = var.location
  network_watcher_name = azurerm_network_watcher.network.name
  resource_group_name  = azurerm_resource_group.network.name

  network_security_group_id = azurerm_network_security_group.ase.id
  storage_account_id        = azurerm_storage_account.saflowlogs.id
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



###################################################################
#  Enable traffic Analytics on PrivateLink and send to Log Analytics
###################################################################
resource "azurerm_network_watcher_flow_log" "privatelink_flowfront" {
  name                 = "PrivateLinkSubnet-flowlog"
  location             = var.location
  network_watcher_name = azurerm_network_watcher.network.name
  resource_group_name  = azurerm_resource_group.network.name

  network_security_group_id = azurerm_network_security_group.privatelink.id
  storage_account_id        = azurerm_storage_account.saflowlogs.id
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
