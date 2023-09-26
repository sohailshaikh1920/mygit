##################################################
#  Plan 1
##################################################

variable "plan1-os_type" {
  type        = string
  description = "The OS of the App Service Plan"
}

variable "plan1-sku_name" {
  type        = string
  description = "The SKU/size of the App Service Plan"
}