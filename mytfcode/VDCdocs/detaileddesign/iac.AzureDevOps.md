## Azure DevOps

This project uses Azure DevOps to manage Infrastructure as Code and deployments to Azure.

An existing Azure DevOps organization can be used or a new can be created for [free](https://dev.azure.com/).

::: Note
If free tier is not enabled, fill out the [request form](https://aka.ms/azpipelines-parallelism-request)
:::

### Service Connections

Service connections are how a deployment pipeline will:

* Authenticate with the Azure tenant to deploy resources to one or more subscriptions.
* Gain authorized access to download the deployment container from a specified Azure container registry.

::: Note
If Grant access permission to all pipelines is not checked for the service connection, the pipeline must be approved, by someone with sufficient permission, the first time the pipeline tries to use the service connection.
:::

### Container Registry Connection

To ensure a consistent, and trouble free deployment, the related scripts necessary to orchestrate a deployment to Azure, based on configuration file's are executed safely inside container on the build agent.

A pre-packaged image, built on a **Ubuntu** base image with **PowerShell** runtime, the required Scripts and related modules is built and published to a Private Azure Container Registry, published in the *Innofactor Managed Services* tenant.

To access this container registry, so to Pull the image, a service connection must be created in the Azure DevOps project settings under **Pipelines > Service connections > New service connection > Docker Registry**.

Use the following configuration:

| Setting                 | Value                                                        |
| ----------------------- | ------------------------------------------------------------ |
| Registry Type           | Others                                                       |
| Docker Registry         | `https://innofactorazuredeploy.azurecr.io/`                   |
| Docker ID               | The client ID of the first Azure deployment account          |
| Docker Password         | A valid client secret of the first [Azure deployment account |
| Service Connection Name | innofactorazuredeploy_acr_connection                         |
| Description             | Connection to Azure container registry in Innofactor tenant  |

A request must be made to give Azure container registry access to the deployment account.

The requirements for being added are:

* A delivery project must exist and be in progress.
* One account per tenant, multiple accounts will be rejected.
* The application name must identify who the app belongs to (e.g. include tenant name).
* The application must not request other permissions than *User.Read* (Sign in and read user profile).

Once the application is added to the specified tenant, it will be allowed to pull images from the Azure container registry.

### Azure Service Connection

A service connection to the *governance subscription* `p-gov` is needed for two reasons:

* Access to the Concierge storage account.

  When a new spoke is needed, it can be created from a template. The templates are stored in a storage account. If a template is updated it must be copied to the storage account.
* Access to the documentation app service.
  
  When the documentation is updated, it can be published to a web app for easy access.

A service connection must be created in the project settings under **Pipelines > Service connections > New service connection > Azure Resource Manager**.

Use the following configuration:

| Setting                 | Value                                                   |
| ----------------------- | ------------------------------------------------------- |
| Authentication method   | Service principal (manual)                              |
| Environment             | Azure Cloud                                             |
| Scope Level             | Subscription                                            |
| Subscription Id         | {The ID of the p-gov subscription}                      |
| Subscription Name       | p-gov                                                   |
| Service Principal Id    | {The client ID of the Azure deployment account}         |
| Service principal key   | {A valid client secret of the Azure deployment account} |
| Tenant ID               | {The target tenant ID}                                  |
| Service connection name | {tenant name}_gov_arm_connection                        |
| Description             | Used to update architypes in p-gov-cng.                 |

### Secret Storage

A variable group is used to store information for the pipelines. The group is created in **Library > Pipelines**.

The name of the variable group should reflect the target tenant. If a separate deployment account is used for each workload, the name should reflect both the target tenant and the workload.

::: Note
The correct name of the variable group must be specified in each pipeline file on a line that start with "- group: "
:::

In the variable group, add the following variables:

| Key                                | Value                                                                                             |
| ---------------------------------- | ------------------------------------------------------------------------------------------------- |
| Architecture                       | The architecture name to deploy, `vwan` or `vnet`.                                                |
| ConfigVersion                      | The configuration version, e.g. `3.9.2`.                                                          |
| ContainerVersion                   | The deployment container version to use, e.g. `3.0.8`.                                            |
| DeploymentPassword                 | The secret from the deployment account app registration in the target tenant added as a secret.   |
| Environment                        | The name of the environment for the deployment. E.g. `Production`.                                |
| ServiceConnection.Gov.Subscription | The service connection name to the `p-gov` Azure subscription, e.g. `contoso_gov_arm_connection`. |
| StorageAccount.Gov.Concierge       | The name of storage account in the `p-gov-cng` resource group, e.g. `pgovcngdatahtc67ad3r4xd`.    |

When adding **DeploymentPassword** click the **Change the variable type to secret** button at the end of the line before adding the secret.

The Environment will be listed under **Pipelines > Environments** in Azure DevOps. It can be
configured to require approvals by one or more persons before deployment is allowed.

> If *Allow access to all pipelines* is not checked, the pipeline must be approved, by someone with sufficient permission, the first time the pipeline tries to use the variable group.

### Azure Pipelines

* deploy.azure-pipelines.yml: Process configuration files in the cfg folder.
* update.architypes.azure-pipelines.yml: Copy spoke templates/architypes to storage account in the **p-gov-cng** resource group.

The name in Azure Pipelines should start with the repository name.

The Deploy pipeline file is defined with a deployment job. This require environment to be set. The environment is named Azure. The name can be changed in the pipeline file.

Note: If the pipeline fail to create the Azure environment, due to lack of permission, it must be created by someone with the permission to create environments.

### Initial Configuration

Once created, the environment will, by default, not permit any pipelines to run without approval. To change the Azure environment to allow all pipelines in the project, open the Azure environment in **Azure DevOps** under **Environments > Pipelines** menu.

* Then select the **More** actions menu shown as *three vertical dots* up in the right corner.

* Select **Security** from the menu and then select the **More actions** menu to the right, under *Pipeline* permissions.

* Select **Open access** and confirm by clicking the **Open access** button.

#### Deploy Configuration

This pipeline will process configuration files in the `cfg` folder of the *config* repository.

* Mode
  
  The pipeline variable `Mode` can be added to specify what the pipeline will do with the information in the configuration files. The following values can be used:

  * **Deploy**: Deploy to Azure. This is the default mode.
  * **Validate**: Validate each deployment with Azure.
  * **WhatIf**: Test what will happen when deploying each deployment to Azure.

* Architecture

  If the variable `Architecture` *is specified*, the pipeline will look for the file `architecture-{Architecture}.order` and deploy each configuration file listed in this file and in the order it is listed.

  If `Architecture` *is not specified*, all the configuration files in the cfg folder will be deployed in alphabetical order.

> The pipeline file specify the variable group and the name of the shared repository. If the name of either of these change or are wrong, the pipeline file must be updated.

When a pipeline completes it will publish deployment bootstrap file(s) as an artifact of the pipeline job. These files can be used to inspect the details from processing each configuration file, such as the deployment WhatIf result.

#### Update Architypes

This pipeline performs the following commands:

* Check if the container `architypes` exist in the storage account that is specified in the variable *StorageAccount.Gov.Concierge*
  * If the container `architypes` *exist*, the files in that container will be deleted.
  * If the container `architypes` *dose not exist*, it will be created.
* Upload files in the `architypes` folder of the shared repository to the container architypes in storage account.

> The pipeline file specify the variable group. If the name change or is wrong, the pipeline file must be updated.
