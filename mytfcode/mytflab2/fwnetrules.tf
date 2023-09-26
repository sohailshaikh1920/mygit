############## Application rule collection group ##############################

resource "azurerm_firewall_policy_rule_collection_group" "internet" {
  name               = "internet"  ############# this name is rule collection group name ###############################
  firewall_policy_id = azurerm_firewall_policy.labfwpolicy01.id
  priority           = 100  ############## this is the priority for this group among other application group ###############################
  application_rule_collection {
    name     = "internet"   ######### this is rule group ##################
    priority = 100   ############ this is priority for this rule group ######################
    action   = "Allow"
    rule {
      name = "rule01"   ######### this is actual rule ##################
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = ["192.168.10.4"]
      destination_fqdns = ["www.google.com", "www.microsoft.com"]
    }
    rule {
      name = "rule02"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = ["192.168.11.4"]
      destination_fqdns = ["www.google.com", "www.microsoft.com"]
    }
  }

}

############## Network rule collection group ##############################

resource "azurerm_firewall_policy_rule_collection_group" "RDP" {
  name               = "HTTP"  ######### this is rule collection group ##################
  firewall_policy_id = azurerm_firewall_policy.labfwpolicy01.id
  priority           = 100   ######### this is priority but network rule group is prioritized over other group ##################
  network_rule_collection {
    name     = "rule01"  ######### this is rule group ##################
    priority = 100
    action   = "Allow"
    rule {
      name                  = "HTTP"
      protocols             = ["TCP"]
      source_addresses      = ["192.168.10.4"]
      destination_addresses = ["192.168.11.4"]
      destination_ports     = ["80"]
    }
  }


}

############## Dnat rule collection group ##############################
/*
resource "azurerm_firewall_policy_rule_collection_group" "RDPDNAT" {
  name               = "RDPDNAT"
  firewall_policy_id = azurerm_firewall_policy.labfwpolicy01.id
  priority           = 300

  nat_rule_collection {
    name     = "RDPDNAT"
    priority = 300
    action   = "Dnat"
    rule {
      name                = "rule01"
      protocols           = ["TCP"]
      source_addresses    = ["80.212.60.98"]
      destination_address = "4.235.1.29"
      destination_ports   = ["4000"]
      translated_address  = "192.168.10.4"
      translated_port     = "3389"
    }


    rule {
      name                = "rule02"
      protocols           = ["TCP"]
      source_addresses    = ["80.212.60.98"]
      destination_address = "4.235.1.29"
      destination_ports   = ["5000"]
      translated_address  = "192.168.11.4"
      translated_port     = "3389"
    }

  }
}

*/

