# ACR Worload


## Configuration

|Workload|level|key|state file|subscription|
|---|---|---|---|---|
|Azure Container Registry|3|acr-region1|acr-region1.tfstate|p-rg1aks|

Global Settings Key: settings

# Depends


|State Alias | Level |  State File | Description
|---|---|---|---|
|net-hub-region1  |lower (2) |net-hub-region1.tfstate| Network Hub (Region 1)


## Configuration

To address global unique nameing constraints, while not using dynamic naming logic, we need to update the follwing before planing and deployment

### Keyvault

Set the name in the variable `keyvault` in the file `keyvaults.tfvars`

## Deployment

Deploy the management services


```bash
rover \
  -lz /tf/caf/framework/component/workloads/  \
  -var-folder /tf/caf/framework/configuration/l3/acr/ \
  -tfstate_subscription_id 6bf8037f-4ed7-4adf-b1a3-e09efbcc2b3c \
  -target_subscription 2f85c566-8bbc-4e46-bbed-a2fc3f5ec828 \
  -tfstate acr-region1.tfstate \
  -env power \
  -level level3 \
  -w tfstate \
  -p ${TF_DATA_DIR}/acr-region1.tfstate.tfplan \
  -a plan
```

## Architecture

* Subscriptions
  * resource Groups: p-we1dc
    * Keyvault: p-we1dc-20230323-kv
    * Virtual Machine: p-we1dc-adds-01
      * NIC
      * OSDisk
  * resource Groups: p-we1dc-network
    * virtual network: p-we1dc-network-vnet
      * subnet: frontend

