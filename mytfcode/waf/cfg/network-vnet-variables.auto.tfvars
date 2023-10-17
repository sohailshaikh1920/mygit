##################################################
#  Workload virtual network
##################################################

vnetaddress                              = "10.100.4.0/22"
dnsservers                               = ["10.100.1.4"]
subnet1Name                              = "PublicWafSubnet"
subnet1Prefixes                          = ["10.100.4.0/24"]
subnet1ServiceEndpoints = [
  "Microsoft.KeyVault", // To access secrets
  "Microsoft.Storage",  // For static websites
  "Microsoft.Web"       // For App Services
]
