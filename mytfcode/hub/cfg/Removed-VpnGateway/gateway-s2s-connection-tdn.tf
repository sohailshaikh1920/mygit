################################################
#  VPN - Tradition Data Feed
################################################


################################################
#  Local Network Gateway
################################################

resource "azurerm_local_network_gateway" "Tdn" {
  name                = "${azurerm_resource_group.network.name}-vpn-tdn-lgw"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name

  address_space = [
    "94.142.185.215/32",
    "94.142.185.216/32"
  ]
  gateway_address = "94.142.185.193"
}


################################################
#  NAT Rule
################################################

resource "azurerm_virtual_network_gateway_nat_rule" "Tdn" {
  name                = "tradition-to-p-we1dat-fdr03"
  resource_group_name = azurerm_resource_group.network.name

  virtual_network_gateway_id = azurerm_virtual_network_gateway.S2sGateway.id
  external_mapping {
    address_space = "129.212.80.80/32"
    port_range    = "21003"
  }
  internal_mapping {
    address_space = "10.100.10.6/32"
    port_range    = "21003"
  }

  depends_on = [
    azurerm_virtual_network_gateway.S2sGateway,
  ]
}


################################################
#  VPN Connection Pre-Shared Key
################################################

data "azurerm_key_vault_secret" "Tdn" {
  name         = "tdnVpnPreSharedKey"
  key_vault_id = data.azurerm_key_vault.SharedNetworkingKeyVault.id
}

################################################
#  VPN Connection
################################################

resource "azurerm_virtual_network_gateway_connection" "Tdn" {
  name                = "${azurerm_resource_group.network.name}-vpn-tdn-con"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name

  local_network_gateway_id   = azurerm_local_network_gateway.Tdn.id
  virtual_network_gateway_id = azurerm_virtual_network_gateway.S2sGateway.id

  egress_nat_rule_ids = [
    azurerm_virtual_network_gateway_nat_rule.Tdn.id
  ]

  shared_key                         = data.azurerm_key_vault_secret.Tdn.value
  dpd_timeout_seconds                = 60
  type                               = "IPsec"
  connection_protocol                = "IKEv2"
  connection_mode                    = "Default"
  routing_weight                     = "0"
  enable_bgp                         = false
  local_azure_ip_address_enabled     = false
  use_policy_based_traffic_selectors = false
  ipsec_policy {
    sa_lifetime      = "86400"
    sa_datasize      = "102400000"
    dh_group         = "DHGroup14"
    ike_encryption   = "AES256"
    ike_integrity    = "SHA256"
    ipsec_encryption = "AES256"
    ipsec_integrity  = "SHA256"
    pfs_group        = "PFS2048"
  }

  depends_on = [
    azurerm_virtual_network_gateway.S2sGateway,
  ]
}

