
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

    ## Source: Web Apps

    rule {
      name                  = "AllowRabitMqFromAppserviceToServicebus" // Allow HTTPS from the App Service Integration subnet to Service Bus Service Tag
      protocols             = ["TCP"]
      source_addresses      = var.subnet1Prefixes // p-we1nml-network-vnet-IntegrationSubnet
      destination_fqdns = [
        "newsmail-sbus.servicebus.windows.net" // Service Bus
        ] 
      destination_ports     = ["5671"] // RabbitMQ
    }

    rule {
      name                  = "AllowSqlFromAppserviceToDevdatabase" // Allow HTTPS from the App Service Integration subnet to Service Bus Service Tag
      protocols             = ["TCP"]
      source_addresses      = var.subnet1Prefixes // p-we1nml-network-vnet-IntegrationSubnet
      destination_addresses = [
        "10.10.110.221" // Dev Database
        ] 
      destination_ports     = ["1433"] // SQL 
    }

    ################################################
    # End Workload Rules
    ################################################

  }

  ################################################
  # Application Workload Rules
  ################################################
  
  application_rule_collection {
    name     = "Application-Allow-${var.subscriptionname}"
    priority = 500
    action   = "Allow"

    ## Source: WebApps

    rule {
      name = "AllowHttpsFromWebAppsToMontelServices" // Allow traffic to Montel services
      protocols {
        type = "Https"
        port = 443 // SSL - encrypted web traffic
      }
      source_addresses = var.subnet1Prefixes // p-we1nml-network-vnet-IntegrationSubnet
      destination_fqdns = [
        "account-dev.montelnews.com", //
        "mnt-d-euw-news-api-svc.azurewebsites.net" //
      ]
    }

    rule {
      name = "AllowHttpsFromWebAppsToSendgrid" // Allow API access to SendGrid to send emails
      protocols {
        type = "Https"
        port = 443 // SSL - encrypted web traffic
      }
      source_addresses = var.subnet1Prefixes // p-we1nml-network-vnet-IntegrationSubnet
      destination_fqdns = [
        "api.sendgrid.com" // SendGrid API
      ]
    }
  } 
}
