################################################
#  Storage Account 1
################################################

variable "storage1_account_tier" {
  type        = string
  description = "The tier of the storage account"
}

variable "storage1_account_kind" {
  type        = string
  description = "The generation or version of the storage account"
}

variable "storage1_account_replication_type" {
  type        = string
  description = "The replication type of the storage account"
}

variable "storage1_enable_https_traffic_only" {
  type        = bool
  description = "Whether the storage account requires HTTPS or not"
}

/*

variable "storage1_container1_name" {
  type        = string
  description = "The name of the blob container"
}

variable "storage1_container2_name" {
  type        = string
  description = "The name of the blob container"
}

*/
