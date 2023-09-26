######################################################
#  Actions Groups
######################################################


variable "budget_incident_email" {
  type        = string
  description = "Email address for budget incidents"
}

variable "ops-critical_incident_email" {
  type        = string
  description = "Email address for critical operations incidents"
}

variable "ops-error_incident_email" {
  type        = string
  description = "Email address for error operations incidents"
}

variable "ops-warning_incident_email" {
  type        = string
  description = "Email address for warning operations incidents"
}

variable "ops-info_incident_email" {
  type        = string
  description = "Email address for informational operations incidents"
}

