
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
  priority           = var.firewall_rules_collection_group_priority
  firewall_policy_id = data.azurerm_firewall.firewall.firewall_policy_id

  network_rule_collection {
    name     = "Network-Allow-${var.subscriptionname}"
    priority = 300
    action   = "Allow"
    rule {
      name                  = "AllowDnsFromVnetToFirewall" // Allow DNS from the workload virtual network to the Azure Firewall
      protocols             = ["UDP"]
      source_addresses      = ["${var.vnetaddress}"] // Workload Virtual Network
      destination_addresses = ["10.100.1.4"]         // AzureFirewall
      destination_ports     = ["53"]                 // DNS
    }
    rule {
      name                  = "AllowDnsFromFirewallToVnet" // Allow DNS from the Azure Firewall to the workload virtual network
      protocols             = ["UDP"]
      source_addresses      = ["10.100.1.4"]         // AzureFirewall
      destination_addresses = ["${var.vnetaddress}"] // Workload Virtual Network
      destination_ports     = ["53"]                 // DNS
    }
    ################################################
    # Start Workload Rules
    ################################################

    ## Destination: Web Apps

    rule {
      name                  = "AllowHttpsFromWafToFunctionapp1" // Allow HTTPS from the Public WAF Subnet to Function App 1 Private Endpoint
      protocols             = ["TCP"]
      source_addresses      = ["10.100.4.0/24"]        // p-we1waf-network-vnet-PublicWafSubnet
      destination_addresses = [var.plan1-function1-ip] // Plan 1 Function App 1
      destination_ports     = ["443"]                  // HTTPS
    }

    rule {
      name                  = "AllowWebdeployFromDevopsagentToFunctionapp1" // Allow HTTPS from the Public WAF Subnet to Function App 1 Private Endpoint
      protocols             = ["TCP"]
      source_addresses      = ["10.100.13.0/26"]       // p-we1dep-network-vnet
      destination_addresses = [var.plan1-function1-ip] // Plan 1 Function App 1
      destination_ports     = ["443"]                  // HTTPS
    }

    ################################################
    # End Workload Rules
    ################################################

  }

  ################################################
  # Application Workload Rules
  ################################################
  /*
  application_rule_collection {
    name     = "Application-Allow-${var.subscriptionname}"
    priority = 500
    action   = "Allow"

    ## Source: WebApps

    rule {
      name = "AllowHttpsFromWebAppsToAccountadmin" // Allow HTTPS from the App Services to Account Admin for user authentication
      protocols {
        type = "Https"
        port = 443 // SSL - encrypted web traffic
      }
      source_addresses = azurerm_subnet.subnet1.address_prefixes // AseSubnet
      destination_fqdns = [
        "*.p-we1adm-ase.appserviceenvironment.net", // Account Admin ASE
        "auth-admin.montelnews.com",                // Legacy app service
        "authenticate.montelgroup.com"              // Legacy app service
      ]
    }
  } */
}
