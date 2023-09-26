
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
  priority           = 11200
  firewall_policy_id = data.azurerm_firewall.firewall.firewall_policy_id

  network_rule_collection {
   name     = "Network-Allow-p-nwsadm"
    priority = 300
    action   = "Allow"
    rule {
      name                  = "AllowDnsFromVnetToFirewall"
      protocols             = ["UDP"]
      source_addresses      = ["10.100.11.192/26"] // p-nwsadm-network-vnet
      destination_addresses = ["10.100.1.4"]     // AzureFirewall
     destination_ports     = ["53"]             // DNS
    }
    rule {
      name                  = "AllowDnsFromFirewallToVnet"
      protocols             = ["UDP"]
      source_addresses      = ["10.100.1.4"]     // AzureFirewall
      destination_addresses = ["10.100.11.192/26"] // p-nwsadm-network-vnet
     destination_ports     = ["53"]             // DNS
    }
    rule {
      name                  = "AllowRdpFromAzureBastionsubnetToVnet"
      protocols             = ["TCP"]
      source_addresses      = ["10.100.3.128/26"] // Hub Bastion
      destination_addresses = ["10.100.11.192/26"]  // p-nwsadm-network-vnet
      destination_ports     = ["3389"]            // RDP
    }
    # ##############################################
    # Start Workload Rules
    ################################################
    ## Source: p-nwsadm-app01
    rule {
      name                  = "AllowRabbitmqFromApp01ToRabbitmq"
      protocols             = ["TCP"]
      source_addresses      = ["10.100.11.196"]    // p-nwsadm-app01
      destination_addresses = ["10.100.11.68"]     // p-rabtmq-rmq01
      destination_ports     = ["5672"]             // Rabbitmq
    }
    rule {
      name              = "AllowSqlFromApp01ToOnpremsql"
      protocols         = ["TCP"]
      source_addresses  = ["10.100.11.196"]   // p-nwsadm-app01
      destination_fqdns = [
        "db-prod1.montel.local",             // On-prem SQL Server
        "mon-db01.montel.local",             // On-prem SQL Server
        "ag2-listener.montel.local",         // On-prem SQL Server
        "kull.montel.local",                 // On-prem SQL Server
        "p-we1dat-sql01.montel.local"        // p-we1dat-sql01
      ]
      destination_ports = ["1433"]           // SQL
    }
    rule {
      name                  = "AllowSqlFromApp01ToSqlservers"
      protocols             = ["TCP"]
      source_addresses      = ["10.100.11.196"]   // p-usradm-app01
      destination_addresses = ["10.100.10.228"]   // p-we1dat-sql01
      destination_ports     = ["1433"]            // SQL
    }
    rule {
      name              = "AllowAmqpFromApp01ToRabbitmqazure"
      protocols         = ["TCP"]
      source_addresses  = ["10.100.11.196"]    // p-nwsadm-app01
      destination_fqdns = [
        "p-rabtmq-rmq01.montel.local"         // Rabbit MQ Azure
      ]
      destination_ports = ["5672"]            // SQL
    }
    rule {
      name                  = "AllowOnpremelasticsearchFromApp01ToOnpremelasticsearch"
      protocols             = ["TCP"]
      source_addresses      = ["10.100.11.196"]    // p-nwsadm-app01
      destination_addresses = [
        "10.10.110.101",                      // On-prem Elastic search Node
        "10.10.110.104",                      // On-prem Elastic search Node
        "10.10.110.105"                       // On-prem Elastic search Node
      ]
      destination_ports = ["9200"] // Elastic search
    }
    rule {
      name                  = "AllowApp01FromWafToApp01"
      protocols             = ["TCP"]
      source_addresses      = ["10.100.4.0/24"]   // p-we1waf-network
      destination_addresses = ["10.100.11.196"]   // p-nwsadm-app01
      destination_ports     = ["1011"]            // Waf 
    }
  }

   ####################################################
    # Application Workload Rules
   ####################################################
  application_rule_collection {
    name     = "Application-Allow-p-nwsadm"
    priority = 400
    action   = "Allow"
    rule {
      name = "AllowHttpsFromApp01ToApihub"
      protocols {
        type = "Https"
        port = 443 // SSL - encrypted web traffic
      }
      source_addresses  = ["10.100.11.196"]   // p-nwsadm-app01
      destination_fqdns = ["api.hubapi.com"]   // Api hub workload
    }
  #  rule {
  #   name = "AllowHttpsFromApp01ToAppenergyquantified"
  #    protocols {
  #     type = "Https"
  #      port = 443 // SSL - encrypted web traffic
  #   }
  #    source_addresses  = ["10.100.11.196"]              // p-nwsadm-app01
  #  destination_fqdns = ["app.energyquantified.com"]   // App Energy quantified workload
  #  }
    rule {
       name = "AllowHttpsFromApp01ToMsauth"
       protocols {
         type = "Https"
         port = 443 // SSL - encrypted web traffic
       }
       source_addresses  = ["10.100.11.196"]     // p-nwsadm-app01            
       destination_fqdns = ["login.windows.net", // Microsoft 
         "secure.aadcdn.microsoftonline-p.com",  // Microsoft 
         "enterpriseregistration.windows.net",   // Microsoft 
         "management.azure.com",                 // Microsoft 
         "policykeyservice.dc.ad.msft.net",      // Microsoft 
         "ctldl.windowsupdate.com",              // Microsoft 
         "*.microsoftonline.com",                // Microsoft 
         "*.microsoftonline-p.com",              // Microsoft 
         "*.msauth.net",                         // Microsoft 
         "*.msauthimages.net",                   // Microsoft 
         "*.msecnd.net",                         // Microsoft 
         "*.msftauth.net",                       // Microsoft 
         "*.msftauthimages.net",                 // Microsoft 
         "*.phonefactor.net",                    // Microsoft 
         "*.msappproxy.net",                     // Microsoft 
         "*.servicebus.windows.net"              // Microsoft 
         ] 
     }
  }
}