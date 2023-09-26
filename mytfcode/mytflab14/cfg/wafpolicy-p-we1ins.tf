################################################
#  WAF Policy - p-we1ins
################################################

resource "azurerm_web_application_firewall_policy" "wafpolicy-p-we1ins" {
  name                = "${azurerm_resource_group.public.name}-waf02-p-we1ins-waf"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.public.name

  policy_settings {
    mode = var.wafpolicy-p-we1ins-policy_settings-mode
  }

  managed_rules {
    managed_rule_set {
      version = var.wafpolicy-p-we1ins-managed_rules-managed_rule_set-version
      rule_group_override {
        rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
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
          id      = "920230"
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
      }
      rule_group_override {
        rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
        rule {
          id      = "942480"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942430"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942120"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942370"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942210"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942140"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942150"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942310"
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
        rule {
          id      = "942200"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942300"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942130"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942260"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942180"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942340"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942450"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942360"
          enabled = false
          action  = "AnomalyScoring"
        }
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
          id      = "942350"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942380"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942190"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942270"
          enabled = false
          action  = "AnomalyScoring"
        }
      }
      rule_group_override {
        rule_group_name = "REQUEST-941-APPLICATION-ATTACK-XSS"
        rule {
          id      = "941330"
          enabled = false
          action  = "AnomalyScoring"
        }
      }
      rule_group_override {
        rule_group_name = "REQUEST-932-APPLICATION-ATTACK-RCE"
        rule {
          id      = "932115"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "932100"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "932150"
          enabled = false
          action  = "AnomalyScoring"
        }
      }
    }
  }
}
