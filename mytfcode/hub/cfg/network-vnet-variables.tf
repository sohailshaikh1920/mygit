##################################################
#  Workload virtual network
##################################################

variable "firewall_rules_collection_group_priority" {
  type        = number
  description = "Unique priority for the workload rules collection group in Azure Firewall"
}

variable "vnetaddressPrefixes" {
  type    = list(string)
  description = "Vnet Address Space workload network"
}

/*
variable "dnsservers" {
  type        = list(string)
  description = "List of DNS servers for the workload VNet"
}
*/

variable "GatewaySubnetName" {
  type        = string
  description = "The name of Subnet 1"
}

variable "GatewaySubnetPrefixes" {
  type        = list(string)
  description = "IP Prefixes of Subnet 1"
}

variable "GatewaySubnetServiceEndpoints" {
  type        = list(string)
  description = "Service Endpoints for Subnet 1"
}

variable "AzureFirewallSubnetName" {
  type        = string
  description = "The name of Subnet 2"
}

variable "AzureFirewallSubnetPrefixes" {
  type        = list(string)
  description = "IP Prefixes of Subnet 2"
}

variable "AzureFirewallSubnetServiceEndpoints" {
  type        = list(string)
  description = "Service Endpoints for Subnet 2"
}

variable "AzureBastionSubnetName" {
  type        = string
  description = "The name of Subnet 3"
}

variable "AzureBastionSubnetPrefixes" {
  type        = list(string)
  description = "IP Prefixes of Subnet 3"
}

variable "AzureBastionSubnetServiceEndpoints" {
  type        = list(string)
  description = "Service Endpoints for Subnet 3"
}
