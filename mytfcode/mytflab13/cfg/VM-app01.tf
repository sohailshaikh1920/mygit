################################################
# VM Name
################################################
variable "app01" {
  type    = string
  default = "app01"
}



################################################
# Create Random Password
################################################
resource "random_password" "app01password" {
  length      = 16
  min_lower   = 4
  min_upper   = 4
  min_numeric = 4
  special     = false
}



################################################
# Create Network Inferface
################################################
resource "azurerm_network_interface" "app01" {
  name                          = "${var.subscriptionname}-${var.app01}-nic00"
  location                      = azurerm_resource_group.primary.location
  resource_group_name           = azurerm_resource_group.primary.name
  enable_accelerated_networking = true
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.frontendsubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost("${azurerm_subnet.frontendsubnet.address_prefixes[0]}", 4)
  }
}

################################################
# Associate NIC to app01 ASG
################################################
resource "azurerm_network_interface_application_security_group_association" "app" {
  network_interface_id          = azurerm_network_interface.app01.id
  application_security_group_id = azurerm_application_security_group.app.id
}




################################################
# Create VM
################################################

resource "azurerm_windows_virtual_machine" "app01" {
  name                         = "${var.subscriptionname}-${var.app01}"
  resource_group_name          = azurerm_resource_group.primary.name
  location                     = azurerm_resource_group.primary.location
  size                         = "Standard_F4s_v2"
  admin_username               = "sysadmin"
  admin_password               = random_password.app01password.result
  timezone                     = "W. Europe Standard Time"
  availability_set_id          = azurerm_availability_set.app.id
  network_interface_ids = [
    azurerm_network_interface.app01.id,
  ]
  boot_diagnostics {
  }

  os_disk {
    name                 = "${var.subscriptionname}-${var.app01}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-gensecond"
    version   = "latest"
  }
    tags = {
    Updates = "WE, W6, 23, Windows"
  }
}

################################################
#  Create Availibility Group
################################################
resource "azurerm_availability_set" "app" {
  name                = "${var.subscriptionname}-app-as"
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name
}

################################################
# Add secrets to Key Vault
################################################
resource "azurerm_key_vault_secret" "app01login" {
  name         = "${var.app01}-LocalAdminLogin"
  value        = azurerm_windows_virtual_machine.app01.admin_username
  key_vault_id = azurerm_key_vault.keyvault.id
  depends_on = [
    azurerm_key_vault_access_policy.keyvault
  ]
}
resource "azurerm_key_vault_secret" "app01password" {
  name         = "${var.app01}-LocalAdminPassword"
  value        = random_password.app01password.result
  key_vault_id = azurerm_key_vault.keyvault.id
  depends_on = [
    azurerm_key_vault_access_policy.keyvault
  ]
}


#############################################################################################################################
# VM Extensions Settings
#############################################################################################################################
resource "azurerm_virtual_machine_extension" "MicrosoftMonitoringAgent_app01" {
  name                 = "MicrosoftMonitoringAgent"
  virtual_machine_id   = azurerm_windows_virtual_machine.app01.id
  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  type                 = "MicrosoftMonitoringAgent"
  type_handler_version = "1.0"

  settings = <<SETTINGS
        {
          "workspaceId": "${data.azurerm_log_analytics_workspace.central.workspace_id}"
        }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
        {
          "workspaceKey": "${data.azurerm_log_analytics_workspace.central.primary_shared_key}"
        }
  PROTECTED_SETTINGS
}


resource "azurerm_virtual_machine_extension" "IaaSAntimalware_app01" {
  name                 = "IaaSAntimalware"
  virtual_machine_id   = azurerm_windows_virtual_machine.app01.id
  publisher            = "Microsoft.Azure.Security"
  type                 = "IaaSAntimalware"
  type_handler_version = "1.5"

  settings = <<SETTINGS
        {
          "AntimalwareEnabled": true,
          "RealtimeProtectionEnabled": "true",
          "ScheduledScanSettings": {
            "isEnabled": "true",
            "day": "7",
            "time": "120",
            "scanType": "Quick"
            }
        }
SETTINGS
}


resource "azurerm_virtual_machine_extension" "ConfigurationforWindows_app01" {
  name                 = "ConfigurationforWindows"
  virtual_machine_id   = azurerm_windows_virtual_machine.app01.id
  publisher            = "Microsoft.GuestConfiguration"
  type                 = "ConfigurationforWindows"
  type_handler_version = "1.29"
}


resource "azurerm_virtual_machine_extension" "DependencyAgent_app01" {
  name                       = "DependencyAgentWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.app01.id
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = "DependencyAgentWindows"
  type_handler_version       = "9.10"
  auto_upgrade_minor_version = true
}


resource "azurerm_virtual_machine_extension" "IaaSDiagnostics_app01" {
  name = "IaaSDiagnostics"

  publisher                  = "Microsoft.Azure.Diagnostics"
  type                       = "IaaSDiagnostics"
  type_handler_version       = "1.17"
  auto_upgrade_minor_version = "true"

  virtual_machine_id = azurerm_windows_virtual_machine.app01.id

  settings = templatefile(format("%s/vmextensions/IaasDiagnostics.json", path.module), {
    resource_id  = azurerm_windows_virtual_machine.app01.id
    storage_name = azurerm_storage_account.vm_diagnostics.name
  })

  protected_settings = <<SETTINGS
  {
    "storageAccountName": "${azurerm_storage_account.vm_diagnostics.name}",
    "storageAccountKey": "${azurerm_storage_account.vm_diagnostics.primary_access_key}"
  }
SETTINGS
}



resource "azurerm_virtual_machine_extension" "NetworkWatcher_app01" {
  name                       = "NetworkWatcherAgentWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.app01.id
  publisher                  = "Microsoft.Azure.NetworkWatcher"
  type                       = "NetworkWatcherAgentWindows"
  type_handler_version       = "1.4"
  auto_upgrade_minor_version = true
}



#############################################################################################################################
# Alerts
#############################################################################################################################
resource "azurerm_monitor_metric_alert" "app01-CPU-credits" {
  name                = "${var.subscriptionname}-app01 CPU credits"
  resource_group_name = azurerm_resource_group.primary.name
  scopes              = [azurerm_windows_virtual_machine.app01.id]
  description         = "CPU credits have dropped below 0."
  severity            = 2
  window_size         = "PT5M"
  frequency           = "PT5M"

  criteria {
    metric_namespace = "microsoft.compute/virtualmachines"
    metric_name      = "CPU Credits Remaining"
    aggregation      = "Count"
    operator         = "LessThan"
    threshold        = 1
  }

  action {
    action_group_id = azurerm_monitor_action_group.spoke-mon-ops-warning-ag.id
  }
}

resource "azurerm_monitor_metric_alert" "app01-CPU-utilization" {
  name                = "${var.subscriptionname}-app01 CPU utilization"
  resource_group_name = azurerm_resource_group.primary.name
  scopes              = [azurerm_windows_virtual_machine.app01.id]
  description         = "CPU utilization has exceeded normal high levels."
  severity            = 2
  window_size         = "PT5M"
  frequency           = "PT5M"

  criteria {
    metric_namespace = "microsoft.compute/virtualmachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 90
  }

  action {
    action_group_id = azurerm_monitor_action_group.spoke-mon-ops-warning-ag.id
  }
}

resource "azurerm_monitor_metric_alert" "app01-OS-disk-queue-depth" {
  name                = "${var.subscriptionname}-app01 OS disk queue depth"
  resource_group_name = azurerm_resource_group.primary.name
  scopes              = [azurerm_windows_virtual_machine.app01.id]
  description         = "OS disk queue depth has exceeded normal high levels"
  severity            = 2
  window_size         = "PT5M"
  frequency           = "PT5M"

  dynamic_criteria {
    metric_namespace         = "microsoft.compute/virtualmachines"
    metric_name              = "OS Disk Queue Depth"
    aggregation              = "Average"
    operator                 = "GreaterThan"
    alert_sensitivity        = "Low"
    evaluation_failure_count = 4
    evaluation_total_count   = 4
  }

  action {
    action_group_id = azurerm_monitor_action_group.spoke-mon-ops-warning-ag.id
  }
}

resource "azurerm_monitor_metric_alert" "app01-data-disk-queue-depth" {
  name                = "${var.subscriptionname}-app01 data disk queue depth"
  resource_group_name = azurerm_resource_group.primary.name
  scopes              = [azurerm_windows_virtual_machine.app01.id]
  description         = "Data disk queue depth has exceeded normal high levels"
  severity            = 2
  window_size         = "PT5M"
  frequency           = "PT5M"


  dynamic_criteria {
    metric_namespace         = "microsoft.compute/virtualmachines"
    metric_name              = "Data Disk Queue Depth"
    aggregation              = "Average"
    operator                 = "GreaterThan"
    alert_sensitivity        = "Low"
    evaluation_failure_count = 4
    evaluation_total_count   = 4
  }

  action {
    action_group_id = azurerm_monitor_action_group.spoke-mon-ops-warning-ag.id
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "app01-available-memory-is-low" {
  name                              = "${var.subscriptionname}-app01 Available Memory is low"
  resource_group_name               = azurerm_resource_group.primary.name
  scopes                            = [data.azurerm_log_analytics_workspace.central.id]
  description                       = "There is less than 15% of RAM available."
  severity                          = 2
  evaluation_frequency              = "PT5M"
  window_duration                   = "PT5M"
  mute_actions_after_alert_duration = "PT15M"
  location                          = azurerm_resource_group.primary.location

  criteria {
    query = <<-QUERY
      InsightsMetrics 
      | where TimeGenerated > now() - 5m 
      | where _ResourceId == '${azurerm_windows_virtual_machine.app01.id}' 
      | where Namespace == 'Memory' and Name == 'AvailableMB' 
      | extend TotalMemory = toreal(todynamic(Tags)['vm.azm.ms/memorySizeMB']) 
      | extend AvailableMemoryPercentage = (toreal(Val) / TotalMemory) * 100.0 
      | where AvailableMemoryPercentage < 15
      QUERY

    time_aggregation_method = "Count"
    threshold               = 1
    operator                = "GreaterThanOrEqual"
  }

  action {
    action_groups = [azurerm_monitor_action_group.spoke-mon-ops-warning-ag.id]

  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "app01-system-disk-iops-is-high" {
  name                              = "${var.subscriptionname}-app01 System disk IOPS is high"
  resource_group_name               = azurerm_resource_group.primary.name
  scopes                            = [data.azurerm_log_analytics_workspace.central.id]
  description                       = "The C drive is at 500 IOPS or higher."
  severity                          = 2
  evaluation_frequency              = "PT5M"
  window_duration                   = "PT5M"
  mute_actions_after_alert_duration = "PT15M"
  location                          = azurerm_resource_group.primary.location

  criteria {
    query = <<-QUERY
      InsightsMetrics 
      | where TimeGenerated > now() - 5m 
      | where Namespace == 'LogicalDisk' and Name == 'TransfersPerSecond' 
      | extend Disk=tostring(todynamic(Tags)['vm.azm.ms/mountId']) 
      | where _ResourceId == '${azurerm_windows_virtual_machine.app01.id}' and Disk == 'C:' 
      | where Val >= 500
      QUERY

    time_aggregation_method = "Count"
    threshold               = 1
    operator                = "GreaterThanOrEqual"
  }

  action {
    action_groups = [azurerm_monitor_action_group.spoke-mon-ops-warning-ag.id]

  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "app01-system-disk-free-space-is-low" {
  name                              = "${var.subscriptionname}-app01 System disk free space is low"
  resource_group_name               = azurerm_resource_group.primary.name
  scopes                            = [data.azurerm_log_analytics_workspace.central.id]
  description                       = "The C drive has less than 20% free capacity."
  severity                          = 2
  evaluation_frequency              = "PT5M"
  window_duration                   = "PT5M"
  mute_actions_after_alert_duration = "PT15M"
  location                          = azurerm_resource_group.primary.location

  criteria {
    query = <<-QUERY
      InsightsMetrics 
      | where TimeGenerated > now() - 5m 
      | where Namespace == 'LogicalDisk' and Name == 'FreeSpacePercentage' 
      | extend Disk=tostring(todynamic(Tags)['vm.azm.ms/mountId']) 
      | where _ResourceId == '${azurerm_windows_virtual_machine.app01.id}' and Disk == 'C:' 
      | where Val < 20
      QUERY

    time_aggregation_method = "Count"
    threshold               = 1
    operator                = "GreaterThanOrEqual"
  }

  action {
    action_groups = [azurerm_monitor_action_group.spoke-mon-ops-warning-ag.id]

  }
}

resource "azurerm_monitor_metric_alert" "network" {
  name                              = "${var.subscriptionname}-metricalert"
  resource_group_name               = azurerm_resource_group.network.name
  scopes                            = [azurerm_network_connection_monitor.network.id]
  description                       = "Connection Monitoring from p-nwsadm-app01 to p-we1dat-sql01"
  target_resource_type              = "Microsoft.Network/networkWatchers/connectionMonitors"
  enabled                           = true
  severity                          = 3
  auto_mitigate                     = true
  frequency                         = "PT5M"
  window_size                       = "PT5M"

  criteria {
    metric_namespace = "Microsoft.Network/networkWatchers/connectionMonitors"
    metric_name      = "TestResult"
    aggregation      = "Maximum"
    operator         = "GreaterThan"
    threshold        = 3
  dimension {
    name     = "SourceName"
    operator = "Include"
    values   = ["*"]
  }

  dimension {
    name     = "DestinationName"
    operator = "Include"
    values   = ["*"]
  }
  
  dimension {
    name     = "TestGroupName"
    operator = "Include"
    values   = ["*"]
    }
  
  dimension {
    name     = "TestConfigurationName"
    operator = "Include"
    values   = ["*"]
  }
}

  action {
    action_group_id = azurerm_monitor_action_group.spoke-mon-ops-warning-ag.id
  }
}


