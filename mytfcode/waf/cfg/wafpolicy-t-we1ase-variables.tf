################################################
#  WAF Policy - t-we1ase
################################################

variable "wafpolicy-t-we1ase-policy_settings-mode" {
  type        = string
  description = "Describes if it is in detection mode or prevention mode at the policy level."
}

variable "wafpolicy-t-we1ase-managed_rules-managed_rule_set-version" {
  type        = string
  description = "The rule set version."
}
