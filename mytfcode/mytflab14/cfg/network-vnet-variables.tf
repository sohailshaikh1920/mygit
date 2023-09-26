##################################################
#  Workload virtual network
##################################################

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
