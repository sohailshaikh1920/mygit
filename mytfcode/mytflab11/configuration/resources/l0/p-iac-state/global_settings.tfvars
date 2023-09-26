# Naming standard 
passthrough = true
random_length = 3
prefix = ""

# Default region. When not set to a resource it will use that value
default_region = "region1"

regions = {
  region1 = "westeurope"
  region2 = "northeurope"
}

# core tags to be applied accross this landing zone
tags = {
  owner          = "Ops"
  deploymentType = "Terraform"
  costCenter     = "0"
  businessUnit   = "SHARED"
  recovery       = "Non-DR-Enabled"
  createdOn      = "20230509143000"
}

# all resources deployed will inherit tags from the parent resource group
inherit_tags = true


# Rover will adjust some tags to enable the discovery of the launchpad.
launchpad_key_names = {
#  azuread_app            = "caf_launchpad_level0"
#  keyvault_client_secret = "aadapp-caf-launchpad-level0"
#  keyvault = "level0"
  tfstates = [
    "level0",
    "level1",
    "level2",
    "level3",
    "level4"
  ]
}
