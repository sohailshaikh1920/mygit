azurerm_application_insights = {
  rg1_funcapp_app_insights = {
    name               = "t-rg1func-appinsights"
    resource_group_key = "rg1_funcapp"
    application_type   = "web"

    # Notes from Concierge
    # "Flow_Type": "Redfield",
    # "Request_Source": "IbizaAIExtension",
    # "publicNetworkAccessForIngestion": "Enabled",
    # "publicNetworkAccessForQuery": "Enabled"

    tags = {
      "Application": "[#_service.name_#]",
      "Environment": "[#_service.environment_#]",
      "Purpose": "This resource is part of core infrastructure. Do not delete."
    }
  }
}





app_service_plans = {
  rg1_funcapp_app_plan = {
    resource_group_key = "rg1_funcapp"
    name               = "t-rg1func-asp"
    kind               = "functionapp"
    reserved           = true

    sku = {
      tier = "Dynamic"
      size = "Y1"
    }
    tags = {
      project = "Mobile"
    }
  }
}



storage_accounts = {
  rg1_funcapp_storage = {
    name               = "rg1funcappstorage"
    resource_group_key = "rg1_funcapp"
    region             = "region1"

    account_kind             = "StorageV2"
    account_tier             = "Standard"
    account_replication_type = "LRS"

    containers = {
      dev = {
        name = "random"
      }
    }

  }
}







function_apps = {
  rg1_funcapp = {
    name               = "t-rg1funcapp"
    resource_group_key = "rg1_funcapp"
    region             = "region1"

    app_service_plan_key = "rg1_funcapp_app_plan"
    storage_account_key  = "rg1_funcapp_storage"

    settings = {
      os_type = "linux"
      version = "~4"
      # vnet_key   = "rg1_funcapp"
      # subnet_key = "app"
      #subnet_id = "/subscriptions/97958dac-xxxx-xxxx-xxxx-9f436fa73bd4/resourceGroups/jana-rg-spoke/providers/Microsoft.Network/virtualNetworks/jana-vnet-spoke/subnets/jana-snet-app"
      enabled = true
    }

    app_settings = {
      FUNCTIONS_WORKER_RUNTIME = "powershell"
      FUNCTIONS_EXTENSION_VERSION = "~4"
      FUNCTIONS_WORKER_PROCESS_COUNT = "2"
      FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT = "1"
      PSWorkerInProcConcurrencyUpperBound = "5"
      # WEBSITE_RUN_FROM_PACKAGE = "https://piacomodulesopus.blob.core.windows.net/release/2.0.2.zip"
      WEBSITE_RUN_FROM_PACKAGE = "0"
      packageURI = "https://piacomodulesopus.blob.core.windows.net/release/2.0.2.zip"

      # AzureWebJobsDisableHomepage = true
      # App Specific Settings
      ConciergeVersion = "2.0.2"
    }

    site_config = {
      use_32_bit_worker_process = true     
      min_tls_version = "1.2"      
      ftps_state = "Disabled"
      always_on = false      
      powerShellVersion = "~7" # This is ignored
    }

    tags = {
      application = "payment"
      env         = "uat"
    }
  }
}


# vnets = {
#   rg1_funcapp = {
#     resource_group_key = "rg1_funcapp_network"
#     region             = "region1"
#     vnet = {
#       name          = "rg1_funcapp-network-vnet"
#       address_space = ["10.1.0.0/24"]
#     }
#     specialsubnets = {}
#     subnets = {
#       app = {
#         name = "app"
#         cidr = ["10.1.0.0/28"]
#         delegation = {
#           name               = "functions"
#           service_delegation = "Microsoft.Web/serverFarms"
#           actions            = ["Microsoft.Network/virtualNetworks/subnets/action"]
#         }
#       }
#     }
#   }
# }

# network_security_group_definition = {
#   # This entry is applied to all subnets with no NSG defined
#   empty_nsg = {
#   }
# }
