# Bootstrap

The Terraform Bootstrap is a configuration set that are used to create a new Azure environment. The configuration is designed to be used with the `aztfmod` framework, which provides a set of best practices and conventions for Terraform code. 

The Bootstrap modules include resources for creating a new resource group, storage account, and key vault, as well as modules for configuring networking, security, and monitoring. The Bootstrap also includes a set of Terraform variables that can be used to customize the environment, such as the Azure region, resource group name, and storage account name. 

## Level 0

In the `aztfmod` configuration of landingzones, *level0* is the root level that contains the core infrastructure components that are required for all other levels. 

The primary role of *level0* is to provide a foundation for the rest of the landing zones by creating a set of shared services and resources that can be used by all other levels.

Level0 also sets up the Azure Policy and Azure Blueprints that will be used to enforce governance and compliance across all levels. Overall, level0 is a critical component of the aztfmod landing zones architecture, as it provides a standardized and consistent foundation for building and managing Azure environments.

## Implementation

### Dependencies

Owner on Subscription to be used as `p-iac`

### Configuration

|Workload|level|subscription|state file|key|folder|
|---|---|---|---|---|---|
|state management|0|p-iac|state|state|l0\p-iac-state|


bootstrap | tfstate_subId | 7be9228c-8ef1-4dd1-a7dc-182a61282c14

# Define the Subscription IDs
tfstate_subId="7be9228c-8ef1-4dd1-a7dc-182a61282c14"

# Authenticate and Set the active Tenant
rover login
az account set --subscription $tfstate_subId

# Level 0 

## State Management

Before deployment - Globally unique services will need to be renamed
*Keyvaults* in `keyvaults.tfvars`
*Storage Accounts* in `storage.tfvars`

### Plan for the Launchpad deployment, to host the states

rover \
  -lz /tf/caf/component/launchpad \
  -var-folder /tf/caf/configuration/l0/bootstrap/ \
  -tfstate_subscription_id $tfstate_subId \
  -target_subscription $tfstate_subId \
  -tfstate settings.tfstate \
  -launchpad \
  -env power \
  -level level0 \
  -p ${TF_DATA_DIR}/settings.tfstate.tfplan \
  -a plan

Review the plan, and then proceed with deployment

### Apply for the Launchpad deployment, to host the states

rover \
  -lz /tf/caf/component/launchpad \
  -var-folder /tf/caf/configuration/l0/bootstrap/ \
  -tfstate_subscription_id $tfstate_subId \
  -target_subscription $tfstate_subId \
  -tfstate settings.tfstate \
  -launchpad \
  -env power \
  -level level0 \
  -p ${TF_DATA_DIR}/settings.tfstate.tfplan \
  -a apply

