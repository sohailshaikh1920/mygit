################################################
#  Subnet 1 NSG
################################################

resource "azurerm_network_security_group" "subnet1" {
  name                = "${var.subscriptionname}-network-vnet-${azurerm_subnet.subnet1.name}-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.network.name

  security_rule {
    name                         = "AllowDnsFromFirewallTo${azurerm_subnet.subnet1.name}"
    description                  = "Allow DNS responses from the Azure Firewall to ${azurerm_subnet.subnet1.name}"
    priority                     = 1000
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Udp"
    source_port_range            = "*"
    destination_port_range       = "53"         // DNS
    source_address_prefix        = "10.100.1.4" // Hub firewall
    destination_address_prefixes = azurerm_subnet.subnet1.address_prefixes
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

  security_rule {
    name                         = "AllowWAFProbeFromInternetTo${azurerm_subnet.subnet1.name}"
    description                  = "Allow Application Gateway health monitoring from Internet to the ${azurerm_subnet.subnet1.name}"
    priority                     = 1200
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "65200-65535" // Health monitoring
    source_address_prefix        = "GatewayManager"
    destination_address_prefixes = azurerm_subnet.subnet1.address_prefixes
  }

  security_rule {
    name                         = "AllowHttpFromInternetTo${azurerm_subnet.subnet1.name}"
    description                  = "Allow HTTP from Internet clients to the ${azurerm_subnet.subnet1.name}"
    priority                     = 1300
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "80" // HTTP
    source_address_prefix        = "Internet"
    destination_address_prefixes = azurerm_subnet.subnet1.address_prefixes
  }

    security_rule {
    name                         = "AllowHttpsFromInternetTo${azurerm_subnet.subnet1.name}"
    description                  = "Allow HTTPS from Internet clients to the ${azurerm_subnet.subnet1.name}"
    priority                     = 1400
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "443" // HTTP
    source_address_prefix        = "Internet"
    destination_address_prefixes = azurerm_subnet.subnet1.address_prefixes
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
  name                 = "${azurerm_subnet.subnet1.name}-flowlog"
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
