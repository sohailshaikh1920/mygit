################################################
#  WAF Policy - t-we1xlf
################################################

resource "azurerm_web_application_firewall_policy" "wafpolicy-t-we1xlf" {
  name                = "${azurerm_resource_group.public.name}-waf02-t-we1xlf-waf"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.public.name

  policy_settings {
    mode = var.wafpolicy-t-we1xlf-policy_settings-mode
  }

  managed_rules {
    managed_rule_set {
      version = var.wafpolicy-t-we1xlf-managed_rules-managed_rule_set-version
      rule_group_override {
        rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
        rule {
          id      = "942100"
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
          id      = "942200"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942210"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942260"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942340"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942370"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942430"
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
      rule_group_override {
        rule_group_name = "REQUEST-941-APPLICATION-ATTACK-XSS"
        rule {
          id      = "941100"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "941120"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "941180"
          enabled = false
          action  = "AnomalyScoring"
        }
      }
      rule_group_override {
        rule_group_name = "REQUEST-933-APPLICATION-ATTACK-PHP"
        rule {
          id      = "933210"
          enabled = false
          action  = "AnomalyScoring"
        }
      }
      rule_group_override {
        rule_group_name = "REQUEST-932-APPLICATION-ATTACK-RCE"
        rule {
          id      = "932100"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "932105"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "932110"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "932115"
          enabled = false
          action  = "AnomalyScoring"
        }
      }
      rule_group_override {
        rule_group_name = "REQUEST-921-PROTOCOL-ATTACK"
        rule {
          id      = "921151"
          enabled = false
          action  = "AnomalyScoring"
        }
      }
      rule_group_override {
        rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
        rule {
          id      = "920230"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "920300"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "920320"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "920340"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "920341"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "920440"
          enabled = false
          action  = "AnomalyScoring"
        }
      }
    }
  }
}
