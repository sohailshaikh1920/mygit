## Modules Library

The modules library is made up of maintained Azure resource manager (ARM) templates. Each module performs one small function, to deploy or configure one or several resources in Azure. This can be as simple as deploying a single storage account, or as complex as deploying a virtual machine and all of its dependencies.

### Use Cases

The modules library is used to deploy and configure almost all of the Azure Cloud Framework. Modules exist for different scope levels like resource groups, subscriptions and Management Groups. Each module:

* Takes parameters as inputs to customize the deployment. Some of these parameters are mandatory and some are optional.
* Implements the data centre naming standard. This standard can be overridden outside of the data centre context.
* Produce a set of outputs from the deployment, like resource information such as names and resource IDs.

### Code Versioning

When a new version of a module is released, it becomes available through a URL. The URL includes a date stamp that serves as the module version number (following the *CalVer* standard).

::: note
The code for the modules library is included in project delivery. This is a one-time copy of the code based on the release used for the delivery.

Managed Service Customers are offered GitHub access to the repositories
:::

If a module is not sufficient or no longer work, the options are:

* Update an existing module and make it available to the deployment method of choice, either via file path or a URL.
* Create a new module and make it available to the deployment method of choice, either via file path or a URL.
* If a maintenance contract exist with Innofactor, submit a request for additional code, a code change, or a new module.

### Module Structure

Each module is constructed as follows:

* One or more markdown files that provide documentation for the module.
* One or more Bicep or ARM template files, where each file has:
  * **Parameters:** A mix of mandatory/optional inputs to customize the deployment of the module.
  * Variables: Calculated on-the-fly values and manipulated parameter values.
  * **Resources:** Executing the deployment of the module resource and any dependencies. Some dependencies are optional based on parameter values.
  * **Outputs:** Values that may be useful as parameter inputs for other resources, for example VNet resource ID for a virtual machine deployment.
* One or more sample parameter files: Examples of usage of the module.

The files of the module are available through URLs structured after a specific pattern. A typical module will have the following files:

|File type|Url pattern|
|---|---|
|Documentation|`https://{host}/modules/{modulename}/{datestamp}/README.md`
|Json template|`https://{host}/modules/{modulename}/{datestamp}/{name}.json`
|Bicep template|`https://{host}/modules/{modulename}/{datestamp}/{name}.bicep`
|Parameter file|`https://{host}/modules/{modulename}/{datestamp}/{name}.parameters.json`

All current templates are [published and indexed](https://iacinnofactor.azurewebsites.net/) for an overview of existing templates.

### Module Usage

Modules can be used in a number of ways:

* In a configuration file.
* Explicitly called from PowerShell or Azure CLI scripts.
* Executed as nested/linked deployments from ARM templates.
