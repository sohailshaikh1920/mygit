# AKS Worload


## Configuration

|Workload|level|key|state file|subscription|
|---|---|---|---|---|
|Azure Kubernetes Services|3|aks-region1|aks-region1.tfstate|p-rg1aks|

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
  -lz /tf/caf/framework/component/landingzone/  \
  -var-folder /tf/caf/framework/configuration/l3/aks/ \
  -tfstate_subscription_id 6bf8037f-4ed7-4adf-b1a3-e09efbcc2b3c \
  -target_subscription cb588293-abc4-4363-ba1f-a7e5bce2a0c4 \
  -tfstate aks-region1.tfstate \
  -env power \
  -level level3 \
  -w tfstate \
  -p ${TF_DATA_DIR}/aks-region1.tfstate.tfplan \
  -a plan
```

## Architecture

* Subscriptions
  * resource Groups: p-we1k8s
  * resource Groups: p-we1k8s-network
    * virtual Network: p-we1k8s-network-vnet
      - address_space 10.128.48.0/22
      - subnets 
        - NodepoolSystem
          cidr    = ["10.128.48.0/24"]
          nsg_key = "azure_kubernetes_cluster_nsg"
        - NodepoolUser1
          cidr    = ["10.128.49.0/24"]
          nsg_key = "azure_kubernetes_cluster_nsg"
        - NodepoolUser2
          cidr    = ["10.128.50.0/24"]
          nsg_key = "azure_kubernetes_cluster_nsg"
        - PrivateEndpointsSubnet
          cidr                                           = ["10.128.51.0/27"]
          enforce_private_link_endpoint_network_policies = true
        - AzureBastionSubnet
          cidr    = ["10.128.51.64/27"]
          nsg_key = "azure_bastion_nsg"
        - JumpboxSubnet
          cidr    = ["10.128.51.128/27"]
          nsg_key = "azure_bastion_nsg"
      

