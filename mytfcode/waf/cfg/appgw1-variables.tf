################################################
#  Application Gateway 1 Public IP
################################################

variable "AppGateway1-publicIp-ddos_protection_mode" {
  type        = string
  default     = "VirtualNetworkInherited"
  description = "The DDoS protection mode of the public IP."
}

variable "AppGateway1-sku-capacity" {
  type        = number
  description = "The Capacity of the SKU to use for this Application Gateway."
}

variable "AppGateway1-enable_http2" {
  type        = bool
  description = "Is HTTP2 enabled on the application gateway resource?"
}

variable "AppGateway1-waf_configuration-enabled" {
  type        = bool
  description = "Is the Web Application Firewall enabled?"
}

variable "AppGateway1-waf_configuration-firewall_mode" {
  type        = string
  description = "The Web Application Firewall Mode."
}

variable "AppGateway1-waf_configuration-rule_set_type" {
  type        = string
  default     = "OWASP"
  description = "The Type of the Rule Set used for this Web Application Firewall."
}

variable "AppGateway1-waf_configuration-rule_set_version" {
  type        = string
  description = "The Version of the Rule Set used for this Web Application Firewall."
}

variable "AppGateway1-waf_configuration-file_upload_limit_mb" {
  type        = number
  default     = 100
  description = "The File Upload Limit in MB."
}

variable "AppGateway1-waf_configuration-request_body_check" {
  type        = bool
  default     = true
  description = "Is Request Body Inspection enabled?"
}

variable "AppGateway1-waf_configuration-max_request_body_size_kb" {
  type        = number
  default     = 100
  description = "The Maximum Request Body Size in KB."
}
