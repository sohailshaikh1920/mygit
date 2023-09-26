resource_groups = {
  rg1_funcapp = {
    name = "t-rg1func"
    tags = {
      env = "standalone"
    }
  }
  rg1_funcapp_network = {
    name = "t-rg1func-network"
    tags = {
      env = "standalone"
    }
    lock_resource = false
  }
}