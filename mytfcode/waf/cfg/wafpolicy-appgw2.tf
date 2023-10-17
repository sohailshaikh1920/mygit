################################################
#  WAF Policy - AppGw2
################################################

resource "azurerm_web_application_firewall_policy" "wafpolicy-appgw2" {
  name                = "pwe1wafpubwaf02policy"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.public.name

  policy_settings {
    mode = var.wafpolicy-appgw2-policy_settings-mode
  }

  managed_rules {
    managed_rule_set {
      version = var.wafpolicy-appgw2-managed_rules-managed_rule_set-version
    }
  }
}
