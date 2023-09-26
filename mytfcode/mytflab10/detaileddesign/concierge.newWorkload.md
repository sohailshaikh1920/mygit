## Workload Spoke Scaffolding

The spoke scaffolding flow is designed to automate creation of a new spoke in Azure. It performs several activities is sequence that would normally be manual tasks. The activities are executed by an orchestrator function called **dfo_NewSpoke** and is triggered by the **http_Start** function.

The orchestrator function called **dfo_HealthCheck** is designed to verify access to Azure DevOps and can be used to verify access before using **dfo_NewSpoke**.

The flow can be triggered by any method that can send a HTTP request. The [New-Spoke.ps1 script](Spoke-Scaffolding/New-Spoke.ps1.md) is provided as a sample of how to trigger the flow using PowerShell.

### Pre-Requirements

#### Azure DevOps Personal Access Token

For **Spoke Scaffolding** to work, the **GitPassword** setting must be updated in the **Concierge Key Vault**. In Azure DevOps, the password is a working **Personal Access Token** with the following permissions:

| Scope           | Permission            |
| --------------- | --------------------- |
| **Agent Pools** | Read                  |
| **Build**       | Read & execute        |
| **Code**        | Read, write, & manage |

The Personal Access Token should be created by the same user specified in the app settings **GitUserName** and **GitUserEmail**.

::: WARNING
After updating the **GitPassword** secret in the Key Vault, the app will **not** use the latest version at once, but **within one day**.
Any **configuration changes** to the app will trigger update at once.
:::

#### Subscriptions

The **Function App** can be given permission to create subscriptions for new spokes.

The requirements depend on what agreement type you have with Microsoft:

* [**Microsoft Customer Agreement**](Subscriptions/Microsoft-Customer-Agreement.md)
* [**Enterprise Agreement**](Subscriptions/Enterprise-Agreement.md).

### Usage

Deploy a new spoke using Concierge Function App.
The Concierge has a Function that is designed to automate the process of commissioning a new workload spoke.

```powershell
New-Spoke.ps1
  -Environment <String>
  -Service <String>
  -FunctionAppName <String>
  -FunctionKey <String>
  [-Architype <String>]
  [-BillingScope <String>]
  [-DeployClientId <String>]
  [-DeployVariableGroupName <String>]
  [-Replace <Hashtable>]
  [-RepoName <String>]
  [-VnetCIDR <String>]
  [-VnetSubnetCIDR <String>]
  [-WorkflowStart <String>]
  [-WorkflowPath <String>]
  [-FunctionName <String>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]

New-Spoke.ps1
  -Environment <String>
  -Service <String>
  -FunctionAppName <String>
  -TenantId <String>
  -Credential <PSCredential>
  [-Architype <String>]
  [-BillingScope <String>]
  [-DeployClientId <String>]
  [-DeployVariableGroupName <String>]
  [-Replace <Hashtable>]
  [-RepoName <String>]
  [-VnetCIDR <String>]
  [-VnetSubnetCIDR <String>]
  [-WorkflowStart <String>]
  [-WorkflowPath <String>]
  [-FunctionName <String>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

#### Healthcheck

Run HealthCheck to verify configuration and access

```powershell
PS C:\> Connect-AzAccount -Tenant 98989898-9898-9898-9898-989898989899 -Subscription p-gov
PS C:\> $functionApp = Get-AzResource -ResourceGroupName p-gov-cng -ResourceType 'Microsoft.Web/sites' -Name *-func
PS C:\> $keys = Invoke-AzResourceAction -ResourceId "$($functionApp.Id)/functions/http_Start" -Action listkeys -Force
PS C:\> ./.toolchain/New-Spoke.ps1 -Environment 't' -Service 'tstsp3' -Architype 'network' -FunctionName 'dfo_HealthCheck' -FunctionKey $keys.default -FunctionAppName $functionApp.Name
```

#### Default Network enabled spoke

Deploy a new spoke with name t-tstsp3 using the network spoke template using default values

```powershell
PS C:\> Connect-AzAccount -Tenant 98989898-9898-9898-9898-989898989899 -Subscription p-gov
PS C:\> $functionApp = Get-AzResource -ResourceGroupName p-gov-cng -ResourceType 'Microsoft.Web/sites' -Name *-func
PS C:\> $keys = Invoke-AzResourceAction -ResourceId "$($functionApp.Id)/functions/http_Start" -Action listkeys -Force
PS C:\> ./.toolchain/New-Spoke.ps1 -Environment 't' -Service 'tstsp3' -Architype 'network' -FunctionKey $keys.default -FunctionAppName $functionApp.Name
```

#### Custom Network  Enabled Spoke

Deploy a new spoke with name t-tstsp3 using the network spoke template using /23 vnet address range and /24 subnet(s) and specify Repository Name to create

```powershell
PS C:\> Connect-AzAccount -Tenant 98989898-9898-9898-9898-989898989899 -Subscription p-gov
PS C:\> $functionApp = Get-AzResource -ResourceGroupName p-gov-cng -ResourceType 'Microsoft.Web/sites' -Name *-func
PS C:\> $keys = Invoke-AzResourceAction -ResourceId "$($functionApp.Id)/functions/http_Start" -Action listkeys -Force
PS C:\> ./.toolchain/New-Spoke.ps1 -Environment 't' -Service 'tstsp3' -Architype 'network' -VnetCIDR 23 -VnetSubnetCIDR 24 -RepoName 'TST_Demo01_t-tstsp3' -FunctionKey $keys.default -FunctionAppName $functionApp.Name
```

#### New IaaS Spoke

Deploy a new spoke with name t-tstsp3 using the iaas spoke template and replace VM roles

```powershell
PS C:\> Connect-AzAccount -Tenant 98989898-9898-9898-9898-989898989899 -Subscription p-gov
PS C:\> $functionApp = Get-AzResource -ResourceGroupName p-gov-cng -ResourceType 'Microsoft.Web/sites' -Name *-func
PS C:\> $keys = Invoke-AzResourceAction -ResourceId "$($functionApp.Id)/functions/http_Start" -Action listkeys -Force
PS C:\> $replace = @{'[#_service.vm.01.role_#]'='app';'[#_service.vm.02.role_#]'='db'}
PS C:\> ./.toolchain/New-Spoke.ps1 -Environment 't' -Service 'tstsp3' -Architype 'iaas' -Replace $replace -FunctionKey $keys.default -FunctionAppName $functionApp.Name
```

### Workload Flow

#### 1. Settings

The activity **dfa_NewSpoke01Settings** is designed to validate and process the app settings and the settings from the HTTP trigger request.

The information will be passed on to each activity in the orchestrator flow. Some activities will add information before passing it on.

##### Function App Settings

These settings are specified in the Function App Settings:

| Setting name                   | Description                                                                                                                            |
| ------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------- |
| AgreementType                  | EA (Enterprise Agreement), MCA (Microsoft Customer Agreement), MPA (Microsoft Partner Agreement).                                      |
| ArchitypesUri                  | The URI to the architype templates.                                                                                                    |
| DefaultArchitype               | The configuration architype name. This is a JSON file available at the Architype Uri.                                                  |
| DefaultEnvironment             | Default subscription environment. E.g. p (Production), d (Development), t (Test) or any other letter you choose.                       |
| DefaultBillingScope            | Default Billing Scope.                                                                                                                 |
| DefaultVnetCIDR                | The default CIDR / size to use for a Virtual Network address space (when it is not specified).                                         |
| DefaultVnetSubnetCIDR          | The default CIDR / size of subnets in a Virtual Network address space (when it is not specified).                                      |
| DefaultDeployClientId          | The default Client Id of the Deployment Account that will deploy the spoke.                                                            |
| DefaultDeployVariableGroupName | The name of the default Azure DevOps Library Variable Group that contain the variable 'DeploymentPassword' to use with DeployClientId. |
| DevTestOfferAvailable          | Is Dev / Test Subscription Offer available to the Enterprise Agreement Account. 0 = Not available, 1 = Available.                      |
| DevTestOfferEnvironments       | Environments that will be Dev / Test separated by comma. Default is d,t.                                                               |
| GitProviderType                | The git service provider type. GitHub or AzureRepos.                                                                                   |
| GitProviderAccountName         | The organization name in Azure DevOps or GitHub.                                                                                       |
| GitProviderProject             | The project name in Azure DevOps.                                                                                                      |
| GitProviderLogonName           | The logon name for GitHub. Should be empty for AzureRepos.                                                                             |
| GitUserName                    | The git user name.                                                                                                                     |
| GitUserEmail                   | The git user email.                                                                                                                    |
| SuperNet                       | The Virtual Datacenter network address space.                                                                                          |

##### Key Vault secrets

These secrets are referenced in the Function App Settings:

| Setting name          | Description                      |
| --------------------- | -------------------------------- |
| AzMonitorWorkspaceId  | The Log Analytics workspace Id.  |
| AzMonitorWorkspaceKey | The Log Analytics workspace Key. |
| GitPassword           | The git password.                |

> 💡 **NOTE**:
>
> The Key Vault secret **GitPassword** value must be a valid **Personal Access Token** with
> permission to access and create repositories and workflows.
> The Key Vault is in the same Resource Group as the **Concierge** Function App.
> Remember that a Personal Access Token will expire.
> When this happen a new token must be created and **GitPassword** must be updated.

##### HTTP trigger request

These settings can be specified in the HTTP trigger request:

| Setting name            | Default | Description                                                                                                                                                                                                                     |
| ----------------------- | :-----: | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Architype               | network | The name of the configuration architype JSON template.                                                                                                                                                                          |
| BillingScope            |         | Billing Scope used to create subscription when subscription do not exist.                                                                                                                                                       |
| DeployClientId          |         | The Client Id of the Deployment Account that will deploy the spoke. If not specified and a default is not set, the one specified in architype template will be used.                                                            |
| DeployVariableGroupName |         | The name of the Azure DevOps Library Variable Group that contain the variable 'DeploymentPassword' to use with DeployClientId. If not specified and a default is not set, the one specified in architype template will be used. |
| Environment             |    p    | Subscription environment. p (Production), d (Development), t (Test) or any other letter you choose.                                                                                                                             |
| Replace                 |         | Optional replaceStrings (name/key and value) to update in the architype template.                                                                                                                                               |
| RepoName                |         | The name of the Git Repository that will be used or created. This will default to subscription name (environment-service).                                                                                                      |
| Service                 |         | Service or Project name. This must be specified. Between 1-6 characters long.                                                                                                                                                   |
| VnetCIDR                |   25    | The CIDR / size to use for the Virtual Network address space (IPv4).                                                                                                                                                            |
| VnetSubnetCIDR          |   26    | The CIDR / size of each subnet in the Virtual Network address space (IPv4).                                                                                                                                                     |
| WorkflowStart           |  true   | Start the pipeline/workflow after creating it.                                                                                                                                                                                  |
| WorkflowPath            |    \    | Create the pipeline/workflow in this folder.                                                                                                                                                                                    |

Example request body:

```json
{
  "Architype": "network",
  "Environment": "p",
  "Service": "gemini",
  "RepoName": "AZ_VDC_Spoke_p-gemini",
  "Replace": {
    "[#_service.vm.01.role_#]": "app1",
    "[#_service.vm.02.role_#]": "app2"
  }
}
```

#### 2. Subscriptions

The activity **dfa_NewSpoke02Subscription** is designed to get or create specified Azure subscription.

When App Setting **AgreementType** is **EA** or **MCA**, and the subscription do not exist, this activity will try to create it.

The **DevTestOfferAvailable** setting is used to determine if **Dev/Test** subscriptions can be created. Set this to "1" if it can. EA customers can set the **Dev/Test** setting in the [EA Portal](https://ea.azure.com/) under **Manage** > **Account**.

The **DevTestOfferEnvironments** setting can override the default environments that will result in a **Dev/Test** subscription. The default is **d,t** and will create **Dev/Test** subscription if the setting **Environment** is either **d** or **t** and **DevTestOfferAvailable** is **1**.

If the App Setting **AgreementType** is **MPA**, the subscription must be created manually and moved to the VDC Root Management Group before invoking **dfo_NewSpoke**.

#### 3. Network

The activity **dfa_NewSpoke03Network** is designed to get one unused IPv4 address space for the spoke to be used in architype templates that has a virtual network.

To find the address space, the following steps are taken:

1. Get a list of existing Virtual Network address spaces in use. This is done using a [Resource Graph](https://portal.azure.com/#blade/HubsExtension/ArgQueryBlade) query:

    ```kusto
    Resources | where type =~ 'microsoft.network/virtualnetworks'
    | mv-expand addressPrefix = properties.addressSpace.addressPrefixes
    | project cidr = tostring(addressPrefix)
    | union (Resources | where type =~ 'microsoft.network/virtualhubs' | project cidr = tostring(properties.addressPrefix))
    | order by cidr desc
    ```

2. Get all possible networks in **SuperNet** (from App Setting) e.g. 10.162.0.0/16 based on size specified in **VnetCIDR**, e.g. /25.
3. All networks from step 1 that are not included in **SuperNet** will be ignored.
4. Use the list from step 1 to remove used networks from the list from step 2.
5. Sort the list from step 2 so the lowest network is first.
6. Get the first network from the list.

::: warning
It is possible that the same network can be given to more than one spoke if **dfo_NewSpoke** is used again before the spoke is deployed.
:::

#### 4. GIT Repository

The activity **dfa_NewSpoke04GitRepo** is designed to get or create the git repository specified in the **RepoName** setting.

If **RepoName** is not specified, the repository will default to the subscription name.

If repository exist, the spoke config and workflow will be added to that repository. This make it possible to have one repository with multiple spoke configurations.

At the time of writing, only **Azure Repos** is supported (**GitProviderType** is set to **AzureRepos**).

#### 5. Configure Spoke

The activity **dfa_NewSpoke05ConfigureSpoke** is designed to perform the following tasks:

1. Clone specified git repository.
1. Download the deployment workflow template and the spoke architype template specified in the **Architype** setting.
1. Update the spoke architype template with spoke configuration.
1. Push changes to git remote repository.

Git is configured to use the **GitUserEmail** and **GitUserName** from the Function App Settings as identity for git commit.

If **Architype** is not specified, the App Setting **DefaultArchitype** will be used. If **DefaultArchitype** is not specified, **network** will be used.

The workflow template, **deploy.template.azure-pipelines.yml**, will be saved in the folder **'.pipelines'** under the name 'deploy.' + 'subscription name' + '.azure-pipeline.yml'. For example '.pipelines/deploy.t-gemini.azure-pipeline.yml'.

If **DeployVariableGroupName** has been specified, the function will search for a line in the workflow template that starts with _'- group: '_, and if found replace the existing variable group name in that line with what is specified in the **DeployVariableGroupName** setting.

The architype template, for example **network.json**, will be saved in the repository root under the name 'subscription name' + '.json'. For example 't-gemini.json'.

The architype template must include the config file name **spoke.json** because this function will search for that name and replace it with the name of the config file (see name example above).

The following will or can be replaced in replaceStrings of the spoke architype template:

| Replace key                                          | Replace value                                                                                                               |
| ---------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| [#_service.deployClient.id_#]                 | If the setting **DeployClientId** is specified, then this is replaced.                                                      |
| [#_service.subscription.id_#]                | The subscription id of the subscription from the 'Azure Subscription' activity.                                             |
| [#_service.name_#]                            | The value of the **Service** setting.                                                                                       |
| [#_service.environment_#]                     | The value of the **Environment** setting.                                                                                   |
| [#_service.vnet.addressPrefix_#]             | The address space from the 'Network' activity.                                                                              |
| [#_service.vnet.subnet.01.addressPrefix_#] | The first subnet of the address space from the 'Network' activity when split into subnets based on the **VnetSubnetCIDR**.  |
| [#_service.vnet.subnet.02.addressPrefix_#] | The second subnet of the address space from the 'Network' activity when split into subnets based on the **VnetSubnetCIDR**. |
| [#_service.managementgroup_#]                 | If the setting **Environment** is a Dev/Test environment, then this is set to the value 'non'.                              |
| [#_service.managementgroup_#]                 | If the setting **Environment** is a Dev/Test environment, then this is set to the value 'non'.                              |
| [#_recoveryservices.rundate_#]                | This will be updated to the next saturday.                                                                                  |
| [#_softwareupdate.run.startdate_#]           | This will be updated to the next day.                                                                                       |

The spoke arcihtype template can include as many subnets that the vnet can be split into, e.g. if the vnet have address space 10.162.10.0/24 and the **VnetSubnetCIDR** setting is 26, the template can have four subnets in it and can use [#_service.vnet.subnet.03.addressPrefix_#] and [#_service.vnet.subnet.04.addressPrefix_#] in addition to the above.

Any other key and value can be specified for replacement with the **Replace** setting. For example:

```json
  "Replace": {
    "[#_service.vm.01.role_#]": "app1",
    "[#_service.vm.02.role_#]": "app2"
  }
```

#### 6. Workflow

The activity **dfa_NewSpoke06Workflow** is designed to create an Azure Pipeline that will deploy the new spoke configuration and then start it.

The pipeline will be created in the path specified with the the **WorkflowPath** setting. If **WorkflowPath** is not specified it will be created in the root folder.

The Pipeline name will start with the repository name. If the repository name do not contain the subscription name then subscription name is added. The word 'Deploy' is added at the end. For example 'p-gemini Deploy'.

The Pipeline will be started, unless the **WorkflowStart** setting is set to false.

At the time of writing, only **Azure Pipelines** is supported (**GitProviderType** is set to **AzureRepos**). **GitHub Actions** support is going to be added in a future version.

#### 7. Clean Up

The activity **dfa_NewSpoke99Cleanup** is designed to clean up after running **dfo_HealthCheck** or **dfo_NewSpoke**. Clean up include the following steps:

* Delete local repository.
* Delete remote repository if an error occur or when running Health Check, but only if the repository was created in the 'Git repository' activity.
* Delete Azure Pipeline if an error occur or when running Health Check, but only if the pipeline was created in the 'Workflow' activity.

### `New-Spoke.ps1` Script

The code below defines the sample script

```powershell
<#
.SYNOPSIS
  Deploy a new spoke using Concierge Function App
.DESCRIPTION
  The Concierge has a Function that is designed to automate the process of
  commissioning a new spoke in the VDC.
.EXAMPLE
  PS C:\> Connect-AzAccount -Tenant 98989898-9898-9898-9898-989898989899 -Subscription p-gov
  PS C:\> $functionApp = Get-AzResource -ResourceGroupName p-gov-cng -ResourceType 'Microsoft.Web/sites' -Name *-func
  PS C:\> $keys = Invoke-AzResourceAction -ResourceId "$($functionApp.Id)/functions/http_Start" -Action listkeys -Force
  PS C:\> ./New-Spoke.ps1 -Environment 't' -Service 'tstsp3' -Architype 'network' -FunctionName 'dfo_HealthCheck' -FunctionKey $keys.default -FunctionAppName $functionApp.Name
  Run HealthCheck to verify configuration and access.
.EXAMPLE
  PS C:\> Connect-AzAccount -Tenant 98989898-9898-9898-9898-989898989899 -Subscription p-gov
  PS C:\> $functionApp = Get-AzResource -ResourceGroupName p-gov-cng -ResourceType 'Microsoft.Web/sites' -Name *-func
  PS C:\> $keys = Invoke-AzResourceAction -ResourceId "$($functionApp.Id)/functions/http_Start" -Action listkeys -Force
  PS C:\> ./New-Spoke.ps1 -Environment 't' -Service 'tstsp3' -Architype 'network' -FunctionKey $keys.default -FunctionAppName $functionApp.Name
  Deploy a new spoke with name t-tstsp3 using the network spoke template using default values
.EXAMPLE
  PS C:\> Connect-AzAccount -Tenant 98989898-9898-9898-9898-989898989899 -Subscription p-gov
  PS C:\> $functionApp = Get-AzResource -ResourceGroupName p-gov-cng -ResourceType 'Microsoft.Web/sites' -Name *-func
  PS C:\> $keys = Invoke-AzResourceAction -ResourceId "$($functionApp.Id)/functions/http_Start" -Action listkeys -Force
  PS C:\> ./New-Spoke.ps1 -Environment 't' -Service 'tstsp3' -Architype 'network' -VnetCIDR 23 -VnetSubnetCIDR 24 -RepoName 'TST_Demo01_t-tstsp3' -FunctionKey $keys.default -FunctionAppName $functionApp.Name
  Deploy a new spoke with name t-tstsp3 using the network spoke template using /23 vnet address range and /24 subnet(s) and specify Repository Name to create
.EXAMPLE
  PS C:\> Connect-AzAccount -Tenant 98989898-9898-9898-9898-989898989899 -Subscription p-gov
  PS C:\> $functionApp = Get-AzResource -ResourceGroupName p-gov-cng -ResourceType 'Microsoft.Web/sites' -Name *-func
  PS C:\> $keys = Invoke-AzResourceAction -ResourceId "$($functionApp.Id)/functions/http_Start" -Action listkeys -Force
  PS C:\> $replace = @{'[#_service.vm.01.role_#]'='app';'[#_service.vm.02.role_#]'='db'}
  PS C:\> ./New-Spoke.ps1 -Environment 't' -Service 'tstsp3' -Architype 'iaas' -Replace $replace -FunctionKey $keys.default -FunctionAppName $functionApp.Name
  Deploy a new spoke with name t-tstsp3 using the iaas spoke template and replace VM roles
.PARAMETER Environment
  Subscription environment. p (Production), d (Development), t (Test) or any other letter you choose.
.PARAMETER Service
  Service or Project name. This must be specified. Between 1-6 characters long.
.PARAMETER FunctionAppName
  The name of the Function App.
.PARAMETER FunctionKey
  The Function Key (secret) that allow access to the http_Start function of the Concierge app.
.PARAMETER TenantId
  The Id of the tenant if the Function App (alternative to using FunctionKey).
.PARAMETER Credential
  The Credentials to access the Function App (alternative to using FunctionKey).
.PARAMETER Architype
  The name of the configuration architype JSON template.
  Defaults to the Function App Application setting with the name DefaultArchitype.
  Other options include all json file names under the .architypes folder. E.g. iaas, paas and empty.
.PARAMETER BillingScope
  Billing Scope used to create subscription when subscription do not exist.
  Defaults to the Function App Application setting with the name DefaultBillingScope.
.PARAMETER DeployClientId
  The Client Id of the Deployment Account that will deploy the spoke.
  If not specified and a default is not set, the one specified in architype template will be used.
.PARAMETER DeployVariableGroupName
  The name of the Azure DevOps Library Variable Group that contain the variable 'DeploymentPassword'
  to use with DeployClientId. If not specified and a default is not set, the one specified
  in architype template will be used.
.PARAMETER Replace
  Optional replaceStrings (name/key and value) to update in the architype template.
  This should correspond with replaceStrings in the architype template.
.PARAMETER RepoName
  The name of the Git Repository that will be used or created.
  This will default to subscription name (environment-service).
.PARAMETER VnetCIDR
  The CIDR / size to use for the Virtual Network address space (IPv4). Default is 25.
.PARAMETER VnetSubnetCIDR
  The CIDR / size of each subnet in the Virtual Network address space (IPv4). Default is 26.
.PARAMETER WorkflowStart
  Start the pipeline/workflow after creating it. Default is true = start workflow, false = do not start workflow.
.PARAMETER WorkflowPath
  Create the pipeline/workflow in this path. Default is \.
.PARAMETER FunctionName
  The name of the Function that will be started.
  The value dfo_HealthCheck will run a test to verify configuration and access.
.OUTPUTS
  The output of Invoke-RestMethod.
#>
[CmdletBinding(
  ConfirmImpact = 'Medium',
  SupportsShouldProcess = $True,
  DefaultParameterSetName = 'Key'
)]
param (
  [Parameter(Mandatory = $true, ParameterSetName = 'Key')]
  [Parameter(Mandatory = $true, ParameterSetName = 'Credential')]
  [string]
  $Environment,
  [Parameter(Mandatory = $true, ParameterSetName = 'Key')]
  [Parameter(Mandatory = $true, ParameterSetName = 'Credential')]
  [string]
  $Service,
  [Parameter(Mandatory = $true, ParameterSetName = 'Key')]
  [Parameter(Mandatory = $true, ParameterSetName = 'Credential')]
  [string]
  $FunctionAppName,
  [Parameter(Mandatory = $true, ParameterSetName = 'Key')]
  [string]
  $FunctionKey,
  [Parameter(Mandatory = $true, ParameterSetName = 'Credential')]
  [ValidateNotNullOrEmpty()]
  [string]
  $TenantId,
  [Parameter(Mandatory = $true, ParameterSetName = 'Credential')]
  [ValidateNotNullOrEmpty()]
  [System.Management.Automation.PSCredential]
  $Credential,
  [Parameter(Mandatory = $false, ParameterSetName = 'Key')]
  [Parameter(Mandatory = $false, ParameterSetName = 'Credential')]
  [string]
  $Architype = 'network',
  [Parameter(Mandatory = $false, ParameterSetName = 'Key')]
  [Parameter(Mandatory = $false, ParameterSetName = 'Credential')]
  [string]
  $BillingScope,
  [Parameter(Mandatory = $false, ParameterSetName = 'Key')]
  [Parameter(Mandatory = $false, ParameterSetName = 'Credential')]
  [string]
  $DeployClientId,
  [Parameter(Mandatory = $false, ParameterSetName = 'Key')]
  [Parameter(Mandatory = $false, ParameterSetName = 'Credential')]
  [string]
  $DeployVariableGroupName,
  [Parameter(Mandatory = $false, ParameterSetName = 'Key')]
  [Parameter(Mandatory = $false, ParameterSetName = 'Credential')]
  [hashtable]
  $Replace,
  [Parameter(Mandatory = $false, ParameterSetName = 'Key')]
  [Parameter(Mandatory = $false, ParameterSetName = 'Credential')]
  [string]
  $RepoName,
  [Parameter(Mandatory = $false, ParameterSetName = 'Key')]
  [Parameter(Mandatory = $false, ParameterSetName = 'Credential')]
  [string]
  $VnetCIDR = '25',
  [Parameter(Mandatory = $false, ParameterSetName = 'Key')]
  [Parameter(Mandatory = $false, ParameterSetName = 'Credential')]
  [string]
  $VnetSubnetCIDR = '26',
  [Parameter(Mandatory = $false, ParameterSetName = 'Key')]
  [Parameter(Mandatory = $false, ParameterSetName = 'Credential')]
  [string]
  $WorkflowStart = 'true',
  [Parameter(Mandatory = $false, ParameterSetName = 'Key')]
  [Parameter(Mandatory = $false, ParameterSetName = 'Credential')]
  [string]
  $WorkflowPath = '\',
  [Parameter(Mandatory = $false, ParameterSetName = 'Key')]
  [Parameter(Mandatory = $false, ParameterSetName = 'Credential')]
  [string]
  $FunctionName = 'dfo_NewSpoke'
)
begin {
  Set-StrictMode -Version Latest;
  $output = '';
  $stopwatch = [System.Diagnostics.Stopwatch]::StartNew();
}
process {
  if ($PSCmdlet.ShouldProcess("$Environment-$Service", 'New-Spoke')) {
    $uri = "https://$($FunctionAppName).azurewebsites.net/api/orchestrators/$($FunctionName)";
    $webHookUri = $(
      if ('Key' -eq $PSCmdlet.ParameterSetName) {
        "$($uri)?code=$($FunctionKey)";
      } else {
        $uri;
      };
    );
    $headers = $(
      if ('Key' -eq $PSCmdlet.ParameterSetName) {
        @{
          Accept = 'application/json';
        };
      } else {
        $url = "https://login.microsoftonline.com/$($TenantId)/oauth2/token";
        $secret = $Credential.GetNetworkCredential().Password;
        $body = @{
          grant_type    = 'client_credentials';
          client_id     = $Credential.UserName;
          client_secret = $secret;
          resource      = "https://$($FunctionAppName).azurewebsites.net";
        };
        $response = Invoke-RestMethod -Method Post -Uri $url -Body $body;
        if (
          (Test-IsEmptyVariable -Object $response) -or
          $response -isnot [pscustomobject] -or
          -not([bool]($response | Get-Member -Name access_token))
        ) {
          throw 'Unable to get Access Token';
        };
        @{
          Accept        = 'application/json';
          Authorization = "Bearer $($response.access_token)";
        };
      };
    );
    $body = @{
      Project     = $Service;
      Environment = $Environment;
      Architype   = $Architype;
    };
    if (-not([string]::IsNullOrWhiteSpace($BillingScope))) {
      $body.Add('BillingScope', $BillingScope);
    };
    if (-not([string]::IsNullOrWhiteSpace($DeployClientId))) {
      $body.Add('DeployClientId', $DeployClientId);
    };
    if (-not([string]::IsNullOrWhiteSpace($DeployVariableGroupName))) {
      $body.Add('DeployVariableGroupName', $DeployVariableGroupName);
    };
    if (-not([string]::IsNullOrWhiteSpace($RepoName))) {
      $body.Add('RepoName', $RepoName);
    };
    if (-not([string]::IsNullOrEmpty($Replace))) {
      $body.Add('Replace', $Replace);
    };
    if (-not([string]::IsNullOrWhiteSpace($VnetCIDR))) {
      $body.Add('VnetCIDR', $VnetCIDR);
    };
    if (-not([string]::IsNullOrWhiteSpace($VnetSubnetCIDR))) {
      $body.Add('VnetSubnetCIDR', $VnetSubnetCIDR);
    };
    if (-not([string]::IsNullOrWhiteSpace($WorkflowStart))) {
      $body.Add('WorkflowStart', $WorkflowStart);
    };
    if (-not([string]::IsNullOrWhiteSpace($WorkflowPath))) {
      $body.Add('WorkflowPath', $WorkflowPath);
    };
    $body = $body | ConvertTo-Json -Compress -Depth 99;
    Write-Host -Object "Posting request to $($uri), please wait for response...";
    $response = Invoke-RestMethod -Uri $webHookUri -Headers $headers -Method Post -Body $body -ContentType 'application/json';
    if ([string]::IsNullOrEmpty($response)) {
      Write-Warning -Message "Failure: No response after posting to $uri";
    } elseif (-not([bool]($response | Get-Member -Name statusQueryGetUri))) {
      Write-Warning -Message "Failure: Expected to find property 'statusQueryGetUri' in response:";
      $output = $response | ConvertTo-Json -Depth 99;
    } else {
      $runtimeStatus = '';
      $timeout = New-TimeSpan -Minutes 10;
      $status = $null;
      do {
        $status = Invoke-RestMethod -Uri $response.statusQueryGetUri -Method Get -ContentType 'application/json';
        $runtimeStatus = $(
          if (
            $null -ne $status -and
            [bool]($status | Get-Member -Name runtimeStatus)
          ) {
            $status.runtimeStatus;
          } else {
            'Completed';
          };
        );
        if ($runtimeStatus -ne 'Completed') {
          Write-Host -Object "$($runtimeStatus). $($stopwatch.Elapsed.Minutes.ToString('00')) minutes $($stopwatch.Elapsed.Seconds.ToString('00')) seconds elapsed";
          Start-Sleep -Seconds 10;
        };
      } until (
        $runtimeStatus -eq 'Completed' -or
        $stopwatch.Elapsed -ge $timeout
      );
      if ($runtimeStatus -ne 'Completed') {
        Write-Warning -Message "Giving up: '$($runtimeStatus)' status after $($stopwatch.Elapsed.Minutes.ToString('00')) minutes $($stopwatch.Elapsed.Seconds.ToString('00')) seconds. Get status from $($response.statusQueryGetUri)";
      } elseif ($null -eq $status) {
        Write-Warning -Message "Failure: No response from $($response.statusQueryGetUri)";
      } elseif (-not([bool]($status | Get-Member -Name output))) {
        Write-Warning -Message "Failure: Missing output in response";
      };
      $output = $status.output | ConvertTo-Json -Depth 99;
    };
  };
}
end {
  $stopwatch.Stop();
  Write-Output -InputObject $output;
};

```
