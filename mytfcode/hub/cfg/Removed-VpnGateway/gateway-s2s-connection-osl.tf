################################################
#  VPN - Oslo Head Office Connection
################################################


################################################
#  Local Network Gateway
################################################

resource "azurerm_local_network_gateway" "Osl" {
  name                = "${azurerm_resource_group.network.name}-vpn-osl-lgw"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name

  address_space = [
    "10.10.250.12/30",
    "10.1.0.0/16",
    "10.10.0.0/16",
    "192.168.40.0/24",
    "91.251.33.10/32",   // Deutche Borse
    "91.251.33.11/32",   // Deutche Borse
    "91.251.33.13/32",   // Deutche Borse
    "91.251.33.14/32",   // Deutche Borse
    "91.251.34.10/32",   // Deutche Borse
    "91.251.34.11/32",   // Deutche Borse
    "91.251.34.13/32",   // Deutche Borse
    "91.251.34.14/32",   // Deutche Borse
    "185.55.105.213/32", // Montel AI
    "185.55.105.218/32", // Montel AI
    "185.55.105.205/32"  // Montel AI
  ]
  gateway_address = "185.55.105.221"
}


################################################
#  VPN Connection Pre-Shared Key
################################################

data "azurerm_key_vault_secret" "Osl" {
  name         = "OslVpnPreSharedKey"
  key_vault_id = data.azurerm_key_vault.SharedNetworkingKeyVault.id
}

################################################
#  VPN Connection
################################################

resource "azurerm_virtual_network_gateway_connection" "Osl" {
  name                = "${azurerm_resource_group.network.name}-vpn-osl-con"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name

  local_network_gateway_id   = azurerm_local_network_gateway.Osl.id
  virtual_network_gateway_id = azurerm_virtual_network_gateway.S2sGateway.id

  shared_key                         = data.azurerm_key_vault_secret.Osl.value
  dpd_timeout_seconds                = 45
  type                               = "IPsec"
  connection_protocol                = "IKEv2"
  connection_mode                    = "Default"
  routing_weight                     = "0"
  enable_bgp                         = false
  local_azure_ip_address_enabled     = false
  use_policy_based_traffic_selectors = false
  ipsec_policy {
    sa_lifetime      = "27000"
    sa_datasize      = "102400000"
    dh_group         = "DHGroup2"
    ike_encryption   = "AES256"
    ike_integrity    = "SHA256"
    ipsec_encryption = "AES256"
    ipsec_integrity  = "SHA256"
    pfs_group        = "PFS2"
  }

  depends_on = [
    azurerm_virtual_network_gateway.S2sGateway,
  ]
}

