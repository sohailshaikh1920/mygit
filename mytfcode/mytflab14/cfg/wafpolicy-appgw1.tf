################################################
#  WAF Policy - AppGw1
################################################

resource "azurerm_web_application_firewall_policy" "wafpolicy-appgw1" {
  name                = "pwe1wafpubwaf01policy"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.public.name

  policy_settings {
    mode = var.wafpolicy-appgw1-policy_settings-mode
  }

  managed_rules {
    managed_rule_set {
      version = var.wafpolicy-appgw1-managed_rules-managed_rule_set-version
    }
  }
}
