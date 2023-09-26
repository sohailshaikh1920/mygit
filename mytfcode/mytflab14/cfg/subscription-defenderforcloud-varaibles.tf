##################################################
#  Microsoft Defender for Cloud
##################################################

# Plans

variable "plan_cspm" {
  type        = string
  description = "Enable or disable the Defender Cloud Security Posture Management (CSPM) plan"
  default     = "Standard" # "Free"/off or "Standard"/on
}

variable "plan_server" {
  type        = string
  description = "Enable or disable the Servers plan"
  default     = "Standard" # "Free"/off or "Standard"/on
}

variable "plan_server_subplan" {
  type        = string
  description = "Enable or disable the Servers plan"
  default     = "P1" # "P1" (Azure default) or "P2"
}

variable "plan_appservice" {
  type        = string
  description = "Enable or disable the App Services plan"
  default     = "Standard" # "Free"/off or "Standard"/on
}

variable "plan_database" {
  type        = string
  description = "Enable or disable the Azure SQL plan"
  default     = "Standard" # "Free"/off or "Standard"/on
}

variable "plan_databaseservers" {
  type        = string
  description = "Enable or disable the SQL Server in Servers plan"
  default     = "Standard" # "Free"/off or "Standard"/on
}

variable "plan_databaseopensource" {
  type        = string
  description = "Enable or disable the open source PaaS databases plan"
  default     = "Standard" # "Free"/off or "Standard"/on
}

variable "plan_cosmosdb" {
  type        = string
  description = "Enable or disable the Cosmos DB plan"
  default     = "Standard" # "Free"/off or "Standard"/on
}

variable "plan_storage" {
  type        = string
  description = "Enable or disable the Storage Accounts plan"
  default     = "Standard" # "Free"/off or "Standard"/on
}

variable "plan_storage_subplan" {
  type        = string
  description = "Enable or disable the Storage Accounts plan"
  default     = "PerTransaction" # "PerTransaction" (Azure default) or "PerStorageAccount" (only when >4.5 million transactions/month)
}

variable "plan_containers" {
  type        = string
  description = "Enable or disable the containers (and related features) plan"
  default     = "Standard" # "Free"/off or "Standard"/on
}

variable "plan_keyvault" {
  type        = string
  description = "Enable or disable the Key Vault plan"
  default     = "Standard" # "Free"/off or "Standard"/on
}

variable "plan_arm" {
  type        = string
  description = "Enable or disable the Azure Resource Manager (ARM) plan"
  default     = "Standard" # "Free"/off or "Standard"/on
}

variable "plan_dns" {
  type        = string
  description = "Enable or disable the DNS plan"
  default     = "Standard" # "Free"/off or "Standard"/on
}

# Integrations

variable "integration_mcas" {
  type        = string
  description = "Enable or disable Microsoft Cloud App Security (CAS) integration"
  default     = false # true (Azure default) or false
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
