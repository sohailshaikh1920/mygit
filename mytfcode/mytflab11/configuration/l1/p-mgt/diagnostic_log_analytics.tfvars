diagnostic_log_analytics = {
  mgt_logs = {
    name               = "p-mgt-logs-ws"
    region             = "region1"
    resource_group_key = "mgt_logs"

    solutions_maps = {
      AzureActivity = {
        "publisher" = "Microsoft"
        "product"   = "OMSGallery/AzureActivity"
      },
      ChangeTracking = {
        "publisher" = "Microsoft"
        "product"   = "OMSGallery/ChangeTracking"
      },
      InfrastructureInsights = {
        "publisher" = "Microsoft"
        "product"   = "OMSGallery/InfrastructureInsights"
      },
      KeyVaultAnalytics = {
        "publisher" = "Microsoft"
        "product"   = "OMSGallery/KeyVaultAnalytics"
      },
      ServiceMap = {
        "publisher" = "Microsoft"
        "product"   = "OMSGallery/ServiceMap"
      }
      Updates = {
        "publisher" = "Microsoft"
        "product" : "OMSGallery/Updates"
      }
      VMInsights = {
        "publisher" = "Microsoft"
        "product" : "OMSGallery/VMInsights"
      }
      Security = {
        "publisher" = "Microsoft"
        "product"   = "OMSGallery/Security"
      }
      NetworkMonitoring = {
        "publisher" = "Microsoft"
        "product"   = "OMSGallery/NetworkMonitoring"
      },
      ADAssessment = {
        "publisher" = "Microsoft"
        "product"   = "OMSGallery/ADAssessment"
      },
      ADReplication = {
        "publisher" = "Microsoft"
        "product"   = "OMSGallery/ADReplication"
      },
      AgentHealthAssessment = {
        "publisher" = "Microsoft"
        "product"   = "OMSGallery/AgentHealthAssessment"
      },
      DnsAnalytics = {
        "publisher" = "Microsoft"
        "product"   = "OMSGallery/DnsAnalytics"
      },
      ContainerInsights = {
        "publisher" = "Microsoft"
        "product"   = "OMSGallery/ContainerInsights"
      }

    }

  }
}