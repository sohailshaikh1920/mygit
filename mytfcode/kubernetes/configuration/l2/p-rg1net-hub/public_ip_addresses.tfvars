public_ip_addresses = {

  hub_fw_pip1 = {
    name               = "p-rg1net-network-fw-pip1"
    resource_group_key = "hub_vnet"
    sku                = "Standard"
    allocation_method  = "Static"
    ip_version         = "IPv4"
    domain_name_label  = "fw-out1" # Result will be: <domain_name_label>.<region>.cloudapp.azure.com,
    tags               = { locked = true }
    # zones                   = ["1", "2"]
    idle_timeout_in_minutes = "4"
    public_ip_prefix = {
      # lz_key =
      key = "hub_fw_pipp"
    }
  }
}