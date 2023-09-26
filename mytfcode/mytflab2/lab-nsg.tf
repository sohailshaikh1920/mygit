
################################# NSG01 #####################################
resource "azurerm_network_security_group" "spoke01nsg" {
  name                = "spoke01nsg"
  location            = azurerm_resource_group.labrg01.location
  resource_group_name = azurerm_resource_group.labrg01.name


  security_rule {
    name                       = "Denyall"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPFromFW"
    priority                   = 3000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "192.168.1.4"
    destination_address_prefix = "192.168.10.0/26"
  }

  security_rule {
    name                       = "AllowRDPFromFW"
    priority                   = 2000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "192.168.1.0/24" ########### 1.4 is FW but NSG flow logs shows that 1.5 & 1.6 is blocked hence full range is opened ################
    destination_address_prefix = "192.168.10.0/26"
  }

  security_rule {
    name                       = "AllowRDPFromBastionHost"
    priority                   = 2001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "192.168.0.5"
    destination_address_prefix = "192.168.10.0/26"
  }

}

resource "azurerm_subnet_network_security_group_association" "spoke01asoc" {
  subnet_id                 = azurerm_subnet.labsn02.id
  network_security_group_id = azurerm_network_security_group.spoke01nsg.id
}

################################# NSG02 #####################################

resource "azurerm_network_security_group" "spoke02nsg" {
  name                = "spoke02nsg"
  location            = azurerm_resource_group.labrg01.location
  resource_group_name = azurerm_resource_group.labrg01.name


  security_rule {
    name                       = "Denyall"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowFW"
    priority                   = 3000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "192.168.1.4"
    destination_address_prefix = "192.168.11.0/26"
  }

  security_rule {
    name                       = "AllowRDPFromFW"
    priority                   = 2000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "192.168.1.0/24" ########### 1.4 is FW but NSG flow logs shows that 1.5 & 1.6 is blocked hence full range is opened ################
    destination_address_prefix = "192.168.11.0/26"
  }

  security_rule {
    name                       = "AllowRDPFromBastionHost"
    priority                   = 2001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "192.168.0.5"
    destination_address_prefix = "192.168.11.0/26"
  }


}

resource "azurerm_subnet_network_security_group_association" "spoke02asoc" {
  subnet_id                 = azurerm_subnet.labsn03.id
  network_security_group_id = azurerm_network_security_group.spoke02nsg.id
}



##################### NSG flow logs Storage Account ##########################

# Log collection components
resource "azurerm_storage_account" "labnsgflowlogstorage" {
  name                = "labnsgflowlogstorage1920"
  resource_group_name = azurerm_resource_group.labrg01.name
  location            = azurerm_resource_group.labrg01.location

  account_tier             = "Standard"
  account_replication_type = "LRS"
}

##################### Network Watcher for same region ##########################

# The Network Watcher Instance & network log flow
# There can only be one Network Watcher per subscription and region

resource "azurerm_network_watcher" "labnetworkwatcher" {
  name                = "labnetworkwatcher"
  location            = azurerm_resource_group.labrg01.location
  resource_group_name = azurerm_resource_group.labrg01.name
}

##################### NSG flow logs for spoke01nsg ##########################

resource "azurerm_network_watcher_flow_log" "spoke01nsgwatcherlogs" {
  name                 = "spoke01nsgwatcherlogs"
  network_watcher_name = azurerm_network_watcher.labnetworkwatcher.name
  resource_group_name  = azurerm_resource_group.labrg01.name

  network_security_group_id = azurerm_network_security_group.spoke01nsg.id
  storage_account_id        = azurerm_storage_account.labnsgflowlogstorage.id
  version                   = 2
  enabled                   = true

  retention_policy {
    enabled = true
    days    = 3
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = azurerm_log_analytics_workspace.lablaw.workspace_id
    workspace_region      = azurerm_log_analytics_workspace.lablaw.location
    workspace_resource_id = azurerm_log_analytics_workspace.lablaw.id
    interval_in_minutes   = 10
  }
}


##################### NSG flow logs for spoke02nsg ##########################


# The Network Watcher Instance & network log flow
# There can only be one Network Watcher per subscription and region

resource "azurerm_network_watcher_flow_log" "spoke02nsgwatcherlogs" {
  name                 = "spoke02nsgwatcherlogs"
  network_watcher_name = azurerm_network_watcher.labnetworkwatcher.name
  resource_group_name  = azurerm_resource_group.labrg01.name

  network_security_group_id = azurerm_network_security_group.spoke02nsg.id
  storage_account_id        = azurerm_storage_account.labnsgflowlogstorage.id
  version                   = 2
  enabled                   = true

  retention_policy {
    enabled = true
    days    = 3
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = azurerm_log_analytics_workspace.lablaw.workspace_id
    workspace_region      = azurerm_log_analytics_workspace.lablaw.location
    workspace_resource_id = azurerm_log_analytics_workspace.lablaw.id
    interval_in_minutes   = 10
  }
}