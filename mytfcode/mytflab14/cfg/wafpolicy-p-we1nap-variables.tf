################################################
#  WAF Policy - p-we1nap
################################################

variable "wafpolicy-p-we1nap-policy_settings-mode" {
  type        = string
  description = "Describes if it is in detection mode or prevention mode at the policy level."
}

variable "wafpolicy-p-we1nap-managed_rules-managed_rule_set-version" {
  type        = string
  description = "The rule set version."
}
