landingzone = {
  backend_type        = "azurerm"
  global_settings_key = "settings"
  level               = "level3"
  key                 = "aks-region1"
  tfstates = {
    net-hub-region1 = {
      level   = "lower"
      tfstate = "net-hub-region1.tfstate"
    }
    acr-region1 = {
      level   = "current"
      tfstate = "acr-region1.tfstate"
    }
  }
}
