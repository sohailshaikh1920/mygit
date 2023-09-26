################################################
#  Application Gateway 1 Public IP
################################################

resource "azurerm_public_ip" "AppGateway1001" {
  name                = "${azurerm_resource_group.public.name}-waf01-pip"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.public.name

  domain_name_label = "p-we1waf-pub-waf01-pip-b6j6ecyqrbvxa"
  // domain_name_label = "${azurerm_resource_group.public.name}-waf01-pip-${random_string.random.result}"
  allocation_method    = "Static"
  sku                  = "Standard"
  zones                = var.zones
  ddos_protection_mode = var.AppGateway1-publicIp-ddos_protection_mode
}


################################################
#  Application Gateway 1 Managed Identity
################################################

resource "azurerm_user_assigned_identity" "AppGateway1" {
  name                = "${azurerm_resource_group.public.name}-waf01-id"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.public.name
}


################################################
#  Application Gateway
################################################

resource "azurerm_application_gateway" "AppGateway1" {
  name                = "${azurerm_resource_group.public.name}-waf01"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.public.name

  zones = var.zones

  sku {
    capacity = var.AppGateway1-sku-capacity
    name     = "WAF_v2"
    tier     = "WAF_v2"
  }

  enable_http2 = var.AppGateway1-enable_http2

  ################################################
  #  Default WAF Policy
  ################################################

  firewall_policy_id = azurerm_web_application_firewall_policy.wafpolicy-appgw1.id
  waf_configuration {
    enabled                  = var.AppGateway1-waf_configuration-enabled
    firewall_mode            = var.AppGateway1-waf_configuration-firewall_mode
    rule_set_type            = var.AppGateway1-waf_configuration-rule_set_type
    rule_set_version         = var.AppGateway1-waf_configuration-rule_set_version
    file_upload_limit_mb     = var.AppGateway1-waf_configuration-file_upload_limit_mb
    request_body_check       = var.AppGateway1-waf_configuration-request_body_check
    max_request_body_size_kb = var.AppGateway1-waf_configuration-max_request_body_size_kb
  }


  ################################################
  #  Frontends
  ################################################


  frontend_ip_configuration {
    name                 = "appGwPublicFrontendIp"
    public_ip_address_id = azurerm_public_ip.AppGateway1001.id
  }
  frontend_port {
    name = "appGatewayFrontendHttpsPort"
    port = 443
  }
  frontend_port {
    name = "appGatewayFrontendPort"
    port = 80
  }
  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = azurerm_subnet.subnet1.id
  }

  ################################################
  #  Certificates
  ################################################

  identity {
    identity_ids = [
      azurerm_user_assigned_identity.AppGateway1.id,
    ]
    type = "UserAssigned"
  }
  ssl_certificate {
    key_vault_secret_id = "https://p-net-kvmkc73wbq-kv.vault.azure.net/secrets/app-montelforeks-com"
    name                = "https-app-montelforeks-com"
  }
  ssl_certificate {
    key_vault_secret_id = "https://p-net-kvmkc73wbq-kv.vault.azure.net/secrets/star-montelnews-com"
    name                = "https-star-montelnews-com"
  }

  ################################################
  #  Workloads
  ################################################

  #  p-we1mo

  request_routing_rule {
    backend_address_pool_name  = "backendpool_p-we1mo_montelforeks-app"
    backend_http_settings_name = "setting_https-p-we1mo_app.montelforeks.com"
    http_listener_name         = "listener_https-p-we1mo_app.montelforeks.com"
    name                       = "rule_https-p-we1mo_app.montelforeks.com"
    priority                   = 190
    rule_type                  = "Basic"
  }
  request_routing_rule {
    backend_address_pool_name  = "backendpool_p-we1mo_montelonline-app"
    backend_http_settings_name = "setting_https-p-we1mo_app.montelnews.com"
    http_listener_name         = "listener_https-p-we1mo_app.montelnews.com"
    name                       = "rule_https-p-we1mo_app.montelnews.com"
    priority                   = 130
    rule_type                  = "Basic"
  }
  request_routing_rule {
    backend_address_pool_name  = "backendpool_p-we1mo_prod-montelonline-app"
    backend_http_settings_name = "setting_https-p-we1mo_prod-app.montelnews.com"
    http_listener_name         = "listener_https-p-we1mo_prod-app.montelnews.com"
    name                       = "rule_https-p-we1mo_prod-app.montelnews.com"
    priority                   = 70
    rule_type                  = "Basic"
  }
  request_routing_rule {
    backend_address_pool_name  = "backendpool_p-we1mo_prod_vm-montelonline-app"
    backend_http_settings_name = "setting_http-p-we1mo_prod_vm-app.montelnews.com"
    http_listener_name         = "listener_https-p-we1mo_prod_vm-app.montelnews.com"
    name                       = "rule_https-p-we1mo_prod_vm-app.montelnews.com"
    priority                   = 230
    rule_type                  = "Basic"
  }
  request_routing_rule {
    http_listener_name          = "listener_http-p-we1mo_app.montelforeks.com"
    name                        = "rule_http-p-we1mo_app.montelforeks.com"
    priority                    = 200
    redirect_configuration_name = "redirect_http-p-we1mo_app.montelforeks.com"
    rule_type                   = "Basic"
  }
  request_routing_rule {
    http_listener_name          = "listener_http-p-we1mo_app.montelnews.com"
    name                        = "rule_http-p-we1mo_app.montelnews.com"
    priority                    = 140
    redirect_configuration_name = "redirect_http-p-we1mo_app.montelnews.com"
    rule_type                   = "Basic"
  }
  request_routing_rule {
    http_listener_name          = "listener_http-p-we1mo_prod-app.montelnews.com"
    name                        = "rule_http-p-we1mo_prod-app.montelnews.com"
    priority                    = 80
    redirect_configuration_name = "redirect_http-p-we1mo_prod-app.montelnews.com"
    rule_type                   = "Basic"
  }
  request_routing_rule {
    http_listener_name          = "listener_http-p-we1mo_prod_vm-app.montelnews.com"
    name                        = "rule_http-p-we1mo_prod_vm-app.montelnews.com"
    priority                    = 240
    redirect_configuration_name = "redirect_http-p-we1mo_prod_vm-app.montelnews.com"
    rule_type                   = "Basic"
  }


  backend_address_pool {
    fqdns = ["p-we1mo-montelonline-app.p-we1mo.appserviceenvironment.net"]
    name  = "backendpool_p-we1mo_prod-montelonline-app"
  }
  backend_address_pool {
    ip_addresses = ["10.100.13.68"]
    name         = "backendpool_p-we1mo_montelforeks-app"
  }
  backend_address_pool {
    ip_addresses = ["10.100.13.68"]
    name         = "backendpool_p-we1mo_montelonline-app"
  }
  backend_address_pool {
    ip_addresses = ["10.100.13.101"]
    name         = "backendpool_p-we1mo_prod_vm-montelonline-app"
  }


  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    name                                = "setting_https-p-we1mo_prod-app.montelnews.com"
    pick_host_name_from_backend_address = true
    port                                = 443
    probe_name                          = "probe_https-p-we1mo_prod-app.montelnews.com"
    protocol                            = "Https"
    request_timeout                     = 60
  }
  backend_http_settings {
    affinity_cookie_name  = "ApplicationGatewayAffinity"
    cookie_based_affinity = "Disabled"
    host_name             = "app.montelforeks.com"
    name                  = "setting_https-p-we1mo_app.montelforeks.com"
    port                  = 443
    probe_name            = "probe_https-p-we1mo_app.montelforeks.com"
    protocol              = "Https"
    request_timeout       = 60
  }
  backend_http_settings {
    affinity_cookie_name  = "ApplicationGatewayAffinity"
    cookie_based_affinity = "Disabled"
    host_name             = "app.montelnews.com"
    name                  = "setting_https-p-we1mo_app.montelnews.com"
    port                  = 443
    probe_name            = "probe_https-p-we1mo_app.montelnews.com"
    protocol              = "Https"
    request_timeout       = 60
  }
  backend_http_settings {
    affinity_cookie_name  = "ApplicationGatewayAffinity"
    cookie_based_affinity = "Disabled"
    host_name             = "prod-app-vm.montelnews.com"
    name                  = "setting_http-p-we1mo_prod_vm-app.montelnews.com"
    port                  = 80
    probe_name            = "probe_http-p-we1mo_prod_vm-app.montelnews.com"
    protocol              = "Http"
    request_timeout       = 60
  }


  probe {
    host                = "p-we1mo-montelonline-app.p-we1mo.appserviceenvironment.net"
    interval            = 30
    name                = "probe_https-p-we1mo_prod-app.montelnews.com"
    path                = "/"
    protocol            = "Https"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }
  probe {
    host                = "app.montelforeks.com"
    interval            = 30
    name                = "probe_https-p-we1mo_app.montelforeks.com"
    path                = "/"
    protocol            = "Https"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }
  probe {
    host                = "app.montelnews.com"
    interval            = 30
    name                = "probe_https-p-we1mo_app.montelnews.com"
    path                = "/"
    protocol            = "Https"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }
  probe {
    host                = "prod-app-vm.montelnews.com"
    interval            = 30
    name                = "probe_http-p-we1mo_prod_vm-app.montelnews.com"
    path                = "/"
    protocol            = "Http"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }


  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1mo.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "app.montelforeks.com"
    name                           = "listener_https-p-we1mo_app.montelforeks.com"
    protocol                       = "Https"
    require_sni                    = true
    ssl_certificate_name           = "https-app-montelforeks-com"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1mo.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "app.montelnews.com"
    name                           = "listener_https-p-we1mo_app.montelnews.com"
    protocol                       = "Https"
    require_sni                    = true
    ssl_certificate_name           = "https-star-montelnews-com"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1mo.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "prod-app-vm.montelnews.com"
    name                           = "listener_https-p-we1mo_prod_vm-app.montelnews.com"
    protocol                       = "Https"
    ssl_certificate_name           = "https-star-montelnews-com"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1mo.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "prod-app.montelnews.com"
    name                           = "listener_https-p-we1mo_prod-app.montelnews.com"
    protocol                       = "Https"
    require_sni                    = true
    ssl_certificate_name           = "https-star-montelnews-com"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1mo.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendPort"
    host_name                      = "app.montelforeks.com"
    name                           = "listener_http-p-we1mo_app.montelforeks.com"
    protocol                       = "Http"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1mo.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendPort"
    host_name                      = "app.montelnews.com"
    name                           = "listener_http-p-we1mo_app.montelnews.com"
    protocol                       = "Http"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1mo.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendPort"
    host_name                      = "prod-app-vm.montelnews.com"
    name                           = "listener_http-p-we1mo_prod_vm-app.montelnews.com"
    protocol                       = "Http"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1mo.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendPort"
    host_name                      = "prod-app.montelnews.com"
    name                           = "listener_http-p-we1mo_prod-app.montelnews.com"
    protocol                       = "Http"
  }


  redirect_configuration {
    include_path         = true
    include_query_string = true
    name                 = "redirect_http-p-we1mo_app.montelforeks.com"
    redirect_type        = "Permanent"
    target_listener_name = "listener_https-p-we1mo_app.montelforeks.com"
  }
  redirect_configuration {
    include_path         = true
    include_query_string = true
    name                 = "redirect_http-p-we1mo_app.montelnews.com"
    redirect_type        = "Permanent"
    target_listener_name = "listener_https-p-we1mo_app.montelnews.com"
  }
  redirect_configuration {
    include_path         = true
    include_query_string = true
    name                 = "redirect_http-p-we1mo_prod-app.montelnews.com"
    redirect_type        = "Permanent"
    target_listener_name = "listener_https-p-we1mo_prod-app.montelnews.com"
  }
  redirect_configuration {
    include_path         = true
    include_query_string = true
    name                 = "redirect_http-p-we1mo_prod_vm-app.montelnews.com"
    redirect_type        = "Permanent"
    target_listener_name = "listener_https-p-we1mo_prod_vm-app.montelnews.com"
  }


  # p-we1mwa

  request_routing_rule {
    backend_address_pool_name  = "backendpool_p-we1mwa_montelwebapi-app"
    backend_http_settings_name = "setting_http-p-we1mwa_api.montelnews.com"
    http_listener_name         = "listener_https-p-we1mwa_api.montelnews.com"
    name                       = "rule_https-p-we1mwa_api.montelnews.com"
    priority                   = 150
    rule_type                  = "Basic"
  }
  request_routing_rule {
    backend_address_pool_name  = "backendpool_p-we1mwa_prod-montelwebapi-app"
    backend_http_settings_name = "setting_https-p-we1mwa_prod-api.montelnews.com"
    http_listener_name         = "listener_https-p-we1mwa_prod-api.montelnews.com"
    name                       = "rule_https-p-we1mwa_prod-api.montelnews.com"
    priority                   = 90
    rule_type                  = "Basic"
  }
  request_routing_rule {
    backend_address_pool_name  = "backendpool_p-we1mwa_prod_vm-montelwebapi-app"
    backend_http_settings_name = "setting_http-p-we1mwa_prod_vm-api.montelnews.com"
    http_listener_name         = "listener_https-p-we1mwa_prod_vm-api.montelnews.com"
    name                       = "rule_https-p-we1mwa_prod_vm-api.montelnews.com"
    priority                   = 210
    rule_type                  = "Basic"
  }
  request_routing_rule {
    http_listener_name          = "listener_http-p-we1mwa_api.montelnews.com"
    name                        = "rule_http-p-we1mwa_api.montelnews.com"
    priority                    = 160
    redirect_configuration_name = "redirect_http-p-we1mwa_api.montelnews.com"
    rule_type                   = "Basic"
  }
  request_routing_rule {
    http_listener_name          = "listener_http-p-we1mwa_prod-api.montelnews.com"
    name                        = "rule_http-p-we1mwa_prod-api.montelnews.com"
    priority                    = 100
    redirect_configuration_name = "redirect_http-p-we1mwa_prod-api.montelnews.com"
    rule_type                   = "Basic"
  }
  request_routing_rule {
    http_listener_name          = "listener_http-p-we1mwa_prod_vm-api.montelnews.com"
    name                        = "rule_http-p-we1mwa_prod_vm-api.montelnews.com"
    priority                    = 220
    redirect_configuration_name = "redirect_http-p-we1mwa_prod_vm-api.montelnews.com"
    rule_type                   = "Basic"
  }


  backend_address_pool {
    fqdns = ["p-we1mwa-montelwebapi-app.p-we1mwa.appserviceenvironment.net"]
    name  = "backendpool_p-we1mwa_prod-montelwebapi-app"
  }
  backend_address_pool {
    ip_addresses = ["10.100.13.165"]
    name         = "backendpool_p-we1mwa_montelwebapi-app"
  }
  backend_address_pool {
    ip_addresses = ["10.100.13.165"]
    name         = "backendpool_p-we1mwa_prod_vm-montelwebapi-app"
  }
  backend_address_pool {
    fqdns = ["p-we1mwa-montelwebapi-app.p-we1mwa.appserviceenvironment.net"]
    name  = "backendpool_p-we1mwa_prod-montelwebapi-app"
  }


  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    name                                = "setting_http-p-we1mwa_api.montelnews.com"
    pick_host_name_from_backend_address = true
    port                                = 80
    probe_name                          = "probe_http-p-we1mwa_api.montelnews.com"
    protocol                            = "Http"
    request_timeout                     = 60
  }
  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    name                                = "setting_http-p-we1mwa_prod_vm-api.montelnews.com"
    pick_host_name_from_backend_address = true
    port                                = 80
    probe_name                          = "probe_http-p-we1mwa_prod_vm-api.montelnews.com"
    protocol                            = "Http"
    request_timeout                     = 60
  }
  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    name                                = "setting_https-p-we1mwa_prod-api.montelnews.com"
    pick_host_name_from_backend_address = true
    port                                = 443
    probe_name                          = "probe_https-p-we1mwa_prod-api.montelnews.com"
    protocol                            = "Https"
    request_timeout                     = 60
  }


  probe {
    host                = "10.100.13.165"
    interval            = 30
    name                = "probe_http-p-we1mwa_api.montelnews.com"
    path                = "/"
    protocol            = "Http"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }
  probe {
    host                = "10.100.13.165"
    interval            = 30
    name                = "probe_http-p-we1mwa_prod_vm-api.montelnews.com"
    path                = "/"
    protocol            = "Http"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }
  probe {
    host                = "p-we1mwa-montelwebapi-app.p-we1mwa.appserviceenvironment.net"
    interval            = 30
    name                = "probe_https-p-we1mwa_prod-api.montelnews.com"
    path                = "/"
    protocol            = "Https"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }


  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1mo.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "api.montelnews.com"
    name                           = "listener_https-p-we1mwa_api.montelnews.com"
    protocol                       = "Https"
    ssl_certificate_name           = "https-star-montelnews-com"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1mo.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "prod-api-vm.montelnews.com"
    name                           = "listener_https-p-we1mwa_prod_vm-api.montelnews.com"
    protocol                       = "Https"
    ssl_certificate_name           = "https-star-montelnews-com"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1mo.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "prod-api.montelnews.com"
    name                           = "listener_https-p-we1mwa_prod-api.montelnews.com"
    protocol                       = "Https"
    ssl_certificate_name           = "https-star-montelnews-com"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1mo.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendPort"
    host_name                      = "api.montelnews.com"
    name                           = "listener_http-p-we1mwa_api.montelnews.com"
    protocol                       = "Http"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1mo.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendPort"
    host_name                      = "prod-api-vm.montelnews.com"
    name                           = "listener_http-p-we1mwa_prod_vm-api.montelnews.com"
    protocol                       = "Http"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1mo.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendPort"
    host_name                      = "prod-api.montelnews.com"
    name                           = "listener_http-p-we1mwa_prod-api.montelnews.com"
    protocol                       = "Http"
  }


  redirect_configuration {
    include_path         = true
    include_query_string = true
    name                 = "redirect_http-p-we1mwa_api.montelnews.com"
    redirect_type        = "Permanent"
    target_listener_name = "listener_https-p-we1mwa_api.montelnews.com"
  }
  redirect_configuration {
    include_path         = true
    include_query_string = true
    name                 = "redirect_http-p-we1mwa_prod-api.montelnews.com"
    redirect_type        = "Permanent"
    target_listener_name = "listener_https-p-we1mwa_prod-api.montelnews.com"
  }
  redirect_configuration {
    include_path         = true
    include_query_string = true
    name                 = "redirect_http-p-we1mwa_prod_vm-api.montelnews.com"
    redirect_type        = "Permanent"
    target_listener_name = "listener_https-p-we1mwa_prod_vm-api.montelnews.com"
  }


  # p-we1xlf

  request_routing_rule {
    backend_address_pool_name  = "backendpool_p-we1xlf_montelxlf-app"
    backend_http_settings_name = "setting_https-p-we1xlf_xlf.montelnews.com"
    http_listener_name         = "listener_https-p-we1xlf_xlf.montelnews.com"
    name                       = "rule_https-p-we1xlf_xlf.montelnews.com"
    priority                   = 170
    rule_type                  = "Basic"
  }
  request_routing_rule {
    backend_address_pool_name  = "backendpool_p-we1xlf_prod-montelxlf-app"
    backend_http_settings_name = "setting_https-p-we1xlf_prod-xlf.montelnews.com"
    http_listener_name         = "listener_https-p-we1xlf_prod-xlf.montelnews.com"
    name                       = "rule_https-p-we1xlf_prod-xlf.montelnews.com"
    priority                   = 110
    rule_type                  = "Basic"
  }
  request_routing_rule {
    backend_address_pool_name  = "backendpool_p-we1xlf_prod_vm-montelxlf-app"
    backend_http_settings_name = "setting_http-p-we1xlf_prod_vm-xlf.montelnews.com"
    http_listener_name         = "listener_https-p-we1xlf_prod_vm-xlf.montelnews.com"
    name                       = "rule_https-p-we1xlf_prod_vm-xlf.montelnews.com"
    priority                   = 250
    rule_type                  = "Basic"
  }
  request_routing_rule {
    http_listener_name          = "listener_http-p-we1xlf_prod-xlf.montelnews.com"
    name                        = "rule_http-p-we1xlf_prod-xlf.montelnews.com"
    priority                    = 120
    redirect_configuration_name = "redirect_http-p-we1xlf_prod-xlf.montelnews.com"
    rule_type                   = "Basic"
  }
  request_routing_rule {
    http_listener_name          = "listener_http-p-we1xlf_prod_vm-xlf.montelnews.com"
    name                        = "rule_http-p-we1xlf_prod_vm-xlf.montelnews.com"
    priority                    = 260
    redirect_configuration_name = "redirect_http-p-we1xlf_prod_vm-xlf.montelnews.com"
    rule_type                   = "Basic"
  }
  request_routing_rule {
    http_listener_name          = "listener_http-p-we1xlf_xlf.montelnews.com"
    name                        = "rule_http-p-we1xlf_xlf.montelnews.com"
    priority                    = 180
    redirect_configuration_name = "redirect_http-p-we1xlf_xlf.montelnews.com"
    rule_type                   = "Basic"
  }


  backend_address_pool {
    fqdns = ["p-we1xlf-montelxlf-app.p-we1xlf.appserviceenvironment.net"]
    name  = "backendpool_p-we1xlf_montelxlf-app"
  }
  backend_address_pool {
    fqdns = ["p-we1xlf-montelxlf-app.p-we1xlf.appserviceenvironment.net"]
    name  = "backendpool_p-we1xlf_prod-montelxlf-app"
  }
  backend_address_pool {
    ip_addresses = ["10.100.13.229"]
    name         = "backendpool_p-we1xlf_prod_vm-montelxlf-app"
  }


  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    name                                = "setting_http-p-we1xlf_prod_vm-xlf.montelnews.com"
    pick_host_name_from_backend_address = true
    port                                = 80
    probe_name                          = "probe_http-p-we1xlf_prod_vm-xlf.montelnews.com"
    protocol                            = "Http"
    request_timeout                     = 60
  }
  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    name                                = "setting_https-p-we1xlf_prod-xlf.montelnews.com"
    pick_host_name_from_backend_address = true
    port                                = 443
    probe_name                          = "probe_https-p-we1xlf_prod-xlf.montelnews.com"
    protocol                            = "Https"
    request_timeout                     = 60
  }
  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    name                                = "setting_https-p-we1xlf_xlf.montelnews.com"
    pick_host_name_from_backend_address = true
    port                                = 443
    probe_name                          = "probe_https-p-we1xlf_xlf.montelnews.com"
    protocol                            = "Https"
    request_timeout                     = 60
  }


  probe {
    host                = "10.100.13.229"
    interval            = 30
    name                = "probe_http-p-we1xlf_prod_vm-xlf.montelnews.com"
    path                = "/"
    protocol            = "Http"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }
  probe {
    host                = "p-we1xlf-montelxlf-app.p-we1xlf.appserviceenvironment.net"
    interval            = 30
    name                = "probe_https-p-we1xlf_prod-xlf.montelnews.com"
    path                = "/"
    protocol            = "Https"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }
  probe {
    host                = "p-we1xlf-montelxlf-app.p-we1xlf.appserviceenvironment.net"
    interval            = 30
    name                = "probe_https-p-we1xlf_xlf.montelnews.com"
    path                = "/"
    protocol            = "Https"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }


  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1xlf.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "prod-xlf-vm.montelnews.com"
    name                           = "listener_https-p-we1xlf_prod_vm-xlf.montelnews.com"
    protocol                       = "Https"
    ssl_certificate_name           = "https-star-montelnews-com"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1xlf.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "prod-xlf.montelnews.com"
    name                           = "listener_https-p-we1xlf_prod-xlf.montelnews.com"
    protocol                       = "Https"
    ssl_certificate_name           = "https-star-montelnews-com"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1xlf.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "xlf.montelnews.com"
    name                           = "listener_https-p-we1xlf_xlf.montelnews.com"
    protocol                       = "Https"
    ssl_certificate_name           = "https-star-montelnews-com"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1xlf.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendPort"
    host_name                      = "prod-xlf-vm.montelnews.com"
    name                           = "listener_http-p-we1xlf_prod_vm-xlf.montelnews.com"
    protocol                       = "Http"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1xlf.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendPort"
    host_name                      = "prod-xlf.montelnews.com"
    name                           = "listener_http-p-we1xlf_prod-xlf.montelnews.com"
    protocol                       = "Http"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1xlf.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendPort"
    host_name                      = "xlf.montelnews.com"
    name                           = "listener_http-p-we1xlf_xlf.montelnews.com"
    protocol                       = "Http"
  }


  redirect_configuration {
    include_path         = true
    include_query_string = true
    name                 = "redirect_http-p-we1xlf_prod-xlf.montelnews.com"
    redirect_type        = "Permanent"
    target_listener_name = "listener_https-p-we1xlf_prod-xlf.montelnews.com"
  }
  redirect_configuration {
    include_path         = true
    include_query_string = true
    name                 = "redirect_http-p-we1xlf_prod_vm-xlf.montelnews.com"
    redirect_type        = "Permanent"
    target_listener_name = "listener_https-p-we1xlf_prod_vm-xlf.montelnews.com"
  }
  redirect_configuration {
    include_path         = true
    include_query_string = true
    name                 = "redirect_http-p-we1xlf_xlf.montelnews.com"
    redirect_type        = "Permanent"
    target_listener_name = "listener_https-p-we1xlf_xlf.montelnews.com"
  }


  # t-we1ase

  request_routing_rule {
    backend_address_pool_name  = "backendpool_t-we1ase_montelonline-app"
    backend_http_settings_name = "setting_https-t-we1ase_test-app.montelnews.com"
    http_listener_name         = "listener_https-t-we1ase_test-app.montelnews.com"
    name                       = "rule_https-t-we1ase_test-app.montelnews.com"
    priority                   = 10
    rule_type                  = "Basic"
  }
  request_routing_rule {
    backend_address_pool_name  = "backendpool_t-we1ase_montelwebapi-app"
    backend_http_settings_name = "setting_https-t-we1ase_test-api.montelnews.com"
    http_listener_name         = "listener_https-t-we1ase_test-api.montelnews.com"
    name                       = "rule_https-t-we1ase_test-api.montelnews.com"
    priority                   = 30
    rule_type                  = "Basic"
  }
  request_routing_rule {
    backend_address_pool_name  = "backendpool_t-we1ase_montelxlf-app"
    backend_http_settings_name = "setting_https-t-we1ase_test-xlf.montelnews.com"
    http_listener_name         = "listener_https-t-we1ase_test-xlf.montelnews.com"
    name                       = "rule_https-t-we1ase_test-xlf.montelnews.com"
    priority                   = 50
    rule_type                  = "Basic"
  }
  request_routing_rule {
    http_listener_name          = "listener_http-t-we1ase_test-api.montelnews.com"
    name                        = "rule_http-t-we1ase_test-api.montelnews.com"
    priority                    = 40
    redirect_configuration_name = "redirect_http-t-we1ase_test-api.montelnews.com"
    rule_type                   = "Basic"
  }
  request_routing_rule {
    http_listener_name          = "listener_http-t-we1ase_test-app.montelnews.com"
    name                        = "rule_http-t-we1ase_test-app.montelnews.com"
    priority                    = 20
    redirect_configuration_name = "redirect_http-t-we1ase_test-app.montelnews.com"
    rule_type                   = "Basic"
  }
  request_routing_rule {
    http_listener_name          = "listener_http-t-we1ase_test-xlf.montelnews.com"
    name                        = "rule_http-t-we1ase_test-xlf.montelnews.com"
    priority                    = 60
    redirect_configuration_name = "redirect_http-t-we1ase_test-xlf.montelnews.com"
    rule_type                   = "Basic"
  }


  backend_address_pool {
    fqdns = ["t-we1ase-montelwebapi-app.t-we1ase.appserviceenvironment.net"]
    name  = "backendpool_t-we1ase_montelwebapi-app"
  }
  backend_address_pool {
    fqdns = ["t-we1ase-montelxlf-app.t-we1ase.appserviceenvironment.net"]
    name  = "backendpool_t-we1ase_montelxlf-app"
  }
  backend_address_pool {
    ip_addresses = ["10.100.12.4"]
    name         = "backendpool_t-we1ase_montelonline-app"
  }


  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    name                                = "setting_https-t-we1ase_test-api.montelnews.com"
    pick_host_name_from_backend_address = true
    port                                = 443
    probe_name                          = "probe_https-t-we1ase_test-api.montelnews.com"
    protocol                            = "Https"
    request_timeout                     = 60
  }
  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    name                                = "setting_https-t-we1ase_test-xlf.montelnews.com"
    pick_host_name_from_backend_address = true
    port                                = 443
    probe_name                          = "probe_https-t-we1ase_test-xlf.montelnews.com"
    protocol                            = "Https"
    request_timeout                     = 60
  }
  backend_http_settings {
    affinity_cookie_name  = "ApplicationGatewayAffinity"
    cookie_based_affinity = "Disabled"
    host_name             = "test-app.montelnews.com"
    name                  = "setting_https-t-we1ase_test-app.montelnews.com"
    port                  = 443
    probe_name            = "probe_https-t-we1ase_test-app.montelnews.com"
    protocol              = "Https"
    request_timeout       = 60
  }


  probe {
    host                = "t-we1ase-montelwebapi-app.t-we1ase.appserviceenvironment.net"
    interval            = 30
    name                = "probe_https-t-we1ase_test-api.montelnews.com"
    path                = "/"
    protocol            = "Https"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }
  probe {
    host                = "t-we1ase-montelxlf-app.t-we1ase.appserviceenvironment.net"
    interval            = 30
    name                = "probe_https-t-we1ase_test-xlf.montelnews.com"
    path                = "/"
    protocol            = "Https"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }
  probe {
    host                = "test-app.montelnews.com"
    interval            = 30
    name                = "probe_https-t-we1ase_test-app.montelnews.com"
    path                = "/"
    protocol            = "Https"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }


  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-t-we1ase.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "test-api.montelnews.com"
    name                           = "listener_https-t-we1ase_test-api.montelnews.com"
    protocol                       = "Https"
    ssl_certificate_name           = "https-star-montelnews-com"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-t-we1ase.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "test-app.montelnews.com"
    name                           = "listener_https-t-we1ase_test-app.montelnews.com"
    protocol                       = "Https"
    require_sni                    = true
    ssl_certificate_name           = "https-star-montelnews-com"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-t-we1ase.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "test-xlf.montelnews.com"
    name                           = "listener_https-t-we1ase_test-xlf.montelnews.com"
    protocol                       = "Https"
    ssl_certificate_name           = "https-star-montelnews-com"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-t-we1ase.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendPort"
    host_name                      = "test-api.montelnews.com"
    name                           = "listener_http-t-we1ase_test-api.montelnews.com"
    protocol                       = "Http"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-t-we1ase.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendPort"
    host_name                      = "test-app.montelnews.com"
    name                           = "listener_http-t-we1ase_test-app.montelnews.com"
    protocol                       = "Http"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-t-we1ase.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendPort"
    host_name                      = "test-xlf.montelnews.com"
    name                           = "listener_http-t-we1ase_test-xlf.montelnews.com"
    protocol                       = "Http"
  }


  redirect_configuration {
    include_path         = true
    include_query_string = true
    name                 = "redirect_http-t-we1ase_test-api.montelnews.com"
    redirect_type        = "Permanent"
    target_listener_name = "listener_https-t-we1ase_test-api.montelnews.com"
  }
  redirect_configuration {
    include_path         = true
    include_query_string = true
    name                 = "redirect_http-t-we1ase_test-app.montelnews.com"
    redirect_type        = "Permanent"
    target_listener_name = "listener_https-t-we1ase_test-app.montelnews.com"
  }
  redirect_configuration {
    include_path         = true
    include_query_string = true
    name                 = "redirect_http-t-we1ase_test-xlf.montelnews.com"
    redirect_type        = "Permanent"
    target_listener_name = "listener_https-t-we1ase_test-xlf.montelnews.com"
  }

}

################################################
#  Application Gateway diagnostics
################################################

resource "azurerm_monitor_diagnostic_setting" "AppGateway1" {
  name                       = data.azurerm_log_analytics_workspace.central.name
  target_resource_id         = azurerm_application_gateway.AppGateway1.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.central.id

  enabled_log {
    category = "ApplicationGatewayAccessLog"
  }
  enabled_log {
    category = "ApplicationGatewayPerformanceLog"
  }
  enabled_log {
    category = "ApplicationGatewayFirewallLog"
  }
  metric {
    category = "AllMetrics"
  }
}
