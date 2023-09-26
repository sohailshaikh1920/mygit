
###############################################################
# Create a spoke firewall collection rule on central firewall 
###############################################################
#
# Rule suffix can be found on these links
#
# "registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_application_rule_collection
#
# "registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_network_rule_collection
#

################################################
# Network Workload Rules
################################################

resource "azurerm_firewall_policy_rule_collection_group" "spoke" {
  provider           = azurerm.pwe1net
  name               = "p-we1depv2" //var.subscriptionname
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
    rule {
      name                  = "AllowSshFromAzureBastionsubnetToVNet" // Allow SSH from the hub Bastion to the workload virtual network
      protocols             = ["TCP"]
      source_addresses      = ["10.100.3.128/26"]    // Hub Bastion
      destination_addresses = ["${var.vnetaddress}"] // Workload Virtual Network
      destination_ports     = ["22"]                 // SSH
    }
    rule {
      name                  = "AllowRdpFromAzureBastionsubnetToVNet" // Allow RDP from the hub Bastion to the workload virtual network
      protocols             = ["TCP"]
      source_addresses      = ["10.100.3.128/26"]    // Hub Bastion
      destination_addresses = ["${var.vnetaddress}"] // Workload Virtual Network
      destination_ports     = ["3389"]               // SSH
    }
    ################################################
    # Start Workload Rules
    ################################################

    rule {
      name                  = "AllowHttpsFromAzureDevopssubnetToWe1" // Allow HTTPS from the self-hosted DevOps agent VMs to all of WE1
      protocols             = ["TCP"]
      source_addresses      = var.subnet1Prefixes // DevopsSubnet
      destination_addresses = ["10.100.0.0/16"]   // WE1
      destination_ports     = ["443"]             // SSH
    }

    ################################################
    # End Workload Rules
    ################################################

  }

  ################################################
  # Application Workload Rules
  ################################################

  application_rule_collection {
    name     = "Application-Allow-p-we1dep"
    priority = 500
    action   = "Allow"

    rule {
      name = "AllowHttpsFrom${var.subnet1Name}ToAzuredevops" // Allow HTTPS access to Azure DevOps
      protocols {
        type = "Https"
        port = 443 // SSL - encrypted web traffic
      }
      source_addresses = var.subnet1Prefixes // Subnet 1
      destination_fqdns = [
        "montel.pkgs.visualstudio.com",        //	Azure DevOps Packaging API for organizations using the montel.visualstudio.com domain
        "montel.visualstudio.com",             //	For organizations using the montel.visualstudio.com domain
        "montel.vsblob.visualstudio.com",      //	Azure DevOps Telemetry for organizations using the montel.visualstudio.com domain
        "montel.vsrm.visualstudio.com",        //	Release Management Services for organizations using the montel.visualstudio.com domain
        "montel.vssps.visualstudio.com",       //	Azure DevOps Platform Services for organizations using the montel.visualstudio.com domain
        "montel.vstmr.visualstudio.com",       //	Azure DevOps Test Management Services for organizations using the montel.visualstudio.com domain
        "*.blob.core.windows.net",             //	Azure Artifacts
        "*.dev.azure.com",                     //	For organizations using the dev.azure.com domain
        "*.vsassets.io",                       //	Azure Artifacts via CDN
        "*.vsblob.visualstudio.com",           //	Azure DevOps Telemetry for organizations using the dev.azure.com domain
        "*.vssps.visualstudio.com",            //	Azure DevOps Platform Services for organizations using the dev.azure.com domain
        "*.vstmr.visualstudio.com",            //	Azure DevOps Test Management Services for organizations using the dev.azure.com domain
        "app.vssps.visualstudio.com",          //	For organizations using the montel.visualstudio.com domain
        "dev.azure.com",                       //	For organizations using the dev.azure.com domain
        "login.microsoftonline.com",           //	Azure Active Directory sign in
        "management.core.windows.net",         //	Azure Management API's
        "vstsagentpackage.azureedge.net",      //	Agent package
        "vssps.dev.azure.com",                 // Vstsagent
        "download.visualstudio.microsoft.com", // Vstsagent
        "api.nuget.org",                       // Vstsagent
        "github.com",                          // Vstsagent   
        "vsrm.dev.azure.com",                  // Vstsagent 
        "management.azure.com",                // Vstsagent 
        "*.githubusercontent.com",             // Vstsagent 
        "github.githubassets.com",             // Vstsagent 
        "www.powershellgallery.com",           // Vstsagent
        "*.visualstudio.com"                   // Visual Studio to handle access to randomly named sources
      ]
    }

    rule {
      name = "AllowHttpsFrom${var.subnet1Name}ToUbuntu" // Allow HTTPS access to Ubuntu
      protocols {
        type = "Https"
        port = 443 // SSL - encrypted web traffic
      }
      source_addresses = var.subnet1Prefixes // Subnet 1
      destination_fqdns = [
        "motd.ubuntu.com", // Ubuntu
        "esm.ubuntu.com",  // Ubuntu
        "cdn.fwupd.org",   // Ubuntu software updates
        "*.snapcraft.io"   // Snap updates
      ]
    }

    rule {
      name = "AllowHttpFrom${var.subnet1Name}ToUbuntu" // Allow HTTP access to Ubuntu
      protocols {
        type = "Http"
        port = 80 // SSL - encrypted web traffic
      }
      source_addresses = var.subnet1Prefixes // Subnet 1
      destination_fqdns = [
        "azure.archive.ubuntu.com" // Ubuntu
      ]
    }

    rule {
      name = "AllowHttpFrom${var.subnet1Name}ToTerraform" // Allow HTTP access to Ubuntu
      protocols {
        type = "Https"
        port = 443 // SSL - encrypted web traffic
      }
      source_addresses = var.subnet1Prefixes // Subnet 1
      destination_fqdns = [
        "registry.terraform.io", // Terraform Registry
        "*.hashicorp.com"        // Hashicorp
      ]
    }

    rule {
      name = "AllowHttpsFrom${var.subnet1Name}ToAzure" // Allow HTTPS access to Azure URIs
      protocols {
        type = "Https"
        port = 443 // SSL - encrypted web traffic
      }
      source_addresses = var.subnet1Prefixes // Subnet 1
      destination_fqdns = [
        "*.azure.net" // Azure services including Key Vault
      ]
    }

  }
}


