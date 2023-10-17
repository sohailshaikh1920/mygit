################################################
#  Virtual Machine Scale Set 1
################################################

variable "vmss1-name" {
  type        = string
  description = "The role of the Virtual Machine Scale Set"
}

variable "vmss1-admin_username" {
  type        = string
  description = "The name of the admin user account of the Virtual Machine Scale Set compute instances"
}

variable "vmss1-instances" {
  type        = string
  description = "The default number of instances in the Virtual Machine Scale Set"
}

variable "vmss1-sku" {
  type        = string
  description = "The virtual machine series/size of the Virtual Machine Scale Set compute instances"
}