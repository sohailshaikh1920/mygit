# Network Hub - Region 1


## Configuration

|Workload|level|key|state file|subscription|
|---|---|---|---|---|
|Region 1 Virtual Network|2|net-hub-region1|net-hub-region1.tfstate|p-net|

Global Settings Key: settings

# Depends

|State Alias | Level |  State File | Description
|---|---|---|---|
|mgt-logs  |lower (1) |mgt-logs.tfstate| Management Logs Workspace 


## Deployment

Deploy the management services

```bash
rover \
  -lz /tf/caf/framework/component/landingzone/  \
  -var-folder /tf/caf/framework/configuration/l2/p-rg1net-hub/ \
  -tfstate_subscription_id 6bf8037f-4ed7-4adf-b1a3-e09efbcc2b3c \
  -target_subscription cc75f06b-5371-40fd-82fd-fe292f7af666 \
  -tfstate net-hub-region1.tfstate \
  -env power \
  -level level2 \
  -w tfstate \
  -p ${TF_DATA_DIR}/net-hub-region1.tfstate.tfplan \
  -a plan
```


# CAF landing zones for Terraform - Single region hub virtual network

The networking landing zone allows you to deploy most networking topologies on Microsoft Azure. The same landing zone used with different parameters should allow you to deploy most network configurations.

* Hub and spoke
* Virtual WAN
* Application DMZ scenario
* Any custom network topology based on virtual networks or virtual WAN
* Library of network security groups definition

Networking landing zone operates at **level 2**.

For a review of the hierarchy approach of Cloud Adoption Framework for Azure landing zones on Terraform, you can refer to [the following documentation](../../../../documentation/code_architecture/hierarchy.md).

## Architecture diagram

This example allows you to deploy the following topology:

![100-example](../../documentation/img/100-single-region-hub.png)


## Components deployed by this example

| Component                                                                        | Type of resource        | Purpose                                                          |
|----------------------------------------------------------------------------------|-------------------------|------------------------------------------------------------------|
| vnet-hub-re1                                                                     | Resource group          | resource group to host the virtual network                       |
| vnet_hub_re1                                                                     | Virtual network         | virtual network used as a hub                                    |
| GatewaySubnet,AzureFirewallSubnet,AzureBastionSubnet, jumpbox, private_endpoints | Virtual Subnets         | virtual subnets                                                  |
| azure_bastion_nsg, empty_nsg, application_gateway, api_management, jumpbox       | Network security groups | network security groups that can be attached to virtual subnets. |


## Customizing this example

Please review the configuration files and make sure you are deploying in the expected region and with the expected settings.

## Deploying this example

Once you have picked a scenario for test, you can deploy it using:

```bash
rover -lz /tf/caf/caf_networking \
-level level2 \
-var-folder /tf/caf/caf_networking/scenario/100-single-region-hub \
-a apply
```
