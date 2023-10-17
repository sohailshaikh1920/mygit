################################################
#  WAF Policy - p-we1nml
################################################

variable "wafpolicy-p-we1nml-policy_settings-mode" {
  type        = string
  description = "Describes if it is in detection mode or prevention mode at the policy level."
}

variable "wafpolicy-p-we1nml-managed_rules-managed_rule_set-version" {
  type        = string
  description = "The rule set version."
}
