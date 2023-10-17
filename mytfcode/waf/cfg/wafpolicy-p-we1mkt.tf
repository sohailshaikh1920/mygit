################################################
#  WAF Policy - p-we1mkt
################################################

resource "azurerm_web_application_firewall_policy" "wafpolicy-p-we1mkt" {
  name                = "${azurerm_resource_group.public.name}-waf02-p-we1mkt-waf"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.public.name

  policy_settings {
    mode = var.wafpolicy-p-we1mkt-policy_settings-mode
  }

  managed_rules {
    managed_rule_set {
      version = var.wafpolicy-p-we1mkt-managed_rules-managed_rule_set-version
      rule_group_override {
        rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
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
          id      = "920420"
          enabled = false
          action  = "AnomalyScoring"
        }
      }
      rule_group_override {
        rule_group_name = "REQUEST-933-APPLICATION-ATTACK-PHP"
        rule {
          id      = "933120"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "933140"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "933150"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "933160"
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
          id      = "932110"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "932130"
          enabled = false
          action  = "AnomalyScoring"
        }
      }
      rule_group_override {
        rule_group_name = "REQUEST-930-APPLICATION-ATTACK-LFI"
        rule {
          id      = "930100"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "930110"
          enabled = false
          action  = "AnomalyScoring"
        }
      }
      rule_group_override {
        rule_group_name = "REQUEST-921-PROTOCOL-ATTACK"
        rule {
          id      = "921150"
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
        rule_group_name = "General"
        rule {
          id      = "200002"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "200003"
          enabled = false
          action  = "AnomalyScoring"
        }
      }
    }
  }
}
