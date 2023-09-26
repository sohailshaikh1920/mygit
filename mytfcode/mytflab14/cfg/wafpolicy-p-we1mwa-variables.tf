################################################
#  WAF Policy - p-we1mwa
################################################

variable "wafpolicy-p-we1mwa-policy_settings-mode" {
  type        = string
  description = "Describes if it is in detection mode or prevention mode at the policy level."
}

variable "wafpolicy-p-we1mwa-managed_rules-managed_rule_set-version" {
  type        = string
  description = "The rule set version."
}
