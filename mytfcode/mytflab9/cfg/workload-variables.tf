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





variable "integration_wdatp" {
  type        = string
  description = "Enable or disable Microsoft Defender Advanced Threat Protection (ATP) integration"
  default     = false # true (Azure default) or false
}

variable "integration_sentinel" {
  type        = string
  description = "Enable or disable Microsoft Sentinel integration"
  default     = true # true or false (Azure default)
}

# Security Contacts
variable "security_incident_email" {
  type        = string
  description = "Security incident email address"
}

# Autoprovisioning

variable "auto-provisioning" {
  type        = string
  description = "Enable or disable autoprovisioning of the Log Analytics agent in Azure VMs"
  default     = "On" # "On" or "Off" (Azure default)
}

# Vulnerability Assessment

variable "va-auto-provisioning" {
  type        = string
  description = "Choose between Microsoft (P1 and P2) and Qualys (P2 only) vulnerability assessment solutions"
  default     = "mdeTvm" # "mdeTvm" (Microsoft) or "default" (Qualys)
}
