################################################
#  WAF Policy - t-we1ase
################################################

resource "azurerm_web_application_firewall_policy" "wafpolicy-t-we1ase" {
  name                = "${azurerm_resource_group.public.name}-waf01-t-we1ase-waf"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.public.name

  policy_settings {
    mode = var.wafpolicy-t-we1ase-policy_settings-mode
  }

  managed_rules {
    managed_rule_set {
      version = var.wafpolicy-t-we1ase-managed_rules-managed_rule_set-version
    }
  }
}
