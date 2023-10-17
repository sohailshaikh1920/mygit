##################################################
#  Azure Automation Account 1 Schedule 1
##################################################

variable "aib-automationrunbook-schedule1-name" {
  type        = string
  description = "The name of the schedule"
}

variable "aib-automationrunbook-schedule1-frequency" {
  type        = string
  description = "The period of time that a runbook can repeat"
}

variable "aib-automationrunbook-schedule1-month_days" {
  type        = list(number)
  description = "The day of month that a runbook will execute"
}

variable "aib-automationrunbook-schedule1-timezone" {
  type        = string
  description = "The timezone used for the schedule"
}
