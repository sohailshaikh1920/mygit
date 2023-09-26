automation_runbooks = {
  runbook1 = {
    name                   = "Get-AzureVMTutorial"
    resource_group_key     = "mgt_auto"
    automation_account_key = "mgt_auto"
    log_verbose            = "true"
    log_progress           = "true"
    description            = "This is an example runbook"
    runbook_type           = "PowerShellWorkflow"
    publish_content_link = {
      uri = "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/c4935ffb69246a6058eb24f54640f53f69d3ac9f/101-automation-runbook-getvms/Runbooks/Get-AzureVMTutorial.ps1"
    }
  }
}
