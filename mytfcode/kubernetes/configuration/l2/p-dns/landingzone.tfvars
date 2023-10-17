landingzone = {
  backend_type        = "azurerm"
  global_settings_key = "settings"
  level               = "level2"
  key                 = "dns"
  tfstates = {
    mgt-logs = {
      level   = "lower"
      tfstate = "mgt-logs.tfstate"
    }
  }
}