################################################
#  WAF Policy - p-we1mo
################################################

variable "wafpolicy-p-we1mo-policy_settings-mode" {
  type        = string
  description = "Describes if it is in detection mode or prevention mode at the policy level."
}

variable "wafpolicy-p-we1mo-policy_settings-max_request_body_size_in_kb" {
  type        = number
  description = "The Maximum Request Body Size in KB."
}

variable "wafpolicy-p-we1mo-managed_rules-managed_rule_set-version" {
  type        = string
  description = "The rule set version."
}
