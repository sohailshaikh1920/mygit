################################################
#  WAF Policy - p-alert
################################################

resource "azurerm_web_application_firewall_policy" "wafpolicy-p-alert" {
  name                = "${azurerm_resource_group.public.name}-waf02-p-alert-waf"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.public.name

  policy_settings {
    mode = var.wafpolicy-p-alert-policy_settings-mode
  }

  managed_rules {
    managed_rule_set {
      version = var.wafpolicy-p-alert-managed_rules-managed_rule_set-version
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
      rule_group_override {
        rule_group_name = "REQUEST-913-SCANNER-DETECTION"
        rule {
          id      = "913101"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "913102"
          enabled = false
          action  = "AnomalyScoring"
        }
      }
      rule_group_override {
        rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
        rule {
          id      = "942110"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942120"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942130"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942150"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942220"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942410"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942440"
          enabled = false
          action  = "AnomalyScoring"
        }
      }
      rule_group_override {
        rule_group_name = "REQUEST-933-APPLICATION-ATTACK-PHP"
        rule {
          id      = "933100"
          enabled = false
          action  = "AnomalyScoring"
        }
      }
      rule_group_override {
        rule_group_name = "REQUEST-930-APPLICATION-ATTACK-LFI"
        rule {
          id      = "930120"
          enabled = false
          action  = "AnomalyScoring"
        }
      }
    }
  }
}
