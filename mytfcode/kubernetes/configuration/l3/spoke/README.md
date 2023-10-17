# Empty Spoke Scaffold


## Configuration

|Workload|level|key|state file|subscription|
|---|---|---|---|---|
|Empty Spoke|3|spoke|spoke.tfstate|t-rg1spoke|

Global Settings Key: settings

# Depends

|State Alias | Level |  State File | Description
|---|---|---|---|
|net-hub-region1  |lower (2) |net-hub-region1.tfstate| Network Hub (Region 1)


## Configuration

To address global unique nameing constraints, while not using dynamic naming logic, we need to update the follwing before planing and deployment

## Deployment

Deploy the management services


```bash
rover \
  -lz /tf/caf/framework/component/landingzone/  \
  -var-folder /tf/caf/framework/configuration/l3/spoke/ \
  -tfstate_subscription_id 6bf8037f-4ed7-4adf-b1a3-e09efbcc2b3c \
  -target_subscription 987d5cc5-6e20-47d3-8cb4-8c5989648045 \
  -tfstate spoke-region1.tfstate \
  -env power \
  -level level3 \
  -w tfstate \
  -p ${TF_DATA_DIR}/spoke-region1.tfstate.tfplan \
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
      

## Next Steps

### Gateway Subnet

Update the hub GatewaySubnet route table with a route to the prefixes of this VNet

```hcl
resource "azurerm_route" "gatewaysubnet" {
  provider               = azurerm.pwe1net
  name                   = "${azurerm_network_watcher.network.name}"
  resource_group_name    = data.azurerm_virtual_network.hub.resource_group_name
  route_table_name       = "${data.azurerm_virtual_network.hub.name}-GatewaySubnet-rt"
  address_prefix         = var.vnetaddress
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = data.azurerm_firewall.firewall.ip_configuration[0].private_ip_address
}
```