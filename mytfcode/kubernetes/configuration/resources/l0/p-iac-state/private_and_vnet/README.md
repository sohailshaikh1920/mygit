
# Terraform State Managment

This is the launch pad for any azure framework component, to correctly work with the state management system

# Azure Cloud Framework - `p-iac` State Management

The launchpad allows you to manage the foundations of landing zone environments by:

* Securing remote Terraform state storage for multiple subscriptions.
* Managing the transition from manual to automated environments.
* Bring up the DevOps foundations using Azure DevOps, Terraform Cloud and GitHub actions (more to come).

Launchpad operates at **level 0**.

For a review of the hierarchy approach of Cloud Adoption Framework for Azure landing zones on Terraform, you can refer to [the following documentation](https://github.com/Azure/caf-terraform-landingzones/blob/master/documentation/code_architecture/hierarchy.md).

## Configuration Settings

### Environment Regions

```yaml
regions = {
  region1 = "westeurope"
  region2 = "northeurope"
}
```

### Governance Tags

The tags for this workloads goverance are defined in the variable `tags` which can be located in the file `global_settings.tfvars`, and defined as follows for this environment

```yaml
# core tags to be applied accross this landing zone
tags = {
  owner          = "Ops"
  deploymentType = "Terraform"
  costCenter     = "0"
  BusinessUnit   = "SHARED"
  DR             = "NON-DR-ENABLED"
  CreatedOn      = "20230509143000"
}

# all resources deployed will inherit tags from the parent resource group
inherit_tags = true
```

### Target Managment Group

The name of the Top Level management group we will target the deployment against should be defined as a Key in the variable `role_mapping` which can be found in the file `roles.tfvars`

```yaml
role_mapping = {
  built_in_role_mapping = {
    management_group = {
      "vdcroot" = {
```

By default this will be `root` but for brown field sites where the target management group has been created and premissions delegated to use, this should be defined instead.

### Keyvaults and Storage Account

The management of state is stored in resources which require globally unique names, the following table identifes the names for both the Storage accounts and Key Vaults

| level  | Storage Account Name   | Keyvault Name |
|---|---|---|
| level0 | p-iac-statelevel0-pwr| p-iac-statelevel0-pwr-kv |
| level1 | p-iac-statelevel1-pwr| p-iac-statelevel1-pwr-kv |
| level2 | p-iac-statelevel2-pwr| p-iac-statelevel2-pwr-kv |
| level3 | p-iac-statelevel3-pwr| p-iac-statelevel3-pwr-kv |
| level4 | p-iac-statelevel4-pwr| p-iac-statelevel4-pwr-kv |

The settings for these names can be found respectivelly in the variables
`storage_accounts` in the file `storage_accounts.tfvars` and `keyvaults` in the file `keyvaults.tfvars` respectivlly.



## Configuration

|Workload|level|subscription|state file|key|folder|
|---|---|---|---|---|---|
|state management|0|p-iac|state|state|l0\p-iac-state|

## Dependencies

Owner on Subsription to be used as `p-iac`


### Launchpad

```bash

# Power 
azTenant="expertas.onmicrosoft.com"
azEnv="power"
azComponent="state"
azSubState="6bf8037f-4ed7-4adf-b1a3-e09efbcc2b3c"

# Hack3
azTenant="InnoNorgeHack3.onmicrosoft.com"
azEnv="alpha"
azComponent="state"
azSubState="b4e6ba46-404a-408e-a3f3-475b5f0f482d"


# Login to the subscription p-mgt with the user damian.flynn_innofactor.com#EXT#@InnoNorgeHack3.onmicrosoft.com
rover login -t expertas.onmicrosoft.com -s 6bf8037f-4ed7-4adf-b1a3-e09efbcc2b3c

rover \
  -lz /tf/caf/framework/component/launchpad \
  -var-folder /tf/caf/framework/configuration/l0/p-iac-state/ \
  -tfstate_subscription_id 6bf8037f-4ed7-4adf-b1a3-e09efbcc2b3c \
  -target_subscription 6bf8037f-4ed7-4adf-b1a3-e09efbcc2b3c \
  -tfstate state.tfstate \
  -launchpad \
  -env power \
  -level level0 \
  -p ${TF_DATA_DIR}/state.tfstate.tfplan \
  -a plan

rover \
  -lz /tf/caf/framework/component/launchpad \
  -var-folder /tf/caf/framework/configuration/l0/p-iac-state/ \
  -tfstate_subscription_id 6bf8037f-4ed7-4adf-b1a3-e09efbcc2b3c \
  -target_subscription 6bf8037f-4ed7-4adf-b1a3-e09efbcc2b3c \
  -tfstate state.tfstate \
  -launchpad \
  -env power \
  -level level0 \
  -p ${TF_DATA_DIR}/state.tfstate.tfplan \
  -a apply
```




## Payload

* Subscription: p-iac
  * ResourceGroups: p-iac-statelevel0
  * ResourceGroups: p-iac-statelevel1
  * ResourceGroups: p-iac-statelevel2
  * ResourceGroups: p-iac-statelevel3
  * ResourceGroups: p-iac-statelevel4
  * ResourceGroups: p-iac-network
    * virtualNetwork: p-iac-network-vnet
      - address_space = ["10.101.10.0/24", "10.101.8.0/23"]
        subnets:
        * level0:
          - cidr: "10.101.10.0/27"
          - enforce_private_link_endpoint_network_policies = true
        * level1:
          - cidr: "10.101.10.32/27"
          - enforce_private_link_endpoint_network_policies = true
        * level2:
          - cidr: "10.101.10.64/27"
          - enforce_private_link_endpoint_network_policies = true
        * level3:
          - cidr: "10.101.10.96/27"
          - enforce_private_link_endpoint_network_policies = true
        * level4:
          - cidr: "10.101.10.128/27"
          - enforce_private_link_endpoint_network_policies = true
        * credentials:
          - cidr: "10.101.10.160/27"
          - enforce_private_link_endpoint_network_policies = true
        * gitops:
          - cidr: "10.101.10.192/27"
          - enforce_private_link_endpoint_network_policies = true
        * runners:
          - cidr    = ["10.101.8.0/23"]
          - nsg_key = "empty_nsg"
      

## Pre-requisites

This scenario require the following privileges:

| Component          | Privileges         |
|--------------------|--------------------|
| Active Directory   | None               |
| Azure subscription | Subscription owner |

## Deployment

```bash
rover -lz /tf/caf/caf_launchpad \
  -launchpad \
  -var-folder /tf/caf/caf_launchpad/scenario/100 \
  -env <name of environment> \
  -a plan

rover -lz /tf/caf/caf_launchpad \
  -launchpad \
  -var-folder /tf/caf/caf_launchpad/scenario/100 \
  -env <name of environment> \
  -a destroy
```

## Architecture diagram
![Launchpad 100](../../documentation/img/launchpad-100.PNG)

## Services deployed in this scenario

| Component             | Purpose                                                                                                                                                                                                                    |
|-----------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Resource group        | Multiple resource groups are created to isolate the services.                                                                                                                                                              |
| Storage account       | A storage account for remote tfstate management is provided for each level of the framework. Additional storage accounts are created for diagnostic logs.                                                                  |
| Key Vault             | The launchpad Key Vault hosts all secrets required by the rover to access the remote states, the Key Vault policies are created allowing the logged-in user to see secrets created and stored.                             |
| Virtual network       | To secure the communication between the services a dedicated virtual network is deployed with a gateway subnet, bastion service, jumpbox and azure devops release agents. Service endpoints is enabled but not configured. |
| Azure AD Applications | An Azure AD application is created. This account is mainly use to bootstrap the services during the initialization. It is also considered as a breakglass account for the launchpad landing zones                          |
