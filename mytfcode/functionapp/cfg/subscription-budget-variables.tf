##################################################
#  Workload budget
##################################################

variable "budget" {
  type        = number
  description = "The Euro/€ budget for this workload per month"
}


variable "budget_alert_email" {
  type        = string
  description = "Email address for budget alerts"
}


variable "budget_alert_email_locale" {
  type        = string
  default     = "Norwegian"
  description = "The Locale for budget alerts"
}