##################################################
#  Workload virtual network
##################################################

firewall_rules_collection_group_priority = "12800"
vnetaddressPrefixes = [
  "10.100.0.0/22" // Frontend/NAT subnet
]
// dnsservers                    = ["10.100.1.4"]

# GatewaySubnet

GatewaySubnetName             = "GatewaySubnet"
GatewaySubnetPrefixes         = ["10.100.0.0/24"]
GatewaySubnetServiceEndpoints = []

# AzureFirewallSubnet

AzureFirewallSubnetName       = "AzureFirewallSubnet"
AzureFirewallSubnetPrefixes   = ["10.100.1.0/24"]
AzureFirewallSubnetServiceEndpoints = [
  "Microsoft.AzureActiveDirectory",
  "Microsoft.AzureCosmosDB",
  "Microsoft.CognitiveServices",
  "Microsoft.ContainerRegistry",
  "Microsoft.EventHub",
  "Microsoft.KeyVault",
  "Microsoft.ServiceBus",
  "Microsoft.Sql",
  "Microsoft.Storage",
  "Microsoft.Web"
]

# AzureBastionSubnet

AzureBastionSubnetName             = "AzureBastionSubnet"
AzureBastionSubnetPrefixes         = ["10.100.3.128/26"]
AzureBastionSubnetServiceEndpoints = []
