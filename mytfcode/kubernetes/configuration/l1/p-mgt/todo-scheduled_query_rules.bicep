// Add a alert rule if the log analytics workspace daily data cap has been reached.
// Logging costs can be a significant part of any architecture, and putting a cap on
// a logging sink (none of which are applied here), can help keep costs in check but
// you run a risk of losing critical data.

resource sqrDailyDataCapBreach 'Microsoft.Insights/scheduledQueryRules@2018-04-16' = {
  name: 'Daily data cap breached for workspace ${laAks.name} CIQ-1'
  location: location
  properties: {
    description: 'This alert monitors daily data cap defined on a workspace and fires when the daily data cap is breached.'
    displayName: 'Daily data cap breached for workspace ${laAks.name} CIQ-1'
    enabled: 'true'
    source: {
      dataSourceId: laAks.id
      queryType: 'ResultCount'
      authorizedResources: []
      query: '_LogOperation | where Operation == "Data collection Status" | where Detail contains "OverQuota"'
    }
    schedule: {
      frequencyInMinutes: 5
      timeWindowInMinutes: 5
    }
    action: {
      'odata.type': 'Microsoft.WindowsAzure.Management.Monitoring.Alerts.Models.Microsoft.AppInsights.Nexus.DataContracts.Resources.ScheduledQueryRules.AlertingAction'
      severity: '1'
      aznsAction: {
        actionGroup: []
      }
      throttlingInMin: 1440
      trigger: {
        threshold: 0
        thresholdOperator: 'GreaterThan'
      }
    }
  }
}