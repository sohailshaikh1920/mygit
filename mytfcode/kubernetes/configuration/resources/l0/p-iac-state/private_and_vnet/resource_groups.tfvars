resource_groups = {

  level0 = {
    name = "p-iac-statelevel0"
    tags = {
      level = "level0"
      workload = "ACF Platform"
      service = "ACF State Management"
      environment = "Production"
      purpose =  "This resource is part of core infrastructure. Do not delete."
    }
    
  }
  level1 = {
    name = "p-iac-statelevel1"
    tags = {
      level = "level1"
      workload = "ACF Platform"
      service = "ACF State Management"
      environment = "Production"
      purpose =  "This resource is part of core infrastructure. Do not delete."
    }
  }
  level2 = {
    name = "p-iac-statelevel2"
    tags = {
      level = "level2"
      workload = "ACF Platform"
      service = "ACF State Management"
      environment = "Production"
      purpose =  "This resource is part of core infrastructure. Do not delete."
    }
  }
  level3 = {
    name = "p-iac-statelevel3"
    tags = {
      level = "level3"
      workload = "ACF Platform"
      service = "ACF State Management"
      environment = "Production"
      purpose =  "This resource is part of core infrastructure. Do not delete."
    }
  }
  level4 = {
    name = "p-iac-statelevel4"
    tags = {
      level = "level4"
      workload = "ACF Platform"
      service = "ACF State Management"
      environment = "Production"
      purpose =  "This resource is part of core infrastructure. Do not delete."
    }
  }
  iac_network = {
    name = "p-iac-network"
    tags = {
      workload = "ACF Platform"
      service = "ACF State Management"
      environment = "Production"
      purpose =  "This resource is part of core infrastructure. Do not delete."
    }    
  }
}