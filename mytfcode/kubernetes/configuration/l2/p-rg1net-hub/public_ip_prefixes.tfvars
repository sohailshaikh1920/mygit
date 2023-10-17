public_ip_prefixes = {

  hub_fw_pipp = {
    name               = "p-rg1net-network-pipp"
    resource_group_key = "hub_vnet"
    region             = "region1"
    sku                = "Standard" # (Optional) The SKU of the Public IP Prefix. Accepted values are Standard. Defaults to Standard
    zones              = ["1", "2"] # (Optional) The availability zone to allocate the Public IP in.
    ip_version         = "IPv4"
    prefix_length      = 31 # (Optional) Specifies the number of bits of the prefix. The value can be set between 0 (4,294,967,296 addresses) and 31 (2 addresses). Defaults to 28(16 addresses). Changing this forces a new resource to be created.
    tags               = { locked = true }
  }
}