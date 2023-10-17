################################################
#  Azure Bastion
################################################

variable "Bastion-sku" {
  type        = string
  description = "The SKU of the Bastion Host."
}

variable "Bastion-copy_paste_enabled" {
  type        = bool
  description = "Is Copy/Paste feature enabled for the Bastion Host."
}

variable "Bastion-file_copy_enabled" {
  type        = bool
  description = "Is File Copy feature enabled for the Bastion Host."
}

variable "Bastion-ip_connect_enabled" {
  type        = bool
  description = "Is IP Connect feature enabled for the Bastion Host."
}

variable "Bastion-shareable_link_enabled" {
  type        = bool
  description = "Is Shareable Link feature enabled for the Bastion Host."
}

variable "Bastion-tunneling_enabled" {
  type        = bool
  description = "Is IP Connect feature enabled for the Bastion Host."
}
