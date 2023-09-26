landingzone = {
  backend_type        = "azurerm"
  global_settings_key = "settings"
  level               = "level2"
  key                 = "rg1net-hub"
  tfstates = {
    mgt-logs = {
      level   = "lower"
      tfstate = "mgt-logs.tfstate"
    }
  }
}