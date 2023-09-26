################################################
#  WAF Policy - p-we1nml
################################################

resource "azurerm_web_application_firewall_policy" "wafpolicy-p-we1nml" {
  name                = "${azurerm_resource_group.public.name}-waf02-p-we1nml-waf"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.public.name

  policy_settings {
    mode = var.wafpolicy-p-we1nml-policy_settings-mode
  }

  managed_rules {
    managed_rule_set {
      version = var.wafpolicy-p-we1nml-managed_rules-managed_rule_set-version
    }
  }
}
