automation_schedules = {
  schedule1 = {
    name                   = "tfex-automation-schedule"
    resource_group_key     = "mgt_auto"
    automation_account_key = "mgt_auto"
    frequency              = "Week"
    interval               = 1
    timezone               = "Europe/Dublin"
    start_time             = "2025-04-15T18:00:15+02:00"
    description            = "This is an example schedule"
    week_days              = ["Friday"]
  }
}