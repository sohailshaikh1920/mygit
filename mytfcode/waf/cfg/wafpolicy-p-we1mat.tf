################################################
#  WAF Policy - p-we1mat
################################################

resource "azurerm_web_application_firewall_policy" "wafpolicy-p-we1mat" {
  name                = "${azurerm_resource_group.public.name}-waf02-p-we1mat-waf"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.public.name

  policy_settings {
    mode = var.wafpolicy-p-we1mat-policy_settings-mode
  }

  managed_rules {
    managed_rule_set {
      version = var.wafpolicy-p-we1mat-managed_rules-managed_rule_set-version
      rule_group_override {
        rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
        rule {
          id      = "942100"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942110"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942440"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942450"
          enabled = false
          action  = "AnomalyScoring"
        }
      }
    }
  }
}
