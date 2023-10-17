##################################################
#  Automation Account 1 Runbook 3
##################################################

resource "azurerm_automation_runbook" "build-image-template2" {
  automation_account_name = azurerm_automation_account.aib-automation-account.name
  content                 = "<#\r\n    .DESCRIPTION\r\n        A runbook to trigger the creation of a new image version from an existing Azure Image Builder image template.\r\n\r\n    .NOTES\r\n        AUTHOR: Aidan Finn, Innofactor\r\n        LASTEDIT: 17, February, 2023\r\n#>\r\n\r\n\r\n##########################\r\n##### Standard login #####\r\n##########################\r\n\r\n\"Please enable appropriate RBAC permissions to the system identity of this automation account. Otherwise, the runbook may fail...\"\r\n\r\ntry\r\n{\r\n    \"Logging in to Azure...\"\r\n    Connect-AzAccount -Identity\r\n}\r\ncatch {\r\n    Write-Error -Message $_.Exception\r\n    throw $_.Exception\r\n}\r\n\r\n\r\n###########################\r\n##### Start of script #####\r\n###########################\r\n\r\n$subId = \"${var.subscriptionid}\"\r\n$imageResourceGroup = \"${azurerm_resource_group.aib-resource-group.name}\"\r\n$imageTemplateName = \"${azurerm_resource_group.aib-resource-group.name}-${var.aib-imagedefinition2-definition-name}-it\"\r\n\r\nWrite-Output \"Attempting to select the subscription\"...\r\ntry\r\n{\r\n    Select-AzSubscription -SubscriptionId $subId\r\n}\r\ncatch\r\n{\r\n    Write-Output \"There was an error selecting the subcsription!\"\r\n    Break\r\n}\r\n\r\n\r\nWrite-Output \"Attempting to start the image version build\"...\r\ntry\r\n{\r\n    Start-AzImageBuilderTemplate -ResourceGroupName $imageResourceGroup -Name $imageTemplateName\r\n}\r\ncatch\r\n{\r\n    Write-Output \"There was an error starting the image version creation!\"\r\n    Break\r\n}\r\n\r\nWrite-Output \"End of runbook\"\r\n"
  location                = var.location
  log_progress            = false
  log_verbose             = false
  name                    = "${azurerm_resource_group.aib-resource-group.name}-${var.aib-imagedefinition2-definition-name}-it-build-rb"
  resource_group_name     = azurerm_resource_group.aib-resource-group.name
  runbook_type            = "PowerShell"
}


##################################################
#  Shcedule the Azure Automation Runbook
##################################################

resource "azurerm_automation_job_schedule" "schedule-build-image-template2" {
  automation_account_name = azurerm_automation_account.aib-automation-account.name
  resource_group_name     = azurerm_resource_group.aib-resource-group.name
  runbook_name            = azurerm_automation_runbook.build-image-template2.name
  schedule_name           = azurerm_automation_schedule.schedule1.name
}
