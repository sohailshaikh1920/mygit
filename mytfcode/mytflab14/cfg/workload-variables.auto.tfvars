##################################################
#  Other required subscriptions
##################################################

subscriptionid_gov    = "ad7f2a97-efd8-4f53-a370-e9bb3b264012"
subscriptionid_mgt    = "4fc3c733-4bef-4b94-8abf-0931d0fb3c79"
subscriptionid_pdns   = "7a708aca-e71d-40fa-90ec-75155f07f9b9"
subscriptionid_vdchub = "c50f0502-94d6-4fb5-8efa-98d3be4b3c65"


##################################################
#  Governance resources
##################################################

central_log_analytics_workspace_name      = "p-mgt-montijczky7je-ws"
app_insights_log_analytics_workspace_name = "p-mgt-apmpfdxpugzrb-ws"
governance_storage_account_name           = "pgovlogauditxnlolmbkkxb"


##################################################
#  VDC instance network
##################################################

vdc_address_space = "10.100.0.0/16"

##################################################
#  VDC instance hub virtual network
##################################################

hub_virtual_network_name_resource_group = "p-we1net-network"
hub_virtual_network_name                = "p-we1net-network-vnet"

firewall_resource_group = "p-we1net-network"
firewall_name           = "p-we1net-network-fw"
firewall_ipaddress      = "10.100.1.4"


##################################################
#  Workload management group
##################################################

managementgroup = "we1"


##################################################
#  Workload subscription
##################################################

subscriptionid   = "f7657530-0947-4bb7-ad67-2d74df887d77"
subscriptionname = "p-we1waf"
location         = "westeurope"


##################################################
#  Workload variables
##################################################

zones    = ["1", "2", "3"]
