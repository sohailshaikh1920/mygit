################################################
#  WAF Policy - p-we1adm
################################################

resource "azurerm_web_application_firewall_policy" "wafpolicy-p-we1adm" {
  name                = "${azurerm_resource_group.public.name}-waf02-p-we1adm-waf"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.public.name

  policy_settings {
    mode = var.wafpolicy-p-we1adm-policy_settings-mode
  }

  managed_rules {
    managed_rule_set {
      version = var.wafpolicy-p-we1adm-managed_rules-managed_rule_set-version
      rule_group_override {
        rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
        rule {
          id      = "920320"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "920300"
          enabled = false
          action  = "AnomalyScoring"
        }
      }
    }
  }
}
