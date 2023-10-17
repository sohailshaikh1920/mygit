azurerm_firewall_policies = {
  hub_fw_policy1 = {
    name               = "p-we1net-network-fw-firewallpolicy"
    resource_group_key = "hub_vnet"
    region             = "region1"
    sku                = "Standard"

    # Required if you want to use Network rules with FQDNs
    dns = {
      proxy_enabled = true
    }

    #   threat_intelligence_mode = "Alert"

    #   threat_intelligence_allowlist = {
    #     ip_addresses = []
    #     fqdns        = []
    #   }

    #   intrusion_detection = {
    #     mode                = "Alert"
    #     signature_overrides = {
    #       id    = ""
    #       state = ""
    #     }
    #     traffic_bypass      = {
    #       name                  = ""
    #       protocol              = ""
    #       description           = ""
    #       destination_addresses = ""
    #       destination_ip_groups = ""
    #       destination_ports     = ""
    #       source_addresses      = ""
    #       source_ip_groups      = ""
    #     }
  }
}