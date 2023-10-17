################################################
#  WAF Policy - p-we1npn
################################################

resource "azurerm_web_application_firewall_policy" "wafpolicy-p-we1npn" {
  name                = "${azurerm_resource_group.public.name}-waf02-p-we1npn-waf"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.public.name

  policy_settings {
    mode = var.wafpolicy-p-we1npn-policy_settings-mode
  }

  managed_rules {
    managed_rule_set {
      version = var.wafpolicy-p-we1npn-managed_rules-managed_rule_set-version
      rule_group_override {
        rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
        rule {
          id      = "920320"
          enabled = false
          action  = "AnomalyScoring"
        }
      }
      rule_group_override {
        rule_group_name = "REQUEST-931-APPLICATION-ATTACK-RFI"
        rule {
          id      = "931130"
          enabled = false
          action  = "AnomalyScoring"
        }
      }
    }
  }
}
