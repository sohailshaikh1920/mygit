################################################
#  WAF Policy - t-we1xlf
################################################

variable "wafpolicy-t-we1xlf-policy_settings-mode" {
  type        = string
  description = "Describes if it is in detection mode or prevention mode at the policy level."
}

variable "wafpolicy-t-we1xlf-managed_rules-managed_rule_set-version" {
  type        = string
  description = "The rule set version."
}
