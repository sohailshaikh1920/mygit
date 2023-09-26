# Management Automation and Auditing

The Terraform ...

## Level 1

In the `aztfmod` configuration of landing zones, *level1* is the ....

## Implementation

### Pre-Requirements

Before deployment - 

#### Configuration

Globally unique services will need to be renamed

*Storage Accounts* in `storage.tfvars`

#### Target Subscriptions


|Workload           |Management Logs and Automation
|---|---|
|Alias              |mgt
|Level              |1
|Key                |mgt
|State File         |mgt-logs.tfstate
|Subscription Name  |p-mgt
|Subscription ID    |7be9228c-8ef1-4dd1-a7dc-182a61282c14

*Owner on Subscription to deploy the resources*`

Set the variable `target_subId` to point at the Target Subscription ID

```bash
target_SubId="7be9228c-8ef1-4dd1-a7dc-182a61282c14"
```

#### Dependancies

##### Other Landing Zones

|Workload           |State Management
|---|---|
|Alias              |launchpad
|Level              |lower (0)
|Key                |state
|State File         |settings.tfstate
|Subscription Name  |p-iac
|Subscription ID    |7be9228c-8ef1-4dd1-a7dc-182a61282c14

##### Bootstrap and Global Settings

Global Settings Key = `settings`

Set the variable `state_subID` to point at the bootstrap Subscription ID

```bash
state_SubId="7be9228c-8ef1-4dd1-a7dc-182a61282c14"
```

### Implementation


### # Authenticate and Set the active Tenant
rover login
az account set --subscription $state_subId

### Plan for the Launchpad deployment, to host the states

rover \
  -lz /tf/caf/component/landingzone \
  -var-folder /tf/caf/configuration/l1/p-mgt/ \
  -tfstate_subscription_id $state_SubId \
  -target_subscription $target_SubId \
  -tfstate mgt-logs.tfstate \
  -env power \
  -level level1 \
  -w tfstate \
  -p ${TF_DATA_DIR}/mgt-logs.tfstate.tfplan \
  -a plan

Review the plan, and then proceed with deployment

### Apply for the Launchpad deployment, to host the states

rover \
  -lz /tf/caf/component/landingzone \
  -var-folder /tf/caf/configuration/l1/p-mgt/ \
  -tfstate_subscription_id $state_SubId \
  -target_subscription $target_SubId \
  -tfstate mgt-logs.tfstate \
  -env power \
  -level level1 \
  -w tfstate \
  -p ${TF_DATA_DIR}/mgt-logs.tfstate.tfplan \
  -a apply

# Next steps

When you have successfully deployed the management landing zone, you can move to the next step:

[Deploy Identity](../../level1/identity/readme.md)

