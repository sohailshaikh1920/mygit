################################################
#  WAF Policy - p-we1adm
################################################

variable "wafpolicy-p-we1adm-policy_settings-mode" {
  type        = string
  description = "Describes if it is in detection mode or prevention mode at the policy level."
}

variable "wafpolicy-p-we1adm-managed_rules-managed_rule_set-version" {
  type        = string
  description = "The rule set version."
}
