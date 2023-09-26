## Code Repository

The code required to deploy a data centre and its workloads are stored in multiple code repositories.

### Shared Repository

A shared repository is used to store and maintain shared settings, templates and scripts.It should be available to every team that use this infrastructure as code deployment approach.

| Name          | Description                                                  |
| ------------- | ------------------------------------------------------------ |
| settings.json | A file with shared settings for deployments.                 |
| .architypes   | A folder with spoke templates for use by the Concierge.      |
| .pipelines    | A folder with Azure DevOps pipeline YAML files.              |
| .toolchain    | A folder with PowerShell scripts.                            |
| .vscode       | A folder with workspace settings and recommended extensions. |

#### Settings File

The settings file is stored in the root of a shared repository, with the file name `settings.json`. Its purpose is to provide a central location for shared settings, or values, needed in configuration files.

Settings are used for values that:

* **Are frequently used:** Specifying the value once and allow it to be reused makes changing the value quick, easy, and consistent.
* **Should be easy to find and change:** A configuration file have values that can change from workload to workload or over time. By defining them as a setting they become easy to find and change.

The file is structured using a format called *JSON*.

::: tip
The main body of the file consist of an object. An object is an unordered set of name and value pairs and begins with `{` and ends with `}`.

Each name is followed by `:` and the name/value pairs are separated by `,`.

A value can be:

* A string in double quotes
* A number
* True or False
* null
* An object
* An array.

These structures can be nested. An array is an ordered collection of values and begins with `[` and ends with `]`. Values are separated by `,`.
:::

The main object of the settings file has the following properties:

|Name|Description|
|---|---|
|structureVersion|The structure version of the settings file.
|replaceStrings|Strings to replace in the configuration file.
|retryOnErrorMatchDeployment|Errors that should be retried.

##### replaceStrings

The settings file has a section called **replaceStrings** with a name and a value. The name can be used anywhere in a configuration file, except in the **replaceStrings** section.

The name must start with `[#_` and end with `_#]`. This allow it to be easily recognized as a pattern inside the file.

When a configuration file is loaded for deployment, the each name is searched for and replaced by the corresponding value. If any **replaceStrings** name is present in the configuration file after the replace process, the deployment will not be allowed.

If the **replaceStrings** object exist in the shared `settings.json` file and in the configuration file, the value from the configuration file will override the value in the shared `settings.json` file.

### Configuration Repository

The core deployment and each workload has a repository to store and maintain configuration files. While it is possible to keep all the configuration files in one repository, When multiple team maintain configuration files, it is recommended to create a separate repository for each team or each workload. This allow for granular access based on who should be able to read and/or update the configuration files for a particular workload.

#### Branch Policy

It is recommended, but not required, to protect each repository with a policy for the default branch.

#### Configuration File

The configuration file is where the majority of the engineering is conducted on a day-to-day basis when building and maintaining the payload which defines the Infrastructure-as-code being managed. The file will typically:

* Include a set of values that are commonly used in the deployment.
* Include information about related Management Groups, subscriptions and/or resource groups.
* Map outputs from one deployment to another, which implicitly maps dependencies.
* Explicitly map dependencies where there is no output/input pairing.
* Configure deployments, each using a specified template and adding parameters as inputs.

#### File Structure

The configuration file is structured using a format called *JSON*.

The main object has the following properties:

|Name|Description
|---|---|
|structureVersion|The structure version of the configuration file.
|containerVersion|The deployment engine the configuration was tested with.
|force|Run deployment even when file has not changed.
|replaceStrings|Replace strings in configuration.
|namingStandard|How to name subscription, RBAC group and resource group.
|tenants|Target tenant.
|datacentres|Target datacentre.
|rbacGroups|Azure Active Directory groups that will be created.
|managementGroups|Management Groups that will be deployed.
|subscriptions|Subscriptions that will be used for deployments.
|resourceGroups|Resource groups that will be used for deployments.
|dependActions|Dependency and actions for deployments.
|deployments|Information about the deployments.

##### replaceStrings

::: tip
A detailed definition can be located in the section **Shared Settings File**
:::

The replace string name can be used anywhere in the file, except in a replace string value. The name will be replaced by the replace string value when the deployment engine loads and process the configuration file.

Each replace string name must start with `[#_` and end with `_#]`.

##### namingStandard

Some elements of the naming standard are flexible and can be changed. This currently includes:

* **rbacGroups:** The structure for naming *Azure AD security groups* that are used to assign access rights to Management Groups and subscriptions in Azure.
* **subscriptions:** The naming standard for subscriptions.
* **resourceGroups:** The naming standard for resource groups.

The naming elements begins with `{` left brace and ends with `}` right brace, for example `{prefix}`.

Some elements are optional and begins with `[` left bracket and ends with `]`right bracket, for example `[{right}]`.

##### tenants

The **tenant** object has the following properties:

|Property|Description|
|---|---|
|name|The Azure Active Directory tenant Name.
|id|Azure Active Directory tenant ID.
|deployClientId|The app registration client ID for deployments in target tenant.
|location|The primary location (Azure region) to use for the tenant.

##### datacentres

The **datacentre** object has the following properties:

|Property|Description|
|---|---|
|name|The data centre name. Should be the same as the location short name.
|location|The default location to use for the data centre.

##### rbacGroups

The **rbacGroup** object has the following properties:

|Property|Description|
|---|---|
|configId|A unique ID used in managementGroups, subscriptions and resourceGroups.
|prefix|The `prefix` element of the group name.
|type|The type. This can be `mg`, `sub`, `rg` or `res`.
|scope|The name of Management Group, subscription, resource group or resource.
|right|The resource level privilege (Optional).
|delegation|The delegated role, from roles in Azure access control.
|description|A description of the group.
|members|Defines the members of the group.
|owners|Defines the owners of the group.

The members and owners object has the following properties:

|Property|Description|
|---|---|
|users|A list of user principal names, user display names or object ID's.
|applications|A list of Azure AD applications display names or object ID's.
|groups|A list of Azure AD group names or object ID's.
|ids|A list of Azure AD object ID's.

Typically, groups for the following roles will be deployed for each subscription being configured and/or Management Group being created:

* Owner
* Contributor
* Reader

##### managementGroups

There are three purposes to specifying Management Groups in the configuration file:

* Create required Management Groups.
* Move the subscription(s) to a Management Group.
* Assign groups (from rbacGroups) to a Management Group, e.g. assign the Owner role on the Management Group `Virtual Data CentreVDC Root` for the group `AZ RBAC mg Virtual Data CentreVDC Root Owner`.

The **managementGroup** object has the following properties:

|Property|Description|
|---|---|
|name|The unique name of the Management Group.
|displayName|The display name of the Management Group.
|parent|The name of the parent Management Group.
|deployments|A list of `deployments` to deploy to the Management Group.
|rbacGroups|A list of `rbacGroups` to be assigned to this Management Group.
|subscriptions|A list of `subscriptions` to move to this Management Group.

The subscription object in the subscriptions array under **managemengGroups** has the following properties:

|Property|Description|
|---|---|
|environment|The environment of the service, defined in subscriptions.
|service|The name of the service, defined in subscriptions.

##### subscriptions

The **subscription** object has the following properties:

|Property|Description|
|---|---|
|datacentre|The data centre name that this subcription belong to.
|environment|The environment of the service.
|service|The name of the service.
|location|The primary location for resource groups in this subscriptions.
|id|The subscription ID.
|deployments|A list of deployments to deploy to the subscription.
|rbacGroups|A list of rbacGroups to be assigned to this subscription.
|providers|A list of Azure resource providers to be registered in this subscription.

Resource provider registration in Azure can be buggy. An instance of a resource provider somewhere on the planet can fail to respond to the registration process and lead to a timeout-based failure. The deployment container will, based on guidance from the ARM product group, wait for up to 10 minutes before assuming that the registration was successful.

##### resourceGroups

The **resourceGroup** object has the following properties:

|Property|Description|
|---|---|
|datacentre|The data centre name that this resource group belong to.
|environment|The environment of the service.
|service|The name of the service.
|role|The role for this resource group in the service.
|location|The location (Azure region) for this resource group.
|lockLevel|Resource group lock level. Can be CanNotDelete, ReadOnly or NotSpecified.
|deployments|A list of deployments to be deployed to the resource group.
|rbacGroups|A list of rbacGroups to be assigned to this resource group.

##### dependActions

Each configuration file may have `dependActions` that are intended to set dependency between deployments or to get the output value from a deployment or from a PowerShell function and use the value as input for other deployment(s).

The **dependAction** object has the following properties:

|Property|Description
|---|---|
|deployments|A list of deployment names that depend on a source.
|source|Information about a source that the deployment depend on.
|replace|A string that will be replaced in each deployments parameters.

The replace string must start with `[@_` and end with `_@]`, e.g. `[_@res.arm.keyvault.id@_]`.

The source object can have the following properties:

|Property|Description|
|---|---|
|deployment|Source deployment name.
|outputName|Source deployment output name.
|datacentre|The datacentre name of source deployment.
|environment|The environment of the source deployment.
|service|The service of the source deployment.
|role|The role of the source deployment.
|function|The name of a PowerShell function to run.
|params|The parameters required by the specified PowerShell function.

Rules:

* If datacentre is not specified, the deployments must exit in the same datacentre.
* If environment is not specified, the deployments must exit in the same environment.
* If service is not specified, the deployments must exit in the same subscription.
* If role is not specified, the deployments must exit in the same resource group.
* If function is specified, the output will be used as value when replacing the replace string in deployment parameters.

##### deployments

The **deployment** object has the following properties:

|Property|Description|
|---|---|
|name|The deployment name suffix (will be prefixed with the parent name).
|templatePath|The full local file path or URL to a deployment template.
|canRedeploy|Set to false if a deployment can't be redeployed after first deployment.
|mode|The mode to use for this deployment.
|suffix|The suffix value.
|tasks|List of tasks that will be executed before or after a deployment.
|paramters|Deployment parameters (similar to ARM paramters file).

::: Note
If name is the only property for a deployment, the deployment is defined as an external deployment, e.g. one that is not defined and deployed from the same config file, and that another deployment in this config file depend on.
:::

::: Note
The suffix parameter is used to set the resource name for a deployment based in the resource group name and the suffix with a dash (-) between. It is required by the function `Remove-NetworkWatcherIfExist` so it can match any existing network watcher against the name used when deploying a network watcher.
:::

The valid mode values are:

|Mode|Description|
|---|---|
|Deploy|Deploy this deployment.
|Validate|Validate this deployment.
|WhatIf|Test using deployment WhatIf to see what will change if it is deployed.
|Skip|Skip this deployment.
|Force|Always deploy, even when nothing has changed.

The tasks object has the following properties:

|Property|Description
|---|---|
|stage|The stage when the function will be executed. Can be pre or post.
|function|The name of a function to run.
