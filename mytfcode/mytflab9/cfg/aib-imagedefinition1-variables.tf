##################################################
#  Image Definition 1
##################################################


variable "aib-imagedefinition1-definition-name" {
  type        = string
  description = "The name of the image definition"
}

variable "aib-imagedefinition1-definition-ostype" {
  type        = string
  description = "The type of OS in the image definition: Windows or Liunux"
}

variable "aib-imagedefinition1-definition-hyper_v_generation" {
  type        = string
  description = "THe Hyper-V generation of the VM being built"
}

variable "aib-imagedefinition1-definition-offer" {
  type        = string
  description = "The offer of the image definition"
}

variable "aib-imagedefinition1-definition-sku" {
  type        = string
  description = "The name of the image definition"
}