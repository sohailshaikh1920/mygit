##################################################
#  Workload virtual network
##################################################

firewall_rules_collection_group_priority = "12900"
vnetaddress                              = "10.100.18.0/26"
dnsservers                               = ["10.100.1.4"]
subnet1Name                              = "IntegrationSubnet"
subnet1Prefixes                          = ["10.100.18.0/27"]
subnet1ServiceEndpoints                  = []
subnet2Name                              = "PrivateEndpointSubnet"
subnet2Prefixes                          = ["10.100.18.32/27"]
subnet2ServiceEndpoints                  = []


# Static IP Addresses

plan1-function1-ip           = "10.100.18.6"
plan1-function1-blob-ip       = "10.100.18.4"
plan1-function1-fileshare1-ip = "10.100.18.5"
