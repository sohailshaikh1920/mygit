################################################
#  Azure Firewall Policy
################################################

AzureFirewall-Policy-threat_intelligence_mode = "Deny"
AzureFirewall-Policy-dns-proxy_enabled        = true
AzureFirewall-Policy-dns-servers = [
  "10.100.8.4",
  "10.100.8.5"
]
AzureFirewall-Policy-insights-enabled           = true
AzureFirewall-Policy-insights-retention_in_days = 30
AzureFirewall-Policy-intrusion_detection-mode   = "Deny"
