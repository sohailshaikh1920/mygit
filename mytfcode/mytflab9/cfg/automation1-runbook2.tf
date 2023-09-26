##################################################
#  Automation Account 1 Runbook 2
##################################################

resource "azurerm_automation_runbook" "check-vmms1-instance-version" {
  automation_account_name = azurerm_automation_account.aib-automation-account.name
  content                 = "<#\r\n    .DESCRIPTION\r\n        A runbook to find the instance version of each VMSS instance.\r\n\r\n    .NOTES\r\n        AUTHOR: Aidan Finn, Innofactor\r\n        LASTEDIT: 17, February, 2023\r\n#>\r\n\r\n\r\n##########################\r\n##### Standard login #####\r\n##########################\r\n\r\n\"Please enable appropriate RBAC permissions to the system identity of this automation account. Otherwise, the runbook may fail...\"\r\n\r\ntry\r\n{\r\n    \"Logging in to Azure...\"\r\n    Connect-AzAccount -Identity\r\n}\r\ncatch {\r\n    Write-Error -Message $_.Exception\r\n    throw $_.Exception\r\n}\r\n\r\n\r\n###########################\r\n##### Start of script #####\r\n###########################\r\n\r\n$subId = \"${var.subscriptionid}\"\r\n$ResourceGroup = \"${azurerm_resource_group.workload.name}\"\r\n$Vmss = \"${azurerm_linux_virtual_machine_scale_set.vmss1.name}\"\r\n\r\nWrite-Output \"Attempting to select the subscription ...\"\r\ntry\r\n{\r\n    Select-AzSubscription -SubscriptionId $subId\r\n}\r\ncatch\r\n{\r\n    Write-Output \"There was an error selecting the subcsription!\"\r\n    Break\r\n}\r\n\r\n\r\nWrite-Output \"Attempting to query the VMSS ...\"\r\ntry\r\n{\r\n    $Instances = Get-AzVmssVM -ResourceGroupName $ResourceGroup -Name $Vmss\r\n    Write-Output \"Instance image versions of VMMS: $Vmss\"\r\n}\r\ncatch\r\n{\r\n    Write-Output \"There was an error finding the VMSS!\"\r\n    Break\r\n}\r\n\r\n\r\nWrite-Output \"Attempting to query ExactVersion of each VMSS instance ...\"\r\ntry\r\n{\r\n    foreach ($Instance in $Instances)\r\n    {\r\n        $InstanceInfo = (Get-AzVmssVM -ResourceGroupName $ResourceGroup -Name $Vmss -InstanceId $Instance.instanceId).StorageProfile.ImageReference.ExactVersion\r\n        $Id = $Instance.instanceId\r\n        Write-Output \"Instance $Id - $InstanceInfo\"\r\n    }\r\n}\r\ncatch\r\n{\r\n    Write-Output \"There was an error getting the ExactVersion of the VMSS instances!\"\r\n    Break\r\n}\r\n\r\nWrite-Output \"End of runbook\"\r\n"
  location                = var.location
  log_progress            = false
  log_verbose             = false
  name                    = "${azurerm_linux_virtual_machine_scale_set.vmss1.name}-check-model-version-rb"
  resource_group_name     = azurerm_resource_group.aib-resource-group.name
  runbook_type            = "PowerShell"
}
