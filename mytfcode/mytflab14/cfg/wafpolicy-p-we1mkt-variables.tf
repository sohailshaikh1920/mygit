################################################
#  WAF Policy - p-we1mkt
################################################

variable "wafpolicy-p-we1mkt-policy_settings-mode" {
  type        = string
  description = "Describes if it is in detection mode or prevention mode at the policy level."
}

variable "wafpolicy-p-we1mkt-managed_rules-managed_rule_set-version" {
  type        = string
  description = "The rule set version."
}
