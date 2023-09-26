################################################
#  Application Gateway 1 Public IP
################################################

AppGateway1-publicIp-ddos_protection_mode = "VirtualNetworkInherited"

AppGateway1-sku-capacity = 5
AppGateway1-enable_http2 = true

AppGateway1-waf_configuration-enabled                  = true
AppGateway1-waf_configuration-firewall_mode            = "Prevention"
AppGateway1-waf_configuration-rule_set_type            = "OWASP"
AppGateway1-waf_configuration-rule_set_version         = "3.2"
AppGateway1-waf_configuration-file_upload_limit_mb     = 100
AppGateway1-waf_configuration-request_body_check       = true
AppGateway1-waf_configuration-max_request_body_size_kb = 128
