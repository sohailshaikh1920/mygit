################################################
#  Deploy consumption budget on subscription
################################################

locals {
  firstdayinmonth = formatdate("YYYY-MM-01", timestamp()) # Gets the current year and month and set the first as the start date
  threshold       = 100                                   # Forecasted threshold to alert on.
}
resource "azurerm_consumption_budget_subscription" "budget" {
  name            = "${var.subscriptionname}-budget"
  subscription_id = "/subscriptions/${var.subscriptionid}"
  amount          = var.budget
  time_grain      = "Monthly"
  lifecycle {
    ignore_changes = [
      time_period
    ]
  }
  time_period {
    start_date = "${local.firstdayinmonth}T00:00:00Z"
    end_date   = "2050-12-01T00:00:00Z"
  }
  notification {
    enabled        = true
    threshold      = local.threshold
    operator       = "GreaterThan"
    threshold_type = "Forecasted"
    contact_emails = [
      var.budget_alert_email
    ]
  }
}
