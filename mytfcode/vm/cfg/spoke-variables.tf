variable "subscriptionid" {
  type = string
}

variable "subscriptionname" {
  type = string
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "subscriptionid_mgt" {
  type = string
}

variable "subscriptionid_gov" {
  type = string
}

variable "subscriptionid_we1net" {
  type = string
}

variable "managementgroup" {
  type        = string
  description = "Management Group under which current subscription needs to be added."
}

variable "budget" {
  type = number
}

#Virtual Network Specifics
variable "vnetaddress" {
  type    = string
  default = "Vnet Address Space workload network"
}

variable "dnsservers" {
  type        = list(string)
  description = "DNS server list"
}



#Firewall Specifics
variable "firewall_name" {
  type        = string
  description = "Regional FW Name"
}

variable "firewall_resource_group" {
  type        = string
  description = "Regional FW Resource Group"
}



#Keyvault Access Policies
variable "keyvault_access_policies" {
  type = map(object({
    key_permissions         = list(string)
    secret_permissions      = list(string)
    certificate_permissions = list(string)
  }))

  description = "Access policies object.Specify Key as Object_ID"
}



#Hub Vnet specific variables.
variable "hub_virtual_network_name" {
  type        = string
  description = "Hub Virtual Network"
}

variable "hub_virtual_network_name_resource_group" {
  type        = string
  description = "Hub Virtual Network Resource Group"
}


#Backup Vault specific variables.
variable "azurerm_data_protection_backup_vault_redundancy" {
  type        = string
  description = "Specifies the backup storage redundancy. Possible values are GeoRedundant and LocallyRedundant. Changing this forces a new Backup Vault to be created."
  default     = "LocallyRedundant"
}

variable "azurerm_data_protection_backup_policy_blob_storage_retention_duration" {
  type        = string
  description = "Duration of deletion after given timespan. It should follow ISO 8601 duration format. Changing this forces a new Backup Policy Blob Storage to be created."
  default     = "P30D"
}



#Storage Account specific variables.
variable "account_kind" {
  type        = string
  description = "Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Changing this forces a new resource to be created. Defaults to StorageV2"
  default     = "StorageV2"
}

variable "account_tier" {
  type        = string
  description = "Defines the Tier to use for this storage account. Valid options are Standard and Premium"
  default     = "Standard"
}

variable "account_replication_type" {
  type        = string
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS"
  default     = "GRS"
}

variable "blob_soft_delete_retention" {
  type        = number
  description = "Specify number of days to retain the blobs"
  default     = 7
}


#Central Log Analytics specific variables.
variable "central_log_analytics_workspace_name" {
  type        = string
  description = "Name of Log Analytics Workspace"
}


#Governance Storage Account specific variables.
variable "governance_storage_account_name" {
  type        = string
  description = "Name of Log Analytics Workspace"
}

#Security and Alerts Email
variable "security_incident_email" {
  type        = string
  description = "Security Incident Email"
}

variable "budget_alert_email" {
  type        = string
  description = "Budget Alert Email"
}


variable "budget_alert_email_locale" {
  type        = string
  description = "Budget Alert Email Locale"
}
