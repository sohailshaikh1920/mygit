subscriptionid   = "42853a69-50e0-4ebb-8210-b538bbcc8c88"
subscriptionname = "p-we1xlf"

subscriptionid_gov = "ad7f2a97-efd8-4f53-a370-e9bb3b264012"
subscriptionid_mgt = "4fc3c733-4bef-4b94-8abf-0931d0fb3c79"
subscriptionid_we1net = "c50f0502-94d6-4fb5-8efa-98d3be4b3c65"
subscriptionid_pdns = "7a708aca-e71d-40fa-90ec-75155f07f9b9"

managementgroup = "we1productionspokes" 

central_log_analytics_workspace_name = "p-mgt-montijczky7je-ws"
app_insights_log_analytics_workspace_name = "p-mgt-apmpfdxpugzrb-ws"
governance_storage_account_name = "pgovlogauditxnlolmbkkxb"

vnetaddress = "10.100.13.192/26" #insert vnet address space
dnsservers = ["10.100.1.4"]

hub_virtual_network_name = "p-we1net-network-vnet"
hub_virtual_network_name_resource_group = "p-we1net-network"

firewall_name = "p-we1net-network-fw"
firewall_resource_group = "p-we1net-network"

budget              = "1300" #Budget on subscription budget alerts 

security_incident_email = "incidents@montelgroup.com"
budget_alert_email = "cloudcost@montelgroup.com"
budget_alert_email_locale = "Norwegian"

#Key Vault specific assignment
#Owners(bb3e3262-e2ff-45e3-9276-1032e0579796) az rbac sub p-we1gb1 owners
#Contributors(97eb3d88-2beb-4c7d-9e97-919714d33fcc) az rbac sub p-we1gb1 contributors
#Readers(4b87eaf0-8cd4-4e25-ad61-a70ef8a5a34a) az rbac sub p-we1gb1 readers
#key_permissions - List of key permissions, must be one or more from the following: Backup, Create, Decrypt, Delete, Encrypt, Get, Import, List, Purge, Recover, Restore, Sign, UnwrapKey, Update, Verify and WrapKey
#secret_permissions - List of secret permissions, must be one or more from the following: Backup, Delete, Get, List, Purge, Recover, Restore and Set
#certificate_permissions - List of certificate permissions, must be one or more from the following: Backup, Create, Delete, DeleteIssuers, Get, GetIssuers, Import, List, ListIssuers, ManageContacts, ManageIssuers, Purge, Recover, Restore, SetIssuers and Update
keyvault_access_policies = {
  "43df4bee-53a9-4be8-9fe4-f9b09729898a" = {
    key_permissions         = ["Backup","Get","List"]
    secret_permissions      = ["Backup","Get","List"]
    certificate_permissions = []
  }
   "b7166b61-ca6c-48a3-a1ce-0d4b1388782d" = {
     key_permissions         = ["Backup","Get","List"]
     secret_permissions      = ["Backup","Get","List"]
     certificate_permissions = []
   } 
   "814cf88b-4b3c-46d2-8391-1b8f8f658a90" = {
     key_permissions         = ["Backup","Get","List"]
     secret_permissions      = ["Backup","Get","List"]
     certificate_permissions = []
   }   
}


app_service_plan = {
  capacity = 1
  kind     = "Windows"
  size     = "I2v2"
  tier     = "IsolatedV2"
}