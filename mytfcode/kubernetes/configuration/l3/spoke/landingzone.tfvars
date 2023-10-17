landingzone = {
  backend_type        = "azurerm"
  global_settings_key = "settings"
  level               = "level3"
  key                 = "spoke"
  tfstates = {
    net-hub-region1 = {
      level   = "lower"
      tfstate = "net-hub-region1.tfstate"
    }
  }
}
