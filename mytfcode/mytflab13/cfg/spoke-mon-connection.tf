resource "azurerm_network_connection_monitor" "network" {
  name               = "p-nwsadm_p-we1dat-sql01-availability"
  network_watcher_id = azurerm_network_watcher.network.id
  location           = azurerm_resource_group.network.location

  endpoint {
    name                 = "p-nwsadm-app01(p-nwsadm)"
    target_resource_id   = azurerm_windows_virtual_machine.app01.id
    target_resource_type = "AzureVM"
  }
  endpoint {
    name                 = "p-we1dat-sql01(p-we1dat)"
    target_resource_id   = "/subscriptions/c558db52-81c1-474a-af6c-7b2c4299f5cf/resourceGroups/p-we1dat/providers/Microsoft.Compute/virtualMachines/p-we1dat-sql01"
    target_resource_type = "AzureVM"
  }

  test_configuration {
    name                      = "tcp1433"
    protocol                  = "Tcp"
    test_frequency_in_seconds = 30
    success_threshold {
      checks_failed_percent   = 1
      round_trip_time_ms      = 10 
    }

    tcp_configuration {
      port = 1433
      trace_route_enabled = true
    }
  }

  test_group {
    name                     = "p-nwsadm-app"
    destination_endpoints    = ["p-we1dat-sql01(p-we1dat)"]
    source_endpoints         = ["p-nwsadm-app01(p-nwsadm)"]
    test_configuration_names = ["tcp1433"]
    enabled                  = true 
  }

  
  output_workspace_resource_ids = [data.azurerm_log_analytics_workspace.central.id]

  depends_on = [azurerm_virtual_machine_extension.MicrosoftMonitoringAgent_app01]
}