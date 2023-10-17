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

variable "subscriptionid_pnet" {
  type        = string
  description = "Subscription ID of the p-net subscription"
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
#  Shared resources
##################################################

variable "shared_networking_key_vault_name" {
  type        = string
  description = "Name of the shared networking Key Vault in p-net"
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
