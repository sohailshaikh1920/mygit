################################################
#  Azure Bastion Public IP
################################################

resource "azurerm_public_ip" "Bastion001" {
  name                = "p-we1net-network-bastion-pip001"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name

  allocation_method = "Static"
  sku               = "Standard"
  zones             = var.zones
}


################################################
#  Azure Bastion
################################################

resource "azurerm_bastion_host" "Bastion" {
  name                = "p-we1net-network-bastion"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name

  sku                    = var.Bastion-sku
  copy_paste_enabled     = var.Bastion-copy_paste_enabled
  file_copy_enabled      = var.Bastion-file_copy_enabled
  ip_connect_enabled     = var.Bastion-ip_connect_enabled
  shareable_link_enabled = var.Bastion-shareable_link_enabled
  tunneling_enabled      = var.Bastion-tunneling_enabled

  ip_configuration {
    name                 = "IpConf"
    public_ip_address_id = azurerm_public_ip.Bastion001.id
    subnet_id            = azurerm_subnet.AzureBastionSubnet.id
  }

  depends_on = [
    azurerm_subnet.AzureBastionSubnet,
  ]
}

################################################
#  Azure Bastion Diagnostics
################################################


resource "azurerm_monitor_diagnostic_setting" "Bastion" {
  name                       = data.azurerm_log_analytics_workspace.central.name
  target_resource_id         = azurerm_bastion_host.Bastion.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.central.id

  log {
    category = "BastionAuditLogs"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
}
