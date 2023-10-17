################################################
#  Virtual Machine Scale Set 2
################################################

variable "vmss2-name" {
  type        = string
  description = "The role of the Virtual Machine Scale Set"
}

variable "vmss2-admin_username" {
  type        = string
  description = "The name of the admin user account of the Virtual Machine Scale Set compute instances"
}

variable "vmss2-instances" {
  type        = string
  description = "The default number of instances in the Virtual Machine Scale Set"
}

variable "vmss2-sku" {
  type        = string
  description = "The virtual machine series/size of the Virtual Machine Scale Set compute instances"
}