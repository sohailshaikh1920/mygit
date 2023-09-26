##################################################
#  Key vault Policies
##################################################

variable "keyvault_access_policies" {
  type = map(object({
    key_permissions         = list(string)
    secret_permissions      = list(string)
    certificate_permissions = list(string)
  }))
  description = "Access policies object.Specify Key as Object_ID"
}