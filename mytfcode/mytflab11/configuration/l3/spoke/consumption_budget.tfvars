monitor_action_groups = {
  subscription_alerts = {
    action_group_name  = "ag_subscription"
    resource_group_key = "spoke"
    shortname          = "subAlerts"
  }
}


consumption_budgets = {
  spoke_budget = {
    subscription = {
      # id     = "<subscription_id>"
      #lz_key = "spoke"
      key    = "spoke"
    }
    name       = "spoke-region1-budget"
    amount     = 1000
    time_grain = "Monthly"
    time_period = {
      # uncomment to customize start_date
      # start_date = "2022-06-01T00:00:00Z"
    }
    notifications = {
      default = {
        enabled   = true
        threshold = 95.0
        operator  = "EqualTo"
        contact_emails = [
          "foo@example.com",
          "bar@example.com",
        ]
      }
      contact_email = {
        enabled   = true
        threshold = 90.0
        operator  = "EqualTo"
        contact_emails = [
          "foo@example.com",
          "bar@example.com",
        ]
      }
      contact_group = {
        enabled   = true
        threshold = 85.0
        operator  = "EqualTo"
        # lz_key    = "examples"
        contact_groups_keys = [
          "subscription_alerts", //current 
          "email_receiver"  // l1
        ]
      }
      contact_role = {
        enabled   = true
        threshold = 80.0
        operator  = "EqualTo"
        contact_roles = [
          "Owner",
        ]
      }
    }
    filter = {
      dimensions = {
        explicit_name = {
          name     = "ResourceGroupName"
          operator = "In"
          values = [
            "example",
          ]
        },
        resource_key = {
          # lz_key = "examples"
          name         = "resource_key"
          resource_key = "resource_groups"
          values = [
            "spoke",
          ]
        }
      }
      tags = {
        tag_example_default_operator = {
          name   = "level",
          values = ["100"]
        },
        tag_example_explicit_operator = {
          name     = "mode",
          operator = "In"
          values   = ["test"]
        }
      }
      not = {
        # dimension and tag block conflicts
        # dimension = {
        #   # not block supports only one dimension block
        #   # explicit_name = {
        #   #   name     = "ResourceGroupName"
        #   #   operator = "In"
        #   #   values = [
        #   #     "example",
        #   #   ]
        #   # },
        #   resource_key = {
        #     # lz_key = "examples"
        #     name         = "resource_key"
        #     resource_key = "resource_groups"
        #     values = [
        #       "test",
        #     ]
        #   }
        # }
        tag = {
          name   = "name"
          values = ["not-tag"]
        }
      }
    }
  }
}