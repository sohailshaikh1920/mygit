################################################
#  Nwsadm NSG
################################################
resource "azurerm_network_security_group" "frontendsubnet" {
  name                = "${var.subscriptionname}-network-vnet-FrontendSubnet-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.network.name

  security_rule {
    name                       = "AllowDnsFromFirewallToFrontendSubnet"
    description                = "Allow Dns From Firewall To FrontendSubnet"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "53"               // DNS
    source_address_prefix      = "10.100.1.4"       // Hub firewall
    destination_address_prefix = "10.100.11.192/27" // Nwsadm subnet
  }

  security_rule {
    name                       = "AllowRdpFromAzureBastionSubnetToFrontendSubnet"
    description                = "Allow Dns From Azure Bastion Subnet To FrontendSubnet"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"             // RDP
    source_address_prefix      = "10.100.3.128/26"  // Hub Azure Bastion subnet
    destination_address_prefix = "10.100.11.192/27" // Nwsadm subnet
  }

  security_rule {
    name                   = "AllowDeployFromDevopsagentsTo${azurerm_subnet.frontendsubnet.name}"
    description            = "Allow deployment from the self-hosted DevOps agents to ${azurerm_subnet.frontendsubnet.name}"
    priority               = 1200
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "Tcp"
    source_port_range      = "*"
    destination_port_range = "443" // HTTPS
    source_address_prefixes = [
      "10.100.16.0/26" // p-we1dep-network-vnet (VMSS)
    ]
    destination_address_prefixes = azurerm_subnet.frontendsubnet.address_prefixes
  }

  ################################################
  # Start Workload Rules
  ################################################
  security_rule {
    name                       = "AllowApp01FromWafToApp01"
    description                = "Allow App01 From Waf To App01"
    priority                   = 1300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1011"            // Waf
    source_address_prefix      = "10.100.4.0/24"   // WAF
    destination_address_prefix = "10.100.11.196"   // p-nwsadm-app01
  }
  ################################################
  # End Workload Rules
  ################################################
  security_rule {
    name                       = "AllowProbeFromAzureloadbalancerToFrontendSubnet"
    description                = "Allow Probe From Azureloadbalancer To FrontendSubnet"
    priority                   = 3900
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"                                               // All
    source_address_prefix      = "AzureLoadBalancer"                               // Azure Load Balancer service tag
    destination_address_prefix = azurerm_subnet.frontendsubnet.address_prefixes[0] // Frontend subnet
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


# ################################################
# #  Nwsadm NSG Diagnostic Settings
# ################################################
# resource "azurerm_monitor_diagnostic_setting" "frontend_nsg_diagnostic_settings" {
#   name                       = data.azurerm_log_analytics_workspace.central.name
#   target_resource_id         = azurerm_network_security_group.frontendsubnet.id
#   log_analytics_workspace_id = data.azurerm_log_analytics_workspace.central.id
#   storage_account_id         = azurerm_storage_account.saflowlogs.id
# }


###################################################################
#  Enable traffic Analytics on Frontend and send to Log Analytics
###################################################################
resource "azurerm_network_watcher_flow_log" "frontend_flowfront" {
  name                 = "FrontendSubnet-flowlog"
  location             = var.location
  network_watcher_name = azurerm_network_watcher.network.name
  resource_group_name  = azurerm_resource_group.network.name

  network_security_group_id = azurerm_network_security_group.frontendsubnet.id
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

