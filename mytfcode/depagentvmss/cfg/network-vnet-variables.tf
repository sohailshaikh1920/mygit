##################################################
#  Workload virtual network
##################################################

variable "firewall_rules_collection_group_priority" {
  type        = number
  description = "Unique priority for the workload rules collection group in Azure Firewall"
}

variable "vnetaddress" {
  type    = string
  default = "Vnet Address Space workload network"
}

variable "dnsservers" {
  type        = list(string)
  description = "List of DNS servers for the workload VNet"
}

variable "subnet1Name" {
  type        = string
  description = "The name of Subnet 1"
}

variable "subnet1Prefixes" {
  type        = list(string)
  description = "IP Prefixes of Subnet 1"
}

variable "subnet1ServiceEndpoints" {
  type        = list(string)
  description = "Service Endpoints for Subnet 1"
}

variable "subnet2Name" {
  type        = string
  description = "The name of Subnet 1"
}

variable "subnet2Prefixes" {
  type        = list(string)
  description = "IP Prefixes of Subnet 1"
}

variable "subnet2ServiceEndpoints" {
  type        = list(string)
  description = "Service Endpoints for Subnet 1"
}



# Static IP Addresses
