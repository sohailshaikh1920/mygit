azurerm_firewalls = {
  hub_fw = {
    name                = "p-rg1net-network-fw"
    resource_group_key  = "hub_vnet"
    vnet_key            = "hub_vnet"
    sku_tier            = "Standard"
    zones               = [1, 2, 3]
    firewall_policy_key = "hub_fw_policy1"
    public_ips = {
      ip1 = {
        name          = "p-rg1net-network-fw-pip1"
        public_ip_key = "hub_fw_pip1"
        vnet_key      = "hub_vnet"
        subnet_key    = "AzureFirewallSubnet"
        # lz_key = "lz_key"
      }
    }
    # diagnostic_profiles = {
    #   #   central_logs_region1 = {
    #   #     definition_key   = "azurerm_firewall"
    #   #     destination_type = "event_hub"
    #   #     destination_key  = "central_logs"
    #   #   }
    #   operations = {
    #     name             = "operations"
    #     definition_key   = "azurerm_firewall"
    #     destination_type = "log_analytics"
    #     destination_key  = "central_logs"
    #   }
    # }
  }
}