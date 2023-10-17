##################################################
#  Azure Firewall
##################################################

variable "AzureFirewall-sku_name" {
  type        = string
  description = "SKU name of the Firewall."
}

variable "AzureFirewall-sku_tier" {
  type        = string
  description = "SKU tier of the Firewall."
}

variable "AzureFirewall-zones" {
  type        = list(string)
  default     = ["1", "2", "3"]
  description = "Specifies a list of Availability Zones in which this Azure Firewall (and associated resources) should be located."
}
