################################################
#  WAF Policy - AppGw1
################################################

variable "wafpolicy-appgw1-policy_settings-mode" {
  type        = string
  description = "Describes if it is in detection mode or prevention mode at the policy level."
}

variable "wafpolicy-appgw1-managed_rules-managed_rule_set-version" {
  type        = string
  description = "The rule set version."
}
