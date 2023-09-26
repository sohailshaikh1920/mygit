######################################################
# Create Alerts
######################################################
resource "azurerm_monitor_metric_alert" "plan1-function1-average-memory-working-set" { // The Alert rule is set to trigger the alret for average amount of memory used by the function app(s), in megabytes (MiB)
  name                = "${var.subscriptionname}-plan1-function1 average memory working set"
  description         = "Average memory working set"
  resource_group_name = azurerm_resource_group.workload.name
  scopes              = [azurerm_windows_function_app.plan1-function1.id]
  severity            = 2
  window_size         = "PT5M"
  frequency           = "PT5M"

  criteria {
    aggregation      = "Average"
    metric_name      = "AverageMemoryWorkingSet"
    metric_namespace = "Microsoft.Web/sites"
    operator         = "GreaterThan"
    threshold        = 500000000
    dimension {
      name     = "Instance"
      operator = "Include"
      values   = ["*"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.ops-warning.id
  }
}


resource "azurerm_monitor_metric_alert" "plan1-function1-function-execution-count" { // This Alert rule is set to trigger the alert for Function Execution Count greater than 2500 value.
  name                = "${var.subscriptionname}-plan1-function1 function execution count"
  description         = "Function Execution Count"
  resource_group_name = azurerm_resource_group.workload.name
  scopes              = [azurerm_windows_function_app.plan1-function1.id]
  severity            = 2
  window_size         = "PT5M"
  frequency           = "PT5M"

  criteria {
    aggregation      = "Total"
    metric_name      = "FunctionExecutionCount"
    metric_namespace = "Microsoft.Web/sites"
    operator         = "GreaterThan"
    threshold        = 2500
    dimension {
      name     = "Instance"
      operator = "Include"
      values   = ["*"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.ops-warning.id
  }
}

resource "azurerm_monitor_metric_alert" "plan1-function1-response-time" { // This Alert rule is set to trigger the alert for actual the time taken for the app to serve requests, in seconds.
  name                = "${var.subscriptionname}-plan1-function1 response time"
  description         = "Function Execution Count"
  resource_group_name = azurerm_resource_group.workload.name
  scopes              = [azurerm_windows_function_app.plan1-function1.id]
  severity            = 2
  window_size         = "PT5M"
  frequency           = "PT5M"

  criteria {
    aggregation      = "Average"
    metric_name      = "HttpResponseTime"
    metric_namespace = "Microsoft.Web/sites"
    operator         = "GreaterThan"
    threshold        = 20
    dimension {
      name     = "Instance"
      operator = "Include"
      values   = ["*"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.ops-warning.id
  }
}

resource "azurerm_monitor_activity_log_alert" "plan1-function1-restart-web-app" { // The Alert rule is set to trigger the activity logs when the function app(s) restart
  name                = "${var.subscriptionname}-plan1-function1 restart web app"
  description         = "Restart Web App"
  resource_group_name = azurerm_resource_group.workload.name
  scopes              = [azurerm_windows_function_app.plan1-function1.id]

  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.Web/sites/restart/Action"
  }

  action {
    action_group_id = azurerm_monitor_action_group.ops-critical.id
  }
}

resource "azurerm_monitor_activity_log_alert" "plan1-function1-stop-web-app" { // The Alert rule is set to trigger the activity logs when the function app(s) stop
  name                = "${var.subscriptionname}-plan1-function1 stop web app"
  description         = "Stop Web App"
  resource_group_name = azurerm_resource_group.workload.name
  scopes              = [azurerm_windows_function_app.plan1-function1.id]

  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.Web/sites/stop/Action"
  }

  action {
    action_group_id = azurerm_monitor_action_group.ops-critical.id
  }
}

resource "azurerm_monitor_metric_alert" "plan1-CPU-utilization" { // The Alert rule is set to trigger the alert when CPU Utilization greather than 90% by the function app(s)
  name                = "${var.subscriptionname}-plan1 CPU utilization"
  resource_group_name = azurerm_resource_group.workload.name
  scopes              = [azurerm_service_plan.plan1.id]
  description         = "CPU utilization has exceeded normal high levels."
  severity            = 2
  window_size         = "PT5M"
  frequency           = "PT5M"

  criteria {
    metric_namespace = "Microsoft.Web/serverFarms"
    metric_name      = "CpuPercentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 90
  }

  action {
    action_group_id = azurerm_monitor_action_group.ops-warning.id
  }
}

resource "azurerm_monitor_metric_alert" "plan1-Memory-utilization" { // The Alert rule is set to trigger the alert when Memory Utilization greather than 90% by the function app(s)
  name                = "${var.subscriptionname}-plan1 Memory utilization"
  resource_group_name = azurerm_resource_group.workload.name
  scopes              = [azurerm_service_plan.plan1.id]
  description         = "Memory utilization has exceeded normal high levels."
  severity            = 2
  window_size         = "PT5M"
  frequency           = "PT5M"

  criteria {
    metric_namespace = "Microsoft.Web/serverFarms"
    metric_name      = "MemoryPercentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 90
  }

  action {
    action_group_id = azurerm_monitor_action_group.ops-warning.id
  }
}

resource "azurerm_monitor_activity_log_alert" "plan1-resource-health" { // The Alert rule is set to trigger the alert for Resource health check for function app(s)
  name                = "${var.subscriptionname}-plan1- resource health"
  resource_group_name = azurerm_resource_group.workload.name
  scopes              = [azurerm_service_plan.plan1.id]
  description         = "Resource health"

  criteria {
    category = "ResourceHealth"
  }

  action {
    action_group_id = azurerm_monitor_action_group.ops-warning.id
  }
}