monitor_action_groups = {
  networking_operations = {
    action_group_name  = "Networking Operations"
    shortname          = "netops"
    resource_group_key = "mgt_logs"
    arm_role_alert = {
      contributors = {
        name                    = "Monitoring Contributor"
        role_name               = "Monitoring Contributor"
        use_common_alert_schema = false
      }
    }
    email_receiver = {
      noc = {
        name                    = "email_alert_support1"
        email_address           = "info@damianflynn.com"
        use_common_alert_schema = false
      }
    }
  }
}