################################################
#  Application Gateway Public IP
################################################

AppGateway2-publicIp-ddos_protection_mode = "VirtualNetworkInherited"

AppGateway2-sku-capacity = 5
AppGateway2-enable_http2 = true

AppGateway2-waf_configuration-enabled                  = true
AppGateway2-waf_configuration-firewall_mode            = "Prevention"
AppGateway2-waf_configuration-rule_set_type            = "OWASP"
AppGateway2-waf_configuration-rule_set_version         = "3.2"
AppGateway2-waf_configuration-file_upload_limit_mb     = 100
AppGateway2-waf_configuration-request_body_check       = true
AppGateway2-waf_configuration-max_request_body_size_kb = 128
