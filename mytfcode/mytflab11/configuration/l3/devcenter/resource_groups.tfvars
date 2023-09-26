resource_groups = {
  devcenter = {
    name = "t-rg1devcenter"
    tags = {
      env = "standalone"
    }
  }
  devcenter_network = {
    name = "t-rg1devcenter-network"
    tags = {
      env = "standalone"
    }
    lock_resource = false
  }
}