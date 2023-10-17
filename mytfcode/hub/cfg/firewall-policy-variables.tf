################################################
#  Azure Firewall Policy
################################################

variable "AzureFirewall-Policy-threat_intelligence_mode" {
  type        = string
  description = "The operation mode for Threat Intelligence."
}

variable "AzureFirewall-Policy-dns-proxy_enabled" {
  type        = bool
  description = "Whether to enable DNS proxy on Firewalls attached to this Firewall Policy?"
}

variable "AzureFirewall-Policy-dns-servers" {
  type        = list(string)
  description = "A list of custom DNS servers' IP addresses."
}

variable "AzureFirewall-Policy-insights-enabled" {
  type        = bool
  description = "Whether the insights functionality is enabled for this Firewall Policy."
}

variable "AzureFirewall-Policy-insights-retention_in_days" {
  type        = number
  description = "The log retention period in days."
}

variable "AzureFirewall-Policy-intrusion_detection-mode" {
  type        = string
  description = "In which mode you want to run intrusion detection."
}
