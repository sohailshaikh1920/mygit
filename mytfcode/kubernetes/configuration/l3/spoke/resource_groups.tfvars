resource_groups = {
  spoke = {
    name = "t-rg1spoke"
    tags = {
      env = "standalone"
    }
  }
  spoke_network = {
    name = "t-rg1spoke-network"
    tags = {
      env = "standalone"
    }
    lock_resource = false
  }
}