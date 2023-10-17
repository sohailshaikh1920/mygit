# Launchpad - scenario 100


### Launchpad

```bash
# Login to the subscription p-mgt with the user damian.flynn_innofactor.com#EXT#@InnoNorgeHack3.onmicrosoft.com
rover login -t InnoNorgeHack3.onmicrosoft.com -s f6b3f099-986b-4a79-b829-e7a38b86b361


rover \
  -lz /tf/caf/acf/platform/launchpad \
  -var-folder /tf/caf/acf/landingzones/bootstrap \
  -tfstate_subscription_id f6b3f099-986b-4a79-b829-e7a38b86b361 \
  -target_subscription f6b3f099-986b-4a79-b829-e7a38b86b361 \
  -tfstate sparks_bootstrap.tfstate \
  -launchpad \
  -env sparks \
  -level level0 \
  -p ${TF_DATA_DIR}/sparks_bootstrap.tfstate.tfplan \
  -a plan
```

The 100 scenario is designed to demonstrate a basic functional foundations to store Terraform state on Azure storage and use it centrally.
The focus of this scenario is to be able to deploy a basic launchpad from a remote machine and use the portal to review the settings in a non-constrained environment.
For example in this scenario you can go to the Key Vaults and view the secrets from the portal, a feature that is disabled in the 300+ scenarios.
We recommend using the 100 scenario for demonstration purposes.

An estimated time of 5 minutes is required to deploy this scenario.

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
