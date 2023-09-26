################################################
#  WAF Policy - t-we1mo
################################################

resource "azurerm_web_application_firewall_policy" "wafpolicy-t-we1mo" {
  name                = "${azurerm_resource_group.public.name}-waf02-t-we1mo-waf"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.public.name

  policy_settings {
    mode = var.wafpolicy-t-we1mo-policy_settings-mode
  }

  managed_rules {
    managed_rule_set {
      version = var.wafpolicy-p-we1mo-managed_rules-managed_rule_set-version
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
          id      = "942160"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942170"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942180"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942190"
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
          id      = "942220"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942240"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942260"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942270"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942280"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942300"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942310"
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
          id      = "942360"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942361"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942370"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942380"
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
          id      = "942410"
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
        rule {
          id      = "942470"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "942480"
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
          id      = "941110"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "941120"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "941130"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "941140"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "941150"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "941160"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "941170"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "941180"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "941190"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "941210"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "941260"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "941270"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "941320"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "941330"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "941340"
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
        rule {
          id      = "932130"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "932140"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "932160"
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
        rule {
          id      = "930120"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "930130"
          enabled = false
          action  = "AnomalyScoring"
        }
      }
      rule_group_override {
        rule_group_name = "REQUEST-921-PROTOCOL-ATTACK"
        rule {
          id      = "921130"
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
          id      = "920220"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "920230"
          enabled = false
          action  = "AnomalyScoring"
        }
        rule {
          id      = "920240"
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
          id      = "920330"
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
        rule {
          id      = "920440"
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
    }
  }
}
