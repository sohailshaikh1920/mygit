
###############################################################
# Create a spoke firewall collection rule on central firewall 
###############################################################
#
# Rule suffix can be found on these links
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_application_rule_collection
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_network_rule_collection
#

################################################
# Network Workload Rules
################################################
resource "azurerm_firewall_policy_rule_collection_group" "spoke" {
  provider           = azurerm.pwe1net
  name               = var.subscriptionname
  priority           = 11600
  firewall_policy_id = data.azurerm_firewall.firewall.firewall_policy_id

  network_rule_collection {
    name     = "Network-Allow-p-we1xlf"
    priority = 300
    action   = "Allow"
    rule {
      name                  = "AllowDnsFromVnetToFirewall"
      protocols             = ["UDP"]
      source_addresses      = ["10.100.13.192/26"] // p-we1xlf-network-vnet
      destination_addresses = ["10.100.1.4"]       // AzureFirewall
      destination_ports     = ["53"]               // DNS
    }
    rule {
      name                  = "AllowDnsFromFirewallToVnet"
      protocols             = ["UDP"]
      source_addresses      = ["10.100.1.4"]       // AzureFirewall
      destination_addresses = ["10.100.13.192/26"] // p-we1xlf-network-vnet
      destination_ports     = ["53"]               // DNS
    }
    rule {
      name                  = "AllowPwe1xlfFromWafToPwe1xlf"
      protocols             = ["TCP"]
      source_addresses      = ["10.100.4.0/24"]    // Waf
      destination_addresses = ["10.100.13.192/27"] // p-we1xlf Subnet
      destination_ports     = ["443"]              // SSL - encrypted web traffic
    }
    rule {
      name                  = "AllowPrivatesubnetFromWafToPrivatesubnet"
      protocols             = ["TCP"]
      source_addresses      = ["10.100.4.0/24"]    // Waf
      destination_addresses = ["10.100.13.224/27"] // p-we1xlf Private link Subnet
      destination_ports     = ["80"]               // HTTP traffic
    }
    rule {
      name                  = "AllowRdpFromAzureBastionsubnetToVnet"
      protocols             = ["TCP"]
      source_addresses      = ["10.100.3.128/26"]  // Hub Bastion
      destination_addresses = ["10.100.13.192/26"] // p-we1xlf-network-vnet
      destination_ports     = ["3389"]             // RDP
    }
    ################################################
    # Start Workload Rules
    ################################################
    rule {
      name                  = "AllowSqlFromMontelXlfToSqlservers"
      protocols             = ["TCP"]
      source_addresses      = ["10.100.13.192/27"] // p-we1xlf ASE Subnet
      destination_addresses = ["10.100.10.228"]    // p-we1dat-sql01
      destination_ports     = ["1433"]             // SQL
    }
    rule {
      name             = "AllowSqlFromMontelXlfToOnpremsql"
      protocols        = ["TCP"]
      source_addresses = ["10.100.13.192/27"] // p-we1xlf ASE Subnet
      destination_fqdns = [
        "db-prod1.montel.local",      // On-prem SQL Server
        "p-we1dat-sql01.montel.local" // p-we1dat-sql01
      ]
      destination_ports = ["1433"] // SQL
    }
    rule {
      name             = "AllowSqlFromMontelxlapp01fToOnpremsql"
      protocols        = ["TCP"]
      source_addresses = ["10.100.13.229"] // p-we1xlf-app01
      destination_fqdns = [
        "db-prod1.montel.local",      // On-prem SQL Server
        "p-we1dat-sql01.montel.local" // p-we1dat-sql01
      ]
      destination_ports = ["1433"] // SQL
    }
    ################################################
    # End Workload Rules
    ################################################

  }

  ################################################
  # Application Workload Rules
  ################################################
  application_rule_collection {
    name     = "Application-Allow-p-we1xlf"
    priority = 400
    action   = "Allow"
    rule {
      name = "AllowHttpsFromOsloclientnetworkToMontelXLF" //Temp Rule.TBD
      protocols {
        type = "Https"
        port = 443 // SSL - encrypted web traffic
      }
      source_addresses  = ["192.168.40.0/24"]                                               // Oslo on-premises client network
      destination_fqdns = ["p-we1xlf-montelxlf-app.scm.p-we1xlf.appserviceenvironment.net"] // App Services Endpoints
    }
    #    rule {
    #      name = "AllowHttpsFromWafToMontelWebApp"
    #      protocols {
    #        type = "Https"
    #        port = 443 // SSL - encrypted web traffic
    #      }
    #      source_addresses  = ["10.100.4.0/24"]                                             // p-we1waf-network
    #      destination_fqdns = ["p-we1xlf-montelxlf-app.p-we1xlf.appserviceenvironment.net"] // Montel XLF
    #    }
  }
}
