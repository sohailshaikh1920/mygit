################################################
#  WAF Policy - p-we1ncv
################################################

variable "wafpolicy-p-we1ncv-policy_settings-mode" {
  type        = string
  description = "Describes if it is in detection mode or prevention mode at the policy level."
}

variable "wafpolicy-p-we1ncv-managed_rules-managed_rule_set-version" {
  type        = string
  description = "The rule set version."
}
