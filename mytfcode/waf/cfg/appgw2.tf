################################################
#  Application Gateway 2 Public IP
################################################

resource "azurerm_public_ip" "AppGateway2002" {
  name                = "${azurerm_resource_group.public.name}-waf02-pip"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.public.name

  domain_name_label = "p-we1waf-pub-waf02-pip-b6j6ecyqrbvxa"
  // domain_name_label = "${azurerm_resource_group.public.name}-waf02-pip-${random_string.random.result}"
  allocation_method    = "Static"
  sku                  = "Standard"
  zones                = var.zones
  ddos_protection_mode = var.AppGateway2-publicIp-ddos_protection_mode
}


################################################
#  Application Gateway 2 Managed Identity
################################################

resource "azurerm_user_assigned_identity" "AppGateway2" {
  name                = "${azurerm_resource_group.public.name}-waf02-id"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.public.name
}


################################################
#  Application Gateway
################################################

resource "azurerm_application_gateway" "AppGateway2" {
  name                = "${azurerm_resource_group.public.name}-waf02"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.public.name

  zones = var.zones

  sku {
    capacity = var.AppGateway2-sku-capacity
    name     = "WAF_v2"
    tier     = "WAF_v2"
  }

  enable_http2 = var.AppGateway2-enable_http2

  ################################################
  #  Default WAF Policy
  ################################################

  firewall_policy_id = azurerm_web_application_firewall_policy.wafpolicy-appgw2.id
  waf_configuration {
    enabled                  = var.AppGateway2-waf_configuration-enabled
    firewall_mode            = var.AppGateway2-waf_configuration-firewall_mode
    rule_set_type            = var.AppGateway2-waf_configuration-rule_set_type
    rule_set_version         = var.AppGateway2-waf_configuration-rule_set_version
    file_upload_limit_mb     = var.AppGateway2-waf_configuration-file_upload_limit_mb
    request_body_check       = var.AppGateway2-waf_configuration-request_body_check
    max_request_body_size_kb = var.AppGateway2-waf_configuration-max_request_body_size_kb
  }


  ################################################
  #  Frontends
  ################################################


  frontend_ip_configuration {
    name                 = "appGwPublicFrontendIp"
    public_ip_address_id = azurerm_public_ip.AppGateway2002.id
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
      azurerm_user_assigned_identity.AppGateway2.id,
    ]
    type = "UserAssigned"
  }
  ssl_certificate {
    key_vault_secret_id = "https://p-net-kvmkc73wbq-kv.vault.azure.net/secrets/app-montelforeks-com"
    name                = "https-app-montelforeks-com"
  }
  ssl_certificate {
    key_vault_secret_id = "https://p-net-kvmkc73wbq-kv.vault.azure.net/secrets/star-montelgroup-com"
    name                = "https-star-montelgroup-com"
  }
  ssl_certificate {
    key_vault_secret_id = "https://p-net-kvmkc73wbq-kv.vault.azure.net/secrets/star-montelnews-com"
    name                = "https-star-montelnews-com"
  }

  ################################################
  #  Workloads
  ################################################

  # p-alert

  request_routing_rule {
    backend_address_pool_name  = "backendpool_p-alert_prod_vm-api-montelgroup-app"
    backend_http_settings_name = "setting_http-p-alert_prod_vm-api-montelgroup.com"
    http_listener_name         = "listener_https-p-alert_prod_vm-api-montelgroup.com"
    name                       = "rule_https-p-alert_prod_vm-api-montelgroup.com"
    priority                   = 50
    rule_type                  = "Basic"
  }
  request_routing_rule {
    backend_address_pool_name  = "backendpool_p-alert_prod_vm-montelgroup-app"
    backend_http_settings_name = "setting_http-p-alert_prod_vm-montelgroup.com"
    http_listener_name         = "listener_https-p-alert_prod_vm-montelgroup.com"
    name                       = "rule_https-p-alert_prod_vm-montelgroup.com"
    priority                   = 30
    rule_type                  = "Basic"
  }
  request_routing_rule {
    http_listener_name          = "listener_http-p-alert_prod_vm-api-montelgroup.com"
    name                        = "rule_http-p-alert_prod_vm-api-montelgroup.com"
    priority                    = 60
    redirect_configuration_name = "redirect_http-p-alert_prod_vm-api-montelgroup.com"
    rule_type                   = "Basic"
  }
  request_routing_rule {
    http_listener_name          = "listener_http-p-alert_prod_vm-montelgroup.com"
    name                        = "rule_http-p-alert_prod_vm-montelgroup.com"
    priority                    = 40
    redirect_configuration_name = "redirect_http-p-alert_prod_vm-montelgroup.com"
    rule_type                   = "Basic"
  }


  backend_address_pool {
    ip_addresses = ["10.100.14.68"]
    name         = "backendpool_p-alert_prod_vm-api-montelgroup-app"
  }
  backend_address_pool {
    ip_addresses = ["10.100.14.68"]
    name         = "backendpool_p-alert_prod_vm-montelgroup-app"
  }


  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    name                                = "setting_http-p-alert_prod_vm-api-montelgroup.com"
    pick_host_name_from_backend_address = true
    port                                = 10012
    probe_name                          = "probe_http-p-alert_prod_vm-api-montelgroup.com"
    protocol                            = "Http"
    request_timeout                     = 60
  }
  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    name                                = "setting_http-p-alert_prod_vm-montelgroup.com"
    pick_host_name_from_backend_address = true
    port                                = 10010
    probe_name                          = "probe_http-p-alert_prod_vm-montelgroup.com"
    protocol                            = "Http"
    request_timeout                     = 60
  }


  probe {
    host                = "10.100.14.68"
    interval            = 30
    name                = "probe_http-p-alert_prod_vm-api-montelgroup.com"
    path                = "/healthz"
    protocol            = "Http"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }
  probe {
    host                = "10.100.14.68"
    interval            = 30
    name                = "probe_http-p-alert_prod_vm-montelgroup.com"
    path                = "/"
    protocol            = "Http"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }


  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-alert.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "alerts-api.montelgroup.com"
    name                           = "listener_https-p-alert_prod_vm-api-montelgroup.com"
    protocol                       = "Https"
    ssl_certificate_name           = "https-star-montelgroup-com"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-alert.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "alerts.montelgroup.com"
    name                           = "listener_https-p-alert_prod_vm-montelgroup.com"
    protocol                       = "Https"
    ssl_certificate_name           = "https-star-montelgroup-com"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-alert.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendPort"
    host_name                      = "alerts-api.montelgroup.com"
    name                           = "listener_http-p-alert_prod_vm-api-montelgroup.com"
    protocol                       = "Http"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-alert.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendPort"
    host_name                      = "alerts.montelgroup.com"
    name                           = "listener_http-p-alert_prod_vm-montelgroup.com"
    protocol                       = "Http"
  }


  redirect_configuration {
    include_path         = true
    include_query_string = true
    name                 = "redirect_http-p-alert_prod_vm-api-montelgroup.com"
    redirect_type        = "Permanent"
    target_listener_name = "listener_https-p-alert_prod_vm-api-montelgroup.com"
  }
  redirect_configuration {
    include_path         = true
    include_query_string = true
    name                 = "redirect_http-p-alert_prod_vm-montelgroup.com"
    redirect_type        = "Permanent"
    target_listener_name = "listener_https-p-alert_prod_vm-montelgroup.com"
  }


  # p-we1adm

  request_routing_rule {
    http_listener_name          = "listener_p-we1adm_http_accountadmin.montelgroup.com"
    name                        = "rule_p-we1adm_http_accountadmin.montelgroup.com"
    priority                    = 110
    redirect_configuration_name = "redirect_p-we1adm_http_accountadmin.montelgroup.com"
    rule_type                   = "Basic"
  }
  request_routing_rule {
    backend_address_pool_name  = "backendpool_p-we1adm_accountadmin-api.montelgroup.com"
    backend_http_settings_name = "setting_p-we1adm_https_accountadmin-api.montelgroup.com"
    http_listener_name         = "listener_p-we1adm_https_accountadmin-api.montelgroup.com"
    name                       = "rule_p-we1adm_https_accountadmin-api.montelgroup.com"
    priority                   = 120
    rule_type                  = "Basic"
  }
  request_routing_rule {
    backend_address_pool_name  = "backendpool_p-we1adm_accountadmin.montelgroup.com"
    backend_http_settings_name = "setting_p-we1adm_https_accountadmin.montelgroup.com"
    http_listener_name         = "listener_p-we1adm_https_accountadmin.montelgroup.com"
    name                       = "rule_p-we1adm_https_accountadmin.montelgroup.com"
    priority                   = 100
    rule_type                  = "Basic"
  }


  backend_address_pool {
    fqdns = ["p-we1adm-apizaevwy-app.p-we1adm-ase.appserviceenvironment.net"]
    name  = "backendpool_p-we1adm_accountadmin-api.montelgroup.com"
  }
  backend_address_pool {
    fqdns = ["p-we1adm-websitezaevwy-app.p-we1adm-ase.appserviceenvironment.net"]
    name  = "backendpool_p-we1adm_accountadmin.montelgroup.com"
  }


  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    name                                = "setting_p-we1adm_https_accountadmin-api.montelgroup.com"
    pick_host_name_from_backend_address = true
    port                                = 443
    probe_name                          = "probe_p-we1adm_https_accountadmin-api.montelgroup.com"
    protocol                            = "Https"
    request_timeout                     = 60
  }
  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    name                                = "setting_p-we1adm_https_accountadmin.montelgroup.com"
    pick_host_name_from_backend_address = true
    port                                = 443
    probe_name                          = "probe_p-we1adm_https_accountadmin.montelgroup.com"
    protocol                            = "Https"
    request_timeout                     = 60
  }


  probe {
    host                = "p-we1adm-apizaevwy-app.p-we1adm-ase.appserviceenvironment.net"
    interval            = 30
    name                = "probe_p-we1adm_https_accountadmin-api.montelgroup.com"
    path                = "/healthz"
    protocol            = "Https"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }
  probe {
    host                = "p-we1adm-websitezaevwy-app.p-we1adm-ase.appserviceenvironment.net"
    interval            = 30
    name                = "probe_p-we1adm_https_accountadmin.montelgroup.com"
    path                = "/"
    protocol            = "Https"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }


  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1adm.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "accountadmin-api.montelgroup.com"
    name                           = "listener_p-we1adm_https_accountadmin-api.montelgroup.com"
    protocol                       = "Https"
    ssl_certificate_name           = "https-star-montelgroup-com"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1adm.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "accountadmin.montelgroup.com"
    name                           = "listener_p-we1adm_https_accountadmin.montelgroup.com"
    protocol                       = "Https"
    ssl_certificate_name           = "https-star-montelgroup-com"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1adm.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendPort"
    host_name                      = "accountadmin.montelgroup.com"
    name                           = "listener_p-we1adm_http_accountadmin.montelgroup.com"
    protocol                       = "Http"
  }


  redirect_configuration {
    include_path         = true
    include_query_string = true
    name                 = "redirect_p-we1adm_http_accountadmin.montelgroup.com"
    redirect_type        = "Permanent"
    target_listener_name = "listener_p-we1adm_https_accountadmin.montelgroup.com"
  }


  # p-we1gnx

  request_routing_rule {
    backend_address_pool_name  = "backendpool_p-we1gnx_test-ganexo.montelgroup.com"
    backend_http_settings_name = "setting_p-we1gnx_https_test-ganexo.montelgroup.com"
    http_listener_name         = "listener_p-we1gnx_https_test-ganexo.montelgroup.com"
    name                       = "rule_p-we1gnx_https_test-ganexo.montelgroup.com"
    priority                   = 170
    rule_type                  = "Basic"
  }


  backend_address_pool {
    fqdns = ["pwe1gnx5ouupz-ganexo-func.azurewebsites.net"]
    name  = "backendpool_p-we1gnx_test-ganexo.montelgroup.com"
  }


  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    name                                = "setting_p-we1gnx_https_test-ganexo.montelgroup.com"
    pick_host_name_from_backend_address = true
    port                                = 443
    probe_name                          = "probe_p-we1gnx_https_test-ganexo.montelgroup.com"
    protocol                            = "Https"
    request_timeout                     = 60
  }


  probe {
    host                = "pwe1gnx5ouupz-ganexo-func.azurewebsites.net"
    interval            = 30
    name                = "probe_p-we1gnx_https_test-ganexo.montelgroup.com"
    path                = "/"
    protocol            = "Https"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }


  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1gnx.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "test-ganexo.montelgroup.com"
    name                           = "listener_p-we1gnx_https_test-ganexo.montelgroup.com"
    protocol                       = "Https"
    ssl_certificate_name           = "https-star-montelgroup-com"
  }


  # p-we1ins

  request_routing_rule {
    backend_address_pool_name  = "backendpool_p-we1ins_prod-inspector-api.montelgroup.com"
    backend_http_settings_name = "setting_p-we1ins_https_prod-inspector-api.montelgroup.com"
    http_listener_name         = "listener_p-we1ins_https_prod-inspector-api.montelgroup.com"
    name                       = "rule_p-we1ins_https_prod-inspector-api.montelgroup.com"
    priority                   = 90
    rule_type                  = "Basic"
  }
  request_routing_rule {
    backend_address_pool_name  = "backendpool_p-we1ins_prod-inspector.montelgroup.com"
    backend_http_settings_name = "setting_p-we1ins_https_prod-inspector.montelgroup.com"
    http_listener_name         = "listener_p-we1ins_https_prod-inspector.montelgroup.com"
    name                       = "rule_p-we1ins_https_prod-inspector.montelgroup.com"
    priority                   = 70
    rule_type                  = "Basic"
  }
  request_routing_rule {
    http_listener_name          = "listener_p-we1ins_http_prod-inspector.montelgroup.com"
    name                        = "rule_p-we1ins_http_prod-inspector.montelgroup.com"
    priority                    = 80
    redirect_configuration_name = "redirect_p-we1ins_http_prod-inspector.montelgroup.com"
    rule_type                   = "Basic"
  }


  backend_address_pool {
    fqdns = ["p-we1ins-apiuj6fd4-app.p-we1ins-ase.appserviceenvironment.net"]
    name  = "backendpool_p-we1ins_prod-inspector-api.montelgroup.com"
  }
  backend_address_pool {
    fqdns = ["p-we1ins-websiteuj6fd4-app.p-we1ins-ase.appserviceenvironment.net"]
    name  = "backendpool_p-we1ins_prod-inspector.montelgroup.com"
  }


  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    name                                = "setting_p-we1ins_https_prod-inspector-api.montelgroup.com"
    pick_host_name_from_backend_address = true
    port                                = 443
    probe_name                          = "probe_p-we1ins_https_prod-inspector-api.montelgroup.com"
    protocol                            = "Https"
    request_timeout                     = 60
  }
  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    name                                = "setting_p-we1ins_https_prod-inspector.montelgroup.com"
    pick_host_name_from_backend_address = true
    port                                = 443
    probe_name                          = "probe_p-we1ins_https_prod-inspector.montelgroup.com"
    protocol                            = "Https"
    request_timeout                     = 60
  }


  probe {
    host                = "p-we1ins-apiuj6fd4-app.p-we1ins-ase.appserviceenvironment.net"
    interval            = 30
    name                = "probe_p-we1ins_https_prod-inspector-api.montelgroup.com"
    path                = "/Debug/OpenEndpoint"
    protocol            = "Https"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }
  probe {
    host                = "p-we1ins-websiteuj6fd4-app.p-we1ins-ase.appserviceenvironment.net"
    interval            = 30
    name                = "probe_p-we1ins_https_prod-inspector.montelgroup.com"
    path                = "/"
    protocol            = "Https"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }


  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1ins.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "inspector-api.montelgroup.com"
    name                           = "listener_p-we1ins_https_prod-inspector-api.montelgroup.com"
    protocol                       = "Https"
    ssl_certificate_name           = "https-star-montelgroup-com"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1ins.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "inspector.montelgroup.com"
    name                           = "listener_p-we1ins_https_prod-inspector.montelgroup.com"
    protocol                       = "Https"
    ssl_certificate_name           = "https-star-montelgroup-com"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1ins.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendPort"
    host_name                      = "inspector.montelgroup.com"
    name                           = "listener_p-we1ins_http_prod-inspector.montelgroup.com"
    protocol                       = "Http"
  }


  redirect_configuration {
    include_path         = true
    include_query_string = true
    name                 = "redirect_p-we1ins_http_prod-inspector.montelgroup.com"
    redirect_type        = "Permanent"
    target_listener_name = "listener_p-we1ins_https_prod-inspector.montelgroup.com"
  }


  # p-we1mat

  request_routing_rule {
    backend_address_pool_name  = "backendpool_p-we1mat_test-authserver.montelgroup.com"
    backend_http_settings_name = "setting_p-we1mat_https_test-authserver.montelgroup.com"
    http_listener_name         = "listener_p-we1mat_https_test-authserver.montelgroup.com"
    name                       = "rule_p-we1mat_https_test-authserver.montelgroup.com"
    priority                   = 230
    rule_type                  = "Basic"
  }


  backend_address_pool {
    fqdns = ["p-we1mat-authservere1b1yo-app.azurewebsites.net"]
    name  = "backendpool_p-we1mat_test-authserver.montelgroup.com"
  }


  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    name                                = "setting_p-we1mat_https_test-authserver.montelgroup.com"
    pick_host_name_from_backend_address = true
    port                                = 443
    probe_name                          = "probe_p-we1mat_https_test-authserver.montelgroup.com"
    protocol                            = "Https"
    request_timeout                     = 60
  }


  probe {
    host                = "p-we1mat-authservere1b1yo-app.azurewebsites.net"
    interval            = 30
    name                = "probe_p-we1mat_https_test-authserver.montelgroup.com"
    path                = "/healthz"
    protocol            = "Https"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }


  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1mat.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "test-authserver.montelgroup.com"
    name                           = "listener_p-we1mat_https_test-authserver.montelgroup.com"
    protocol                       = "Https"
    ssl_certificate_name           = "https-star-montelgroup-com"
  }


  # p-we1mkt

  request_routing_rule {
    backend_address_pool_name  = "backendpool_p-we1mkt-marketplace-api.montelgroup.com"
    backend_http_settings_name = "setting_p-we1mkt_https-marketplace-api.montelgroup.com"
    http_listener_name         = "listener_p-we1mkt_https-marketplace-api.montelgroup.com"
    name                       = "rule_p-we1mkt_https-marketplace-api.montelgroup.com"
    priority                   = 150
    rule_type                  = "Basic"
  }
  request_routing_rule {
    backend_address_pool_name  = "backendpool_p-we1mkt-marketplace.montelgroup.com"
    backend_http_settings_name = "setting_p-we1mkt_https-marketplace.montelgroup.com"
    http_listener_name         = "listener_p-we1mkt_https-marketplace.montelgroup.com"
    name                       = "rule_p-we1mkt_https-marketplace.montelgroup.com"
    priority                   = 130
    rule_type                  = "Basic"
  }
  request_routing_rule {
    backend_address_pool_name  = "backendpool_p-we1mkt_marketplace-consumerservice.montelgroup.com"
    backend_http_settings_name = "setting_p-we1mkt_marketplace-consumerservice.montelgroup.com"
    http_listener_name         = "listener_p-we1mkt_marketplace-consumerservice.montelgroup.com"
    name                       = "rule_p-we1mkt_marketplace-consumerservice.montelgroup.com"
    priority                   = 160
    rule_type                  = "Basic"
  }
  request_routing_rule {
    http_listener_name          = "listener_p-we1mkt_http-marketplace.montelgroup.com"
    name                        = "rule_p-we1mkt_http-marketplace.montelgroup.com"
    priority                    = 140
    redirect_configuration_name = "redirect_p-we1mkt_http-marketplace.montelgroup.com"
    rule_type                   = "Basic"
  }


  backend_address_pool {
    fqdns = ["p-we1mkt-apicygy2j-app.p-we1mkt-ase.appserviceenvironment.net"]
    name  = "backendpool_p-we1mkt-marketplace-api.montelgroup.com"
  }
  backend_address_pool {
    fqdns = ["p-we1mkt-websitecygy2j-app.p-we1mkt-ase.appserviceenvironment.net"]
    name  = "backendpool_p-we1mkt-marketplace.montelgroup.com"
  }
  backend_address_pool {
    fqdns = ["p-we1mkt-consumerservicecygy2j-app.p-we1mkt-ase.appserviceenvironment.net"]
    name  = "backendpool_p-we1mkt_marketplace-consumerservice.montelgroup.com"
  }


  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    name                                = "setting_p-we1mkt_https-marketplace-api.montelgroup.com"
    pick_host_name_from_backend_address = true
    port                                = 443
    probe_name                          = "probe_p-we1mkt_https-marketplace-api.montelgroup.com"
    protocol                            = "Https"
    request_timeout                     = 60
  }
  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    name                                = "setting_p-we1mkt_https-marketplace.montelgroup.com"
    pick_host_name_from_backend_address = true
    port                                = 443
    probe_name                          = "probe_p-we1mkt_https-marketplace.montelgroup.com"
    protocol                            = "Https"
    request_timeout                     = 60
  }
  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    name                                = "setting_p-we1mkt_marketplace-consumerservice.montelgroup.com"
    pick_host_name_from_backend_address = true
    port                                = 443
    probe_name                          = "probe_p-we1mkt_marketplace-consumerservice.montelgroup.com"
    protocol                            = "Https"
    request_timeout                     = 60
  }


  probe {
    host                = "p-we1mkt-apicygy2j-app.p-we1mkt-ase.appserviceenvironment.net"
    interval            = 30
    name                = "probe_p-we1mkt_https-marketplace-api.montelgroup.com"
    path                = "/healthz"
    protocol            = "Https"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }
  probe {
    host                = "p-we1mkt-consumerservicecygy2j-app.p-we1mkt-ase.appserviceenvironment.net"
    interval            = 30
    name                = "probe_p-we1mkt_marketplace-consumerservice.montelgroup.com"
    path                = "/healthz"
    protocol            = "Https"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }
  probe {
    host                = "p-we1mkt-websitecygy2j-app.p-we1mkt-ase.appserviceenvironment.net"
    interval            = 30
    name                = "probe_p-we1mkt_https-marketplace.montelgroup.com"
    path                = "/"
    protocol            = "Https"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }


  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1mkt.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "marketplace-api.montelgroup.com"
    name                           = "listener_p-we1mkt_https-marketplace-api.montelgroup.com"
    protocol                       = "Https"
    ssl_certificate_name           = "https-star-montelgroup-com"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1mkt.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "marketplace-cs.montelgroup.com"
    name                           = "listener_p-we1mkt_marketplace-consumerservice.montelgroup.com"
    protocol                       = "Https"
    ssl_certificate_name           = "https-star-montelgroup-com"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1mkt.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "marketplace.montelgroup.com"
    name                           = "listener_p-we1mkt_https-marketplace.montelgroup.com"
    protocol                       = "Https"
    ssl_certificate_name           = "https-star-montelgroup-com"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1mkt.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendPort"
    host_name                      = "marketplace.montelgroup.com"
    name                           = "listener_p-we1mkt_http-marketplace.montelgroup.com"
    protocol                       = "Http"
  }


  redirect_configuration {
    include_path         = true
    include_query_string = true
    name                 = "redirect_p-we1mkt_http-marketplace.montelgroup.com"
    redirect_type        = "Permanent"
    target_listener_name = "listener_p-we1mkt_https-marketplace.montelgroup.com"
  }


  # p-we1nap

  request_routing_rule {
    backend_address_pool_name  = "backendpool_p-we1nap_news-api.montelgroup.com"
    backend_http_settings_name = "setting_p-we1nap_https_news-api.montelgroup.com"
    http_listener_name         = "listener_p-we1nap_https_news-api.montelgroup.com"
    name                       = "rule_p-we1nap_https_news-api.montelgroup.com"
    priority                   = 180
    rule_type                  = "Basic"
  }


  backend_address_pool {
    fqdns = ["p-we1nap-newsmrx245-app.azurewebsites.net"]
    name  = "backendpool_p-we1nap_news-api.montelgroup.com"
  }


  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    name                                = "setting_p-we1nap_https_news-api.montelgroup.com"
    pick_host_name_from_backend_address = true
    port                                = 443
    probe_name                          = "probe_p-we1nap_https_news-api.montelgroup.com"
    protocol                            = "Https"
    request_timeout                     = 60
  }


  probe {
    host                = "p-we1nap-newsmrx245-app.azurewebsites.net"
    interval            = 30
    name                = "probe_p-we1nap_https_news-api.montelgroup.com"
    path                = "/healthz"
    protocol            = "Https"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }


  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1nap.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "news-api.montelgroup.com"
    name                           = "listener_p-we1nap_https_news-api.montelgroup.com"
    protocol                       = "Https"
    ssl_certificate_name           = "https-star-montelgroup-com"
  }


  # p-we1ncv

  request_routing_rule {
    backend_address_pool_name  = "backendpool_p-we1ncv_newsconverter-api.montelgroup.com"
    backend_http_settings_name = "setting_p-we1ncv_https_newsconverter-api.montelgroup.com"
    http_listener_name         = "listener_p-we1ncv_https_newsconverter-api.montelgroup.com"
    name                       = "rule_p-we1ncv_https_newsconverter-api.montelgroup.com"
    priority                   = 190
    rule_type                  = "Basic"
  }


  backend_address_pool {
    fqdns = ["p-we1ncv-newsconverternd3wvb-app.azurewebsites.net"]
    name  = "backendpool_p-we1ncv_newsconverter-api.montelgroup.com"
  }


  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    name                                = "setting_p-we1ncv_https_newsconverter-api.montelgroup.com"
    pick_host_name_from_backend_address = true
    port                                = 443
    probe_name                          = "probe_p-we1ncv_https_newsconverter-api.montelgroup.com"
    protocol                            = "Https"
    request_timeout                     = 60
  }


  probe {
    host                = "p-we1ncv-newsconverternd3wvb-app.azurewebsites.net"
    interval            = 30
    name                = "probe_p-we1ncv_https_newsconverter-api.montelgroup.com"
    path                = "/healthz"
    protocol            = "Https"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }


  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1ncv.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "newsconverter-api.montelgroup.com"
    name                           = "listener_p-we1ncv_https_newsconverter-api.montelgroup.com"
    protocol                       = "Https"
    ssl_certificate_name           = "https-star-montelgroup-com"
  }


  # p-we1nml

  request_routing_rule {
    backend_address_pool_name  = "backendpool_p-we1nml_news-newsmail.montelgroup.com"
    backend_http_settings_name = "setting_p-we1nml_news-newsmail.montelgroup.com"
    http_listener_name         = "listener_p-we1nml_news-newsmail.montelgroup.com"
    name                       = "rule_p-we1nml_news-newsmail.montelgroup.com"
    priority                   = 220
    rule_type                  = "Basic"
  }


  backend_address_pool {
    fqdns = ["pwe1nmlju1rjc-newsmail-func.azurewebsites.net"]
    name  = "backendpool_p-we1nml_news-newsmail.montelgroup.com"
  }


  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    name                                = "setting_p-we1nml_news-newsmail.montelgroup.com"
    pick_host_name_from_backend_address = true
    port                                = 443
    probe_name                          = "probe_p-we1nml_news-newsmail.montelgroup.com"
    protocol                            = "Https"
    request_timeout                     = 60
  }


  probe {
    host                = "pwe1nmlju1rjc-newsmail-func.azurewebsites.net"
    interval            = 30
    name                = "probe_p-we1nml_news-newsmail.montelgroup.com"
    path                = "/"
    protocol            = "Https"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }


  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1nml.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "newsmail.montelgroup.com"
    name                           = "listener_p-we1nml_news-newsmail.montelgroup.com"
    protocol                       = "Https"
    ssl_certificate_name           = "https-star-montelgroup-com"
  }


  # p-we1npn

  request_routing_rule {
    backend_address_pool_name  = "backendpool_p-we1npn_npn-montelnews-app"
    backend_http_settings_name = "setting_https-p-we1npn_npn.montelnews.com"
    http_listener_name         = "listener_https-p-we1npn_npn.montelnews.com"
    name                       = "rule_https-p-we1npn_npn.montelnews.com"
    priority                   = 10
    rule_type                  = "Basic"
  }
  request_routing_rule {
    http_listener_name          = "listener_http-p-we1npn_npn.montelnews.com"
    name                        = "rule_http-p-we1npn_npn.montelnews.com"
    priority                    = 20
    redirect_configuration_name = "redirect_http-p-we1npn_npn.montelnews.com"
    rule_type                   = "Basic"
  }


  backend_address_pool {
    fqdns = ["pwe1npn4ieg9d-nordpoolwebhook-func.azurewebsites.net"]
    name  = "backendpool_p-we1npn_npn-montelnews-app"
  }


  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    name                                = "setting_https-p-we1npn_npn.montelnews.com"
    pick_host_name_from_backend_address = true
    port                                = 443
    probe_name                          = "probe_https-p-we1npn_npn.montelnews.com"
    protocol                            = "Https"
    request_timeout                     = 60
  }


  probe {
    host                = "pwe1npn4ieg9d-nordpoolwebhook-func.azurewebsites.net"
    interval            = 30
    name                = "probe_https-p-we1npn_npn.montelnews.com"
    path                = "/"
    protocol            = "Https"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }


  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1npn.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "nordpoolnotifications.montelnews.com"
    name                           = "listener_https-p-we1npn_npn.montelnews.com"
    protocol                       = "Https"
    ssl_certificate_name           = "https-star-montelnews-com"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-p-we1npn.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendPort"
    host_name                      = "nordpoolnotifications.montelnews.com"
    name                           = "listener_http-p-we1npn_npn.montelnews.com"
    protocol                       = "Http"
    ssl_certificate_name           = "https-star-montelnews-com"
  }


  redirect_configuration {
    include_path         = true
    include_query_string = true
    name                 = "redirect_http-p-we1npn_npn.montelnews.com"
    redirect_type        = "Permanent"
    target_listener_name = "listener_https-p-we1npn_npn.montelnews.com"
  }


  # t-we1mo

  request_routing_rule {
    backend_address_pool_name  = "backendpool_t-we1mo_test-app.montelnews.com"
    backend_http_settings_name = "setting_t-we1mo_https_test-app.montelnews.com"
    http_listener_name         = "listener_t-we1mo_https_test-app.montelnews.com"
    name                       = "rule_t-we1mo_https_test-app.montelnews.com"
    priority                   = 200
    rule_type                  = "Basic"
  }
  request_routing_rule {
    http_listener_name          = "listener_t-we1mo_http_test-app.montelnews.com"
    name                        = "rule_t-we1mo_http_test-app.montelnews.com"
    priority                    = 210
    redirect_configuration_name = "redirect_t-we1mo_http_test-app.montelnews.com"
    rule_type                   = "Basic"
  }


  backend_address_pool {
    ip_addresses = ["10.100.15.196"]
    name         = "backendpool_t-we1mo_test-app.montelnews.com"
  }


  backend_http_settings {
    affinity_cookie_name  = "ApplicationGatewayAffinity"
    cookie_based_affinity = "Disabled"
    host_name             = "test-app.montelnews.com"
    name                  = "setting_t-we1mo_https_test-app.montelnews.com"
    port                  = 443
    probe_name            = "probe_t-we1mo_https_test-app.montelnews.com"
    protocol              = "Https"
    request_timeout       = 60
  }


  probe {
    host                = "test-app.montelnews.com"
    interval            = 30
    name                = "probe_t-we1mo_https_test-app.montelnews.com"
    path                = "/"
    protocol            = "Https"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }


  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-t-we1mo.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendPort"
    host_name                      = "test-app.montelnews.com"
    name                           = "listener_t-we1mo_http_test-app.montelnews.com"
    protocol                       = "Http"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-t-we1mo.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "test-app.montelnews.com"
    name                           = "listener_t-we1mo_https_test-app.montelnews.com"
    protocol                       = "Https"
    require_sni                    = true
    ssl_certificate_name           = "https-star-montelnews-com"
  }


  redirect_configuration {
    include_path         = true
    include_query_string = true
    name                 = "redirect_t-we1mo_http_test-app.montelnews.com"
    redirect_type        = "Permanent"
    target_listener_name = "listener_t-we1mo_https_test-app.montelnews.com"
  }


  # t-we1mwa

  request_routing_rule {
    backend_address_pool_name  = "backendpool_t-we1mwa_test-api.montelnews.com"
    backend_http_settings_name = "setting_t-we1mwa_https_test-api.montelnews.com"
    http_listener_name         = "listener_t-we1mwa_https_test-api.montelnews.com"
    name                       = "rule_t-we1mwa_https_test-api.montelnews.com"
    priority                   = 220
    rule_type                  = "Basic"
  }
  request_routing_rule {
    http_listener_name          = "listener_t-we1mwa_http_test-api.montelnews.com"
    name                        = "rule_t-we1mwa_http_test-api.montelnews.com"
    priority                    = 230
    redirect_configuration_name = "redirect_t-we1mwa_http_test-api.montelnews.com"
    rule_type                   = "Basic"
  }

  backend_address_pool {
    fqdns = ["t-we1mwa-montelwebapi-app.t-we1mwa.appserviceenvironment.net"]
    name  = "backendpool_t-we1mwa_test-api.montelnews.com"
  }


  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    name                                = "setting_t-we1mwa_https_test-api.montelnews.com"
    pick_host_name_from_backend_address = true
    port                                = 443
    probe_name                          = "probe_t-we1mwa_https_test-api.montelnews.com"
    protocol                            = "Https"
    request_timeout                     = 60
  }


  probe {
    host                = "t-we1mwa-montelwebapi-app.t-we1mwa.appserviceenvironment.net"
    interval            = 30
    name                = "probe_t-we1mwa_https_test-api.montelnews.com"
    path                = "/"
    protocol            = "Https"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }


  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-t-we1mwa.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendPort"
    host_name                      = "test-api.montelnews.com"
    name                           = "listener_t-we1mwa_http_test-api.montelnews.com"
    protocol                       = "Http"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-t-we1mwa.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "test-api.montelnews.com"
    name                           = "listener_t-we1mwa_https_test-api.montelnews.com"
    protocol                       = "Https"
    ssl_certificate_name           = "https-star-montelnews-com"
  }


  redirect_configuration {
    include_path         = true
    include_query_string = true
    name                 = "redirect_t-we1mwa_http_test-api.montelnews.com"
    redirect_type        = "Permanent"
    target_listener_name = "listener_t-we1mwa_https_test-api.montelnews.com"
  }



  # t-we1xlf

  request_routing_rule {
    backend_address_pool_name  = "backendpool_t-we1xlf_test-xlf.montelnews.com"
    backend_http_settings_name = "setting_t-we1xlf_https_test-xlf.montelnews.com"
    http_listener_name         = "listener_t-we1xlf_https_test-xlf.montelnews.com"
    name                       = "rule_t-we1xlf_https_test-xlf.montelnews.com"
    priority                   = 240
    rule_type                  = "Basic"
  }
  request_routing_rule {
    http_listener_name          = "listener_t-we1xlf_http_test-xlf.montelnews.com"
    name                        = "rule_t-we1xlf_http_test-xlf.montelnews.com"
    priority                    = 250
    redirect_configuration_name = "redirect_t-we1xlf_http_test-xlf.montelnews.com"
    rule_type                   = "Basic"
  }


  backend_address_pool {
    fqdns = ["t-we1xlf-montelxlf-app.t-we1xlf.appserviceenvironment.net"]
    name  = "backendpool_t-we1xlf_test-xlf.montelnews.com"
  }


  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    name                                = "setting_t-we1xlf_https_test-xlf.montelnews.com"
    pick_host_name_from_backend_address = true
    port                                = 443
    probe_name                          = "probe_t-we1xlf_https_test-xlf.montelnews.com"
    protocol                            = "Https"
    request_timeout                     = 60
  }


  probe {
    host                = "t-we1xlf-montelxlf-app.t-we1xlf.appserviceenvironment.net"
    interval            = 30
    name                = "probe_t-we1xlf_https_test-xlf.montelnews.com"
    path                = "/"
    protocol            = "Https"
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-399"]
    }
  }


  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-t-we1xlf.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendPort"
    host_name                      = "test-xlf.montelnews.com"
    name                           = "listener_t-we1xlf_http_test-xlf.montelnews.com"
    protocol                       = "Http"
  }
  http_listener {
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy-t-we1xlf.id
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendHttpsPort"
    host_name                      = "test-xlf.montelnews.com"
    name                           = "listener_t-we1xlf_https_test-xlf.montelnews.com"
    protocol                       = "Https"
    ssl_certificate_name           = "https-star-montelnews-com"
  }


  redirect_configuration {
    include_path         = true
    include_query_string = true
    name                 = "redirect_t-we1xlf_http_test-xlf.montelnews.com"
    redirect_type        = "Permanent"
    target_listener_name = "listener_t-we1xlf_https_test-xlf.montelnews.com"
  }

}



################################################
#  Application Gateway diagnostics
################################################

resource "azurerm_monitor_diagnostic_setting" "AppGateway2" {
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
