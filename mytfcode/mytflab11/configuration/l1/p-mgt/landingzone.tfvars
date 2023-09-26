landingzone = {
  backend_type        = "azurerm"
  global_settings_key = "settings" # Key to the configuration 
  level               = "level1"
  key                 = "mgt-logs"
  tfstates = {
    launchpad = {
      level   = "lower"            # Level 0 reference
      tfstate = "settings.tfstate" # Bootstrap State File 
    }
  }
}
