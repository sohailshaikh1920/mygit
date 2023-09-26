##################################################
#  Other required subscriptions
##################################################

variable "subscriptionid_gov" {
  type        = string
  description = "Subscription ID of the p-gov subscription"
}

variable "subscriptionid_mgt" {
  type        = string
  description = "Subscription ID of the p-mgt subscription"
}

variable "subscriptionid_pdns" {
  type        = string
  description = "Subscription ID of the p-dns subscription"
}

variable "subscriptionid_vdchub" {
  type        = string
  description = "Subscription ID of the VDC instance Hub subscription"
}


##################################################
#  Governance resources
##################################################

variable "central_log_analytics_workspace_name" {
  type        = string
  description = "Name of the central platform monitoring Log Analytics Workspace"
}

variable "app_insights_log_analytics_workspace_name" {
  type        = string
  description = "App Insights central application Log Analytics Workspace, used by Application Insights"
}

variable "governance_storage_account_name" {
  type        = string
  description = "Name of storage account for archiving subscription Activity Log exports"
}


##################################################
#  VDC instance network
##################################################

variable "vdc_address_space" {
  type        = string
  description = "The address space of the VDC instance"
}


##################################################
#  VDC instance hub virtual network
##################################################

variable "hub_virtual_network_name_resource_group" {
  type        = string
  description = "Name of the resource group containing the VDC instance hub virtual network"
}

variable "hub_virtual_network_name" {
  type        = string
  description = "Name of the VDC instance hub virtual network"
}

variable "firewall_resource_group" {
  type        = string
  description = "Name of the resource group containing the VDC instance hub firewall"
}

variable "firewall_name" {
  type        = string
  description = "Name of the VDC isntance hub firewall"
}

variable "firewall_ipaddress" {
  type        = string
  description = "IP Address of the VDC isntance hub firewall"
}


##################################################
#  Workload management group
##################################################

variable "managementgroup" {
  type        = string
  description = "Management Group under which current subscription needs to be added"
}


##################################################
#  Workload subscription
##################################################

variable "subscriptionid" {
  type        = string
  description = "ID of the subscription for the workload"
}

variable "subscriptionname" {
  type        = string
  description = "Name of the subscription for the workload"
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "Name of the Azure region that the workload will reside in"
}


##################################################
#  Workload variables
##################################################

variable "zones" {
  type        = list(string)
  default     = ["1", "2", "3"]
  description = "Specifies a list of Availability Zones in which this workload should be located."
}
