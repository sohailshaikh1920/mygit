################################################
#  WAF Policy - p-we1mwa
################################################

resource "azurerm_web_application_firewall_policy" "wafpolicy-p-we1mwa" {
  name                = "${azurerm_resource_group.public.name}-waf01-p-we1mwa-waf"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.public.name

  policy_settings {
    mode = var.wafpolicy-p-we1mwa-policy_settings-mode
  }

  managed_rules {
    managed_rule_set {
      version = var.wafpolicy-t-we1mwa-managed_rules-managed_rule_set-version
      rule_group_override {
        rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
        rule {
          id      = "942110"
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
          id      = "942330"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942340"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942350"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942390"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942400"
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
      }
      rule_group_override {
        rule_group_name = "REQUEST-932-APPLICATION-ATTACK-RCE"
        rule {
          id      = "932105"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "932115"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "932140"
          enabled = false
          action  = "AnomalyScoring"
        }
      }
      rule_group_override {
        rule_group_name = "REQUEST-930-APPLICATION-ATTACK-LFI"
        rule {
          id      = "930130"
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
          id      = "920170"
          enabled = false
          action  = "AnomalyScoring"
        }
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
          id      = "920420"
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
      rule_group_override {
        rule_group_name = "General"
      }
    }
  }
}
