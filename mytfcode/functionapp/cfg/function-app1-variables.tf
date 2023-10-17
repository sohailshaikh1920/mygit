##################################################
#  Plan 1 Function App 1
##################################################

variable "plan1-function1-name" {
  type        = string
  description = "Name of the function app being deployed"
}

variable "plan1-function1-client_certificate_mode" {
  type        = string
  description = "The mode of the Function App's client certificates requirement for incoming requests"
}

variable "plan1-function1-functions_extension_version" {
  type        = string
  description = "The runtime version associated with the Function App"
}

variable "plan1-function1-builtin_logging_enabled" {
  type        = bool
  description = "Should built in logging be enabled in the Function App"
}

variable "plan1-function1-https_only" {
  type        = bool
  description = "Can the Function App only be accessed via HTTPS?"
}


variable "plan1-function1-site_config" {
  description = "The site configuration of the Function App"
  type = object({
    ftps_state              = string
    scm_minimum_tls_version = string
    vnet_route_all_enabled  = bool
    always_on               = bool
    use_32_bit_worker       = bool
  })
}

variable "plan1-function1-application_stack" {
  description = "Configure application stack of the Function App"
  type = object({
    dotnet_version = string
  })
}

variable "plan1-function1-cors" {
  description = "CORS configuration of the app service"
  type = object({
    allowed_origins = list(string)
  })
}

variable "plan1-function1_sticky_settings" {
  description = "Names of settings that will not move with a slot swap"
  type = object({
    app_setting_names = list(string)
  })
}

variable "application_insights_connection_string" {
  type        = string
  description = "application_insights_connection_string"
}

variable "application_insights_key" {
  type        = string
  description = "application_insights_key"
}