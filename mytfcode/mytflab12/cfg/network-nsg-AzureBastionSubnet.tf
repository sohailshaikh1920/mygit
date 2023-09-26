################################################
#  AzureBastionSubnet NSG
################################################

resource "azurerm_network_security_group" "AzureBastionSubnet" {
  name                = "${var.subscriptionname}-network-vnet-${azurerm_subnet.AzureBastionSubnet.name}-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.network.name

  ################################################
  # Inbound Rules
  ################################################

  security_rule {
    name                       = "AllowHttpsFromInterntToAzurebastionsubnet"
    description                = "Allow remote traffic via HTTPS from Azure Gateway Manager to the Azure Bastion Subnet"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "Internet"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "443" // HTTPS
  }

  security_rule {
    name                       = "AllowHttpsFromGatewaymanagerToAzurebastionsubnet"
    description                = "Allow control plane traffic from Azure Gateway Manager to the Azure Bastion Subnet"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "GatewayManager"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "443" // HTTPS
  }

  security_rule {
    name                       = "AllowHttpsFromAzureLoadBalancerToAzurebastionsubnet"
    description                = "Allow control plane traffic from Azure Gateway Manager to the Azure Bastion Subnet"
    priority                   = 1200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "AzureLoadBalancer"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "443" // HTTPS
  }

  security_rule {
    name                       = "AllowBastionHostCommunicationToAzurebastionsubnet"
    description                = "Allow control plane traffic from Azure Gateway Manager to the Azure Bastion Subnet"
    priority                   = 1300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_address_prefix      = "VirtualNetwork"
    source_port_range          = "*"
    destination_address_prefix = "VirtualNetwork"
    destination_port_ranges = [
      "5701", // Control
      "8080", // Alternative HTTP
    ]
  }

  security_rule {
    name                       = "DenyAll"
    description                = "Deny all other traffic and override the default AllowVnetInBound rule"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "*"
  }



  ################################################
  # Outbound Rules
  ################################################

  security_rule {
    name                       = "AllowSshRdpFromAzurebastionsubnetToVirtualNetwork"
    description                = "Allow RDP and SSH from Azure Bastion Subnet to the Virtual Network"
    priority                   = 1000
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "VirtualNetwork"
    destination_port_ranges = [
      "22",   // SSH
      "3389", // RDP
    ]
  }

  security_rule {
    name                       = "AllowHttpsFromAzurebastionsubnetToAzureCloud"
    description                = "Allow HTTPS from Azure Bastion Subnet to Azure Cloud for diagnostics and monitoring"
    priority                   = 1100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "AzureCloud"
    destination_port_range     = "443" // HTTPS
  }

  security_rule {
    name                       = "AllowBastionCommunicationFromAzurebastionsubnetToVirtualNetwork"
    description                = "Allow data plane communication between the underlying components of Azure Bastion and the Virtual Network"
    priority                   = 1200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_address_prefix      = "VirtualNetwork"
    source_port_range          = "*"
    destination_address_prefix = "VirtualNetwork"
    destination_port_ranges = [
      "5701", // Control
      "8080", // Alternative HTTP
    ]
  }

  security_rule {
    name                       = "AllowGetSessionInformationFromAzurebastionsubnetToInternet"
    description                = "Allow HTTPS from Azure Bastion Subnet to the Internet for for session and certificate validation"
    priority                   = 1300
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "Internet"
    destination_port_range     = "80" // HTTP
  }
}


################################################
#  AzureBastionSubnet NSG Association
################################################

# Attach NSG to subnet
resource "azurerm_subnet_network_security_group_association" "AzureBastionSubnet" {
  subnet_id                 = azurerm_subnet.AzureBastionSubnet.id
  network_security_group_id = azurerm_network_security_group.AzureBastionSubnet.id
}


###################################################################
#  AzureBastionSubnet NSG Flow Logs and Traffic Analytics
###################################################################
resource "azurerm_network_watcher_flow_log" "AzureBastionSubnet_flowfront" {
  name                 = "Vnet${azurerm_subnet.AzureBastionSubnet.name}-flowlog"
  location             = var.location
  network_watcher_name = azurerm_network_watcher.network.name
  resource_group_name  = azurerm_resource_group.network.name

  network_security_group_id = azurerm_network_security_group.AzureBastionSubnet.id
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


