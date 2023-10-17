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