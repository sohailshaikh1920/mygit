##################################################
#  Workload virtual network
##################################################

firewall_rules_collection_group_priority = "12500"
vnetaddress                              = "10.100.16.0/25"
dnsservers                               = ["10.100.1.4"]
subnet1Name                              = "DevopsSubnet"
subnet1Prefixes                          = ["10.100.16.0/26"]
subnet1ServiceEndpoints                  = []
subnet2Name                              = "PrivateEndpointSubnet"
subnet2Prefixes                          = ["10.100.16.112/28"]
subnet2ServiceEndpoints                  = []

# Static IP Addresses
