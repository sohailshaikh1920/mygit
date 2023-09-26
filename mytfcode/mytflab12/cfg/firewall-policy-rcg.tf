################################################
#  VDC Instance Rules Collection Group
################################################

resource "azurerm_firewall_policy_rule_collection_group" "AzureFirewall-Policy" {
  firewall_policy_id = azurerm_firewall_policy.AzureFirewall-Policy.id
  name               = "we1rules"
  priority           = 200

  ################################################
  #  NAT Rules
  ################################################

  nat_rule_collection {
    name     = "Nat-Dnat-we1"
    action   = "Dnat"
    priority = 100

    rule { // Dummy rule to make this rules collection possible
      name = "replaceMe"
      source_addresses = [
        "192.168.1.1",
      ]
      destination_ports = [
        "8080",
      ]
      destination_address = azurerm_public_ip.AzureFirewall001.ip_address
      translated_port    = 8080
      translated_address = "192.168.1.2"
      protocols = [
        "TCP",
      ]
    }

  }

  ################################################
  #  Network Deny Rules
  ################################################

  network_rule_collection {
    name     = "Network-Deny-we1"
    action   = "Deny"
    priority = 200

    rule { // Dummy rule to make this rules collection possible
      name = "testrule"
      source_addresses = [
        "192.168.1.1",
      ]
      destination_ports = [
        "8080", // HTTP Alternative
      ]
      destination_addresses = [
        "192.168.1.1",
      ]
      protocols = [
        "TCP",
      ]
    }

  }

  ################################################
  #  Network Allow Rules
  ################################################

  network_rule_collection {
    name     = "Network-Allow-we1"
    action   = "Allow"
    priority = 300

    rule { // Dummy rule to make this rules collection possible
      name = "testrule"
      source_addresses = [
        "192.168.1.1",
      ]
      destination_ports = [
        "8080", // HTTP Alternative
      ]
      destination_addresses = [
        "192.168.1.1",
      ]
      protocols = [
        "TCP",
      ]
    }

  }

  ################################################
  #  Application Deny Rules
  ################################################

  application_rule_collection {
    name     = "Application-Deny-we1"
    priority = 400
    action   = "Deny"

    rule { // Dummy rule to make this rules collection possible
      name = "testrule"
      source_addresses = [
        "192.168.1.1",
      ]
      destination_fqdns = [
        "test.microsoft.com",
      ]
      protocols {
        type = "Https"
        port = 443 // SSL - encrypted web traffic
      }
    }
  }

  ################################################
  #  Application Allow Rules
  ################################################

  application_rule_collection {
    name     = "Application-Allow-we1"
    priority = 500
    action   = "Allow"

    rule { // Dummy rule to make this rules collection possible
      name = "testrule"
      source_addresses = [
        "192.168.1.1",
      ]
      destination_fqdns = [
        "test.microsoft.com",
      ]
      protocols {
        type = "Https"
        port = 443 // SSL - encrypted web traffic
      }
    }

  }

}
