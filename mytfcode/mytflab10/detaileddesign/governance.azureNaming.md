## Naming

A consistent naming standard for Azure objects supports the operation and management of the environment, but also provides a fabric to enable governance, including audit and cost management of the resources deployed.

It is important to define and follow a naming convention that gives [guidance for naming resources](https://docs.microsoft.com/en-us/azure/guidance/guidance-naming-conventions).

### Guiding Principals

The establishment of good naming standard before implementing different types of resources is imperative, as it can be difficult, or sometimes impossible to rename them afterwards. This must also support the subscription and Management Group structure. Consider the following when preparing for a convention:

* Names/Tags can be used for billing drill-down.
* Names/Tags can be used for data analysis.
* Names are surfaced at the top level of the portal.
* Names are used in business applications and in automation etc.
* Tags are metadata for the object.
* Tags are used to provide context that a name cannot.

The following naming convention template will be taken as the reference to define the required standards:

* Names are constructed of elements.
* Use hyphen to separate elements, drop hyphens when not allowed such as for Storage Accounts.
* Lower case is required for some object names such as Storage, Containers, and Queues.
* Some object names, such as storage blobs, are case sensitive.
* There should not be any spaces in the resource name.
* Highly available resources should include an instance number.
* Constructs created from multiple resources should postfix a resource type short code.

Adapt the following guidance for the special characters used in the naming standards:

| Character       | Can be used | Example | Comment                                             |
| --------------- | ----------- | ------- | --------------------------------------------------- |
| Hyphen          | Yes         | -       | Do not use as the first or last character in a name |
| Dash            | No          | -       | Use hyphen instead                                  |
| Period          | Yes         | .       | Do not use as the first or last character in a name |
| Underscore      | Yes         | _       | Do not use as the first or last character in a name |
| Parentheses     | Yes         | ( )     | Do not use as the first or last character in a name |
| Square brackets | No          | [ ]     | Use parentheses instead                             |
| Curly brackets  | No          | { }     | Use parentheses instead                             |
| Angle brackets  | No          | < >     | Use parentheses instead                             |

We consider the following as guiding principles in defining a convention:

* The convention **must** describe the type of resource in the subscription. Important: Some resources must be uniquely named across entire Azure.
* The naming pattern must support easy application-level grouping for show-back/charge-back billing when required. Note that some resources are constrained by their identifier length and case sensitivity.
* If the object is tied to a location, the name should include the location code. As an example, services like **Cosmos**, and **Container Registries** are deployed to the instance location, but within their configuration, replication locations maybe enabled, which will result in a resource been created that should be named appropriately.

### Naming Constraints

Azure provides two options to assist in the implementation of a consistent and usable naming convention. The options initially appear to be extremely flexible and allow for an extremely customization and propose driven configuration to be implemented. However, once the limitations and constraints are truly understood; the ability to deliver a consistent and standard naming convention is quite rigid.

All naming conventions are constructed based on a set of building block or naming elements and combined with the constraints on the associated resource which is been deployed. Additionally, the two options presented to us, are never used mutually exclusively; but rather as a combined solution to manage our resources. These options are:

* Resource Name
  * Multiple Constraints, examples include Uniqueness scope, Character Set, Length, Alpha-Numerical, and many others.
* Tags
  * Name-value pairs assigned to resources or groups.
  * Subscription-wide taxonomy.
  * Each resource can have up to 15 tags.

#### Unique Names

Some resources require unique names, this includes:

* Storage accounts
* Web sites
* SQL servers
* Key vaults
* Redis caches
* Batch accounts
* Traffic managers
* Search services
* HDInsight clusters
* Public Names

#### Public Names (Domain Names)

Public names (i.e. a domain name) can be up to 255 characters long.

* Azure TLD's consume almost 40 characters, allowing 200 characters for the sub domain.
* Azure restrictions, permit only 63 of these characters to be used for public IP's.
* Public IPs can only contain alphanumeric characters and hyphen.

#### Storage Accounts Names

The most restrictive length for a global resource name is 24 characters, as permitted for Storage Accounts.

There is every chance that we could get away with an un-obfuscated version, but it would be so terse it would almost look the same. It would also make edge cases, and conflicts hard to redefine. This method should be relatively future proof and extensible if need be. If in future, the restrictions on these names are redefined, we can re-visit this logic to ensure it is still suitable.

> `{environment}{workload}{role}{type}{unique}`

More information on Naming rules and restrictions for Azure resources can be found from [Microsoft’s Site](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules)

### Naming Elements

The primary purpose of naming conventions in Azure is to get a better way to navigate and maintain system and services hosted on Azure. A good convention should be easy to understand and learn, while also enabling a more detailed and clearer overview in regard to service distribution, billing and usage of services.

For naming to be understandable and effective, a set of quickly indefinable elements should be concatenated in a defined pattern to establish the naming standard.

The following table identifies the elements that should be used for building the naming pattern, including abbreviations which have been adopted to keep the names short and concise where relevant:

| Element                                  | Length | Content                              |
| ---------------------------------------- | ------ | ------------------------------------ |
| [Environment](#environment)              | 1      | Purpose identifier.                  |
| Service                                  | 1 - 6  | Primary service or project name.     |
| Role(#resource-role-short-codes)         | 1 - 7  | The role of the resource(s).         |
| Instance                                 | 2      | Numeric sequence for uniqueness.     |
| [Purpose](#resource-purpose-short-codes) | 2 - 8  | Resource purpose short code.         |
| [Type](#resource-type-short-codes)       | 2 - 15 | Resource type short code.            |
| [Subnet](#subnet-naming-standard)        | 7 - 20 | Subnet identifier*.                  |
| Unique                                   | 1 - 13 | Random characters (globally unique). |

The following table identifies the elements used for **Azure Active Directory** groups:

| Element                          | Length | Content                                                     |
| -------------------------------- | ------ | ----------------------------------------------------------- |
| Prefix                           | 7      | A prefix short code for the group.                          |
| [Type](#target-type-short-codes) | 2 - 3  | A target type short code.                                   |
| Scope                            | 1 - 20 | The name of the target scope.                               |
| Resource                         | 1 - 20 | The name of a specific resource in target scope (optional). |
| Right                            | 1 - 20 | The target privilege (Optional).                            |
| Delegation                       | 1 - 11 | The role to be delegated.                                   |

> The **Delegation** element must match the name of a valid role for the specific scope or resource. To find valid role names, open the scope or resource in the Azure portal and select **Access control (IAM)** and then **Roles**.

#### Resource Purpose Short Codes

In order to keep the name short, we use a short code to describe the purpose of a resource. This code will be used in the resource name of some resources and are optional on others.

The following is a list of common short codes for purpose:

* **osdisk**: Virtual machine operating system disk.
* **datadisk**: Virtual machine data disks.
* **log**: Storage account log disk.
* **diag**: Storage account diagnostics storage.
* **audit**: Storage account audit storage.
* **arch**: Storage account archive storage.

#### Resource Role Short Codes

A resource may have multiple purposes, in order to keep the name short a short code is leveraged to describe the role that this resource would function as in the infrastructure.

The following is a list of common short codes for purpose:

* **adf**: ADFS Server
* **dfs**: file server
* **rd**: Remote Desktop Host
* **rdgw**: Remote Desktop Gateway
* **dc**: Domain Controller
* **ca**: Certificate Authority
* **nps**: Network Policy Server
* **sql**: SQL Server
* **clu**: cluster

#### Resource Type Short Codes

In order to keep the name short, we use a short code for resource types. This code will be used as a postfix in the resource name and make it possible to identify the resource type by looking at the name.

The following is a list of common short codes for resource types:

| Resource type                                        | Short code      |
| ---------------------------------------------------- | --------------- |
| Action group                                         | ag              |
| Action rule                                          | ar              |
| API Management service                               | apim            |
| App Service Certificate                              | ascert          |
| App Service web app                                  | web             |
| App Service plan                                     | plan            |
| Application gateway                                  | agw             |
| Application gateway (Web Application Firewall / WAF) | waf             |
| Application gateway (WAF policy)                     | policy          |
| Application group                                    | appgroup        |
| Application Insights                                 | insights        |
| Application security group                           | asg             |
| Automation Account                                   | auto            |
| Availability set                                     | as              |
| Azure compute gallery                                | gal             |
| Azure Database for MySQL server database             | mysqldb         |
| Azure Database for MySQL server                      | mysql           |
| Bastion                                              | bastion         |
| Batch account                                        | ba              |
| Connection                                           | con             |
| Container instance                                   | aci             |
| Data bricks                                          | dbw             |
| Data factory                                         | adf             |
| Deployment script                                    | script          |
| DDoS protection plan                                 | ddos-plan       |
| Event Grid System Topic                              | egst            |
| Event Hub                                            | eh              |
| ExpressRoute circuit                                 | circuit         |
| ExpressRoute gateway                                 | er              |
| ExpressRoute connection                              | conn            |
| Firewall                                             | fw              |
| Firewall Policy                                      | firewallpolicy  |
| Function App                                         | func            |
| Host pool                                            | hostpool        |
| Image template                                       | imgtemplate     |
| IP Group                                             | ipgroup         |
| Key vault                                            | kv              |
| Load balancer                                        | lb              |
| Local network gateway                                | lgw             |
| Log Analytics query pack                             | laqp            |
| Log Analytics workspace                              | ws              |
| Logic app                                            | logicapp        |
| Logic app workflow                                   | logic           |
| Managed Identity                                     | id              |
| Network interface                                    | nic             |
| Network profile                                      | networkprofile  |
| Network security group                               | nsg             |
| Network Watcher                                      | networkwatcher  |
| NSG Flow log                                         | flowlog         |
| P2S VPN Gateway                                      | p2s             |
| Private endpoint                                     | privateendpoint |
| Public IP address                                    | pip             |
| Public IP Prefix                                     | pipprefix       |
| Recovery Services vault                              | rsv             |
| Route table                                          | rt              |
| SendGrid account                                     | sendgrid        |
| Service Bus                                          | sbn             |
| SQL database                                         | sqldb           |
| SQL elastic pool                                     | sqlep           |
| SQL job agent                                        | sqlagent        |
| SQL managed instance                                 | sqlmi           |
| SQL managed instance database                        | sqlmidb         |
| SQL server                                           | sqlsvr          |
| SQL Server Integration Services                      | ssis            |
| Traffic Manager profile                              | tm              |
| Virtual hub                                          | hub             |
| Virtual network                                      | vnet            |
| Virtual network gateway / VPN gateway                | vpn             |
| Virtual WAN                                          | vwan            |
| VM image definition                                  | imgdef          |
| VPN Site                                             | vpnsite         |
| Workspace                                            | workspace       |

#### Target Type Short Codes

The following is a list of common short codes for target types:

* **mg**: Management Group.
* **res**: Resource.
* **rg**: Resource Group.
* **sub**: Subscription.

### Naming Conflicts

It is unlikely that if we follow these rules for global naming that we will run into any naming conflicts with other Azure users. However, the chance still exists, so we need a strategy for coping with such conflicts. This needs to fit in with our other tooling for deployments.

Therefore, overrides need to be baked into the naming strategy.

For example, adding a three-digit number to the end of the resource name should produce a sufficiently distinct name. The largest three-digit prime, whose digits are also prime is 773, so use that as a starting point.

* Given the previous example:
* ARM Function: uniqueString('dev', 'jumpbox', '01', 'westeurope') = qmpqjguelqesx
* We would then append 773.
* Generating the new example:
* ARM Function: uniqueString('dev', 'jumpbox', '01', 'westeurope','733') = kbqpcmwfniecj
* The resulting string is then significantly different.
* Should this also fail, work upward in primes from 773.

The likelihood of having to do this is negligible.

### Naming Standard

With an understanding of the constraints, and elements available to us, we will now define the standard, following the natural hierarchy structure of Azure.

### Azure Active Directory Group Vaming Standard

Azure Active Directory don't implement an OU based construct. The alternative is to ensure that the group names are easily identified.

A structured naming standard should be used for all group names regardless of originating directory source (Azure AD or On-Premise AD).

Naming pattern for role-based access group:

> {**Prefix**} {**Type**} {**Scope**} \[{**Resource**} \[{**Right**}]] {**Delegation**}

Examples:

| Prefix  | Type | Scope                   | Resource            | Right       | Delegation                  | Sample                                                  |
| ------- | ---- | ----------------------- | ------------------- | ----------- | --------------------------- | ------------------------------------------------------- |
| AZ RBAC | mg   | Governance Subscription |                     |             | Owner                       | AZ RBAC mg Governance Subscription Operator             |
| AZ RBAC | sub  | p-we1net                |                     |             | Reader                      | AZ RBAC sub p-we1net Reader                             |
| AZ RBAC | rg   | p-we1net-network        |                     |             | Storage Account Contributor | AZ RBAC rg p-we1net-network Storage Account Contributor |
| AZ RBAC | res  | p-we1dc                 | p-we1dcsezct2-kv    |             | Contributor                 | AZ RBAC res p-we1dc p-we1dcsezct2-kv Contributor        |
| AZ RBAC | res  | p-we1net-network        | p-we1net-network-fw |             | Reader                      | AZ RBAC res p-we1net-network p-we1net-network-fw Reader |
| AZ RBAC | res  | p-we1dc                 | p-we1dcsezct2-kv    | List Secret | Reader                      | AZ RBAC res p-we1dc p-we1dcsezct2-kv List Secret Reader |

### Management Group Naming Standard

The Management Group name should include details which allow easy identification of the scope of the
contained subscriptions. The purpose of the Management Group is to easily facilitate the delegation
of privilege's, and policy's to the resources which are the responsibility of the scope.

Naming pattern:

> {**businessUnit**}

### Virtual Data Center Naming Standard

The name of a Virtual Data Center instance follows the pattern of

> \[{**XX**}-]{**9**}

Where:

** **XX**: Two characters that uniquely identify the Azure region.
** **9**: A single digit to uniquely identity Virtual Data Center instances in a single Azure Region.

Examples include:

* **NO1**: Norway East 1
* **NO2**: Norway East 2
* **WE1**: West Europe 1
* **WE2**: West Europe 2

The following table documents the codes for Azure regions:

| Region Name | Code |
|-------------|------|
| Norway East | NO   |
| Norway West | NW   |
| West Europe | WE   |
| North Europe | NE  |
| Denmark East | CP |
| Sweden Central | GV |
| Finland Central | HL |
| Austria East | VI |
| France Central | PA |
| Belgium Central | BR |
| Germany West Central | FR |
| Greece Central | AT |
| Italy North | MI |
| Poland Central | WW |
| Spain Central | MD |
| Switzerland North | ZU |
| UK South | LO |
| UK West | CF |
| Central US | IO |
| East US | VA |
| East US 2 | BT |
| East US 3 | GA |
| North Central US | IL |
| South Central US | TX |
| West Central US | WY |
| West US | CA |
| West US 2 | WA |
| East Asia | HK |
| South East Asia | SI |
| Australia Central | CB |
| Australia East | NS |
| Australisa South East | VC |
| China East | SH |
| China East 2 | SA |
| China North | BJ |
| China North 2 | BE |
| China North 3 | HB |
| Central India | PN |
| South India | CI |
| Southcentral India | HD |
| Indonesia Central | JK |
| Japan East | TK |
| Japan West | OS |
| Korea Central | SO |
| Malaysia West | KL |
| New Zealand North | AL |
| Taiwan North | TP |
| South Africa North | JB |
| Israel Central | IS |
| Qatar Central | DH |
| UAE North | DU |
| Brazil South | SP |
| Canada Central | TO |
| Canada East | QC |
| Chile Central | ST |
| Mexico Central | QS |

### Subscription Naming Standard

A user may have access to multiple subscriptions, some from partners and vendors. The user will clearly see all the subscriptions to which they have access; a consistent naming standard is critical.

The subscription name should include the purpose of the subscription (example, Production, QA, Development, etc.), and the purpose of the subscription which could also be defined simply as 'Generic Application (APP)' if nothing specific is needed.

Naming pattern for subscriptions:

> \[{**environment**}-]{**Service**}

Examples:

* **p-we1net**: Network hub for west europe.
* **p-gov**: Governance resources.
* **t-tstsp1**: Sample application test spoke.
* **tools**: Shared tools that are not developed using a dev, test, prod approach.

### Resource Group Naming Standard

The naming standard is designed so that resource groups inherit the name of the parent subscription. An optional role can be appended to the resource group name. This enables the core services to be defined by the concise short name, and related services to be represented as roles or tiers, for example networking.

* We have 64 characters to play with for resource groups.
* We are allowed alphanumeric, underscore and hyphens.
* If we reserve hyphens for splitting, then remove all other characters outside the alphanumeric range in component names.
* Do not use underscores _.

Naming pattern for resource groups:

> {**environment**}-{**service**}-\[{**role**}]
Examples:

* **p-we1net-network**: Network resources in the network hub in west europe.
* **p-mgt-mon**: Monitoring resources in the management subscription.
* **t-tstsp1**: Service resources for the application test spoke.
* **t-tstsp1-network**: Network resources for the application test spoke.
* **tools-pwsh**: Resources related to shared tools for PowerShell.

### Resource Naming Standards

As Azure employ multiple different rules and constraints on resources, and resources may be used either independently or as child of a parent resource, resource names can't be globally standardized.

Naming standard reference for resources:

* Lowercase is important as some of the resource names will be converted into URL's, which on some OS's are case sensitive.
* There should **not be any spaces** in the resource name.
* A set of resources that serve the same role and purpose should include an instance number, e.g. highly available resources.
* A resource that is a child of a parent resource should postfix a resource purpose short code.
* A resource that must be globally unique should include a unique element based on a calculated random strings.

::: Tip
Non-global resources: Due to the scope of the resource, we generally have significantly fewer restrictions in terms of length, and also naming convention for these resource types. This implies that we can drop some of the prefixes because that information is already ascertainable via the owning scope.

Of course to make it meaningful for the component it is related to, otherwise use common sense!
:::

#### Resource Name Patterns

Due to the complex nature of Azure Naming constraints, the following table assists in defining the styles required to establish a pattern for the resources based on 5 major constraints.

| Style | Globally unique. | Dashs | Resource Set | Child Resource | Subnet Child | Pattern                                                                                      |
| ----- | ---------------- | ----- | ------------ | -------------- | ------------ | -------------------------------------------------------------------------------------------- |
| A     | Yes              | Yes   | No           | No             | No           | `{environment}-{serviceworkload}[-{role}]{unique}[-{purpose}]-{type}`                        |
| B     | Yes              | No    | No           | No             | No           | `{environment}{serviceworkload}[{role}]{purpose}{unique}`                                    |
| C     | No               | Yes   | No           | No             | No           | `{environment}-{serviceworkload}[-{role}][-{purpose}]-{type}`                                |
| D     | No               | Yes   | Yes          | No             | No           | `{environment}-{serviceworkload}[-{role}][-{purpose}]{instance:02}`                          |
| E     | No               | Yes   | Yes          | Yes            | No           | `{environment}-{serviceworkload}[-{role}][-{purpose}]{instance:02}-{purpose}[{instance:02}]` |
| F     | No               | Yes   | No           | Yes            | Yes          | `{environment}-{serviceworkload}[-{role}][-{purpose}]-{type}-{subnet}-{type}`                |

With these constraints, we can associate the resource types in Azure with an appropriate Style for the naming pattern, as defined in the following table.

| Azure Service Type         | Style | Sample                               |
| -------------------------- | ----- | ------------------------------------ |
| App Service plan           | A     | `p-gov-cnghtc67ad3r4-plan`           |
| App Service web app        | A     | `t-tstsp4-docm6cwzrxduf-web`         |
| Application Insights       | A     | `p-gov-cnghtc67ad3r4-insights`       |
| Function App               | A     | `p-gov-cnghtc67ad3r4-func`           |
| Key vault                  | A     | `p-we1dcsezct2v4-kv`                 |
| Log Analytics workspace    | A     | `p-mgt-montmdhdmbcxm-ws`             |
| Recovery Services vault    | A     | `p-we1dcsezct2-rsv`                  |
| Application Gateway        | D     | `p-we1waf-pri-agw01`                 |
| Application Security Group | C     | `p-we1dc-network-dc-asg`             |
| Automation Account         | C     | `p-mgt-auto-auto`                    |
| Availability Set           | C     | `p-we1rmt-rdgw-as`                   |
| Azure Firewall             | C     | `p-net-wan-vwan-we1-fw`              |
| Disk                       | E     | `p-we1dc-dc01-osdisk`                |
| Disk                       | E     | `p-we1dc-dc01-datadisk00`            |
| Load Balancer              | C     | `p-we1rmt-rdgw-lb`                   |
| Managed Identity           | E     | `p-we1waf-pri-waf01-id`              |
| Network Interface          | E     | `p-we1dc-dc01-nic00`                 |
| Network Security Group     | F     | `t-tstsp3-network-vnet-VmSubnet-nsg` |
| Public IP Address          | E     | `p-we1waf-pri-waf01-pip`             |
| Route Table                | F     | `t-tstsp3-network-vnet-VmSubnet-rt`  |
| Storage Account            | B     | `pwe1dcdcdiagk4znndp2lb6`            |
| Traffic Manager            | C     | `t-tstsp1-network-tm`                |
| Virtual Appliance          | D     | `p-we1waf-pri-nva01`                 |
| Virtual Machine            | D     | `p-we1dc-dc01`                       |
| Virtual Network            | C     | `p-we1dc-network-vnet`               |
| Web Application Firewall   | D     | `p-we1waf-pri-waf01`                 |

The Element Resource in the naming pattern above is referenced from the [Resource type Short-Codes](#resource-type-short-codes)

##### Resource Name Samples

| Service or Entity          | Scope          | Length | Casing           | Valid Characters                                        | Pattern                                                                           | Example Value                                                                                        |
| -------------------------- | -------------- | ------ | ---------------- | ------------------------------------------------------- | --------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| Resource Group             | Global         | 1 - 64 | Case insensitive | Alphanumeric, underscore, parentheses, hyphen, a period | {environment}-{serviceworkload}-{role}                                            | p-gemini, p-gemini-network                                                                           |
| Availability Set           | Resource Group | 1 - 80 | Case insensitive | Alphanumeric, underscore, and hyphen                    | {environment}-{serviceworkload}-{role}-{resource}                                 |
| p-we1rmt-rdgw-as           |
| Virtual Machine            | Resource Group | 1 - 15 | Case insensitive | Alphanumeric, underscore, and hyphen                    | {environment}-{serviceworkload}-{role}{instance:02}                               | p-we1rmt-rdgw01                                                                                      |
| Virtual Hard Disk          | Resource Group | 1 - 80 | Case insensitive | Alphanumeric, underscore, and hyphen                    | {environment}-{serviceworkload}-{role}{instance:02}-{type}{resource}{instance:02} | p-we1dc-dc01-osdisk, p-we1dc-dc01-datadisk00                                                         |
| Storage account name       | Global         | 3 - 24 | Lower case       | Alphanumeric                                            | {environment}{serviceworkload}{role}{type}{unique}                                | pwe1rmtrdgwdiagxxxxxxxx                                                                              |
| Recovery Services Vault    | Global         | 2 - 50 | Case-insensitive | Alphanumeric and hyphens                                | {environment}-{serviceworkload}-{resource}                                        | p-we1dcxxxxxx-rsv                                                                                    |
| Key Vault                  | Global         | 3 - 24 | Case-insensitive | Alphanumeric, dashes and hyphens                        | {environment}-{serviceworkload}-{resource}                                        | p-we1dcxxxxxxxxxx-kv                                                                                 |
| Azure Automation           | Global         | 1 - 60 | Case-insensitive | Alphanumeric and hyphens                                | {environment}-{serviceworkload}-{resource}                                        | p-mgt-auto-auto                                                                                      |
| Application Plan           | Global         | 1 - 60 | Case-insensitive | Alphanumeric and Hyphens                                | {environment}-{serviceworkload}-{resource}                                        | p-gov-conciergexxxxxxxxxx-plan                                                                       |
| Function Application       | Global         | 1 - 60 | Case-insensitive | Alphanumeric and Hyphens                                | {environment}-{serviceworkload}-{resource}                                        | p-gov-conciergexxxxxxxxxx-func                                                                       |
| Application Insights       | Global         | 1 - 60 | Case-insensitive | Alphanumeric and Hyphens                                | {environment}-{serviceworkload}-{resource}                                        | p-gov-conciergexxxxxxxxxx-func-insights, t-tstsp2xxxxxxxxxx-web-insights                             |
| Web Application            | Global         | 1 - 60 | Case-insensitive | Alphanumeric and Hyphens                                | {environment}-{serviceworkload}-{resource}                                        | t-tstsp2xxxxxxxxxx-web                                                                               |
| Log Analytics workspace    | Global         | 1 - 60 | Case-insensitive | Alphanumeric and Hyphens                                | {environment}-{serviceworkload}-{resource}                                        | p-mgt-monxxxxxxxxxx-ws                                                                               |
| Virtual Network (VNet)     | Resource Group | 2 - 64 | Case-insensitive | Alphanumeric, dash, underscore, and period              | `{environment}-{serviceworkload}-{resource}`                                      | p-we1net-network-vnet                                                                                |
| Subnet                     | Parent VNet    | 1 - 80 | Case-insensitive | Alphanumeric, underscore, dash, and period              | `{role}Subnet`                                                                    | AzureFirewallSubnet, GatewaySubnet, FrontendSubnet, BackendSubnet, PrivateWafSubnet, PublicWafSubnet |
| Network Interface          | Resource Group | 1 - 80 | Case-insensitive | Alphanumeric, dash, underscore, and period              | `{environment}-{serviceworkload}-{role}{instance:02}-{resource}{instance:02}`     | p-we1dc-dc01-nic00                                                                                   |
| Azure Firewall             | Resource Group | 1 - 80 | Case-insensitive | Alphanumeric, dash, and underscore                      | `{environment}-{serviceworkload}-{resource}`                                      | p-we1net-network-fw                                                                                  |
| Network Security Group     | Resource Group | 1 - 80 | Case-insensitive | Alphanumeric, dash, underscore, and period              | `{environment}-{serviceworkload}-{resource}-{subnet}-{resource}`                  | p-we1dc-network-vnet-FrontendSubnet-nsg                                                              |
| Application Security Group | Resource Group | 1 - 80 | Case-insensitive | Alphanumeric, dash, underscore, and period              | `{environment}-{serviceworkload}-{role}-{resource}`                               | p-we1dc-network-dc-asg                                                                               |
| Network Security Rule      | Resource Group | 1 - 80 | Case-insensitive | Alphanumeric, hyphens, periods and underscores          | `<rule purpose>`                                                                  | DenyInternetOutBound, AllowDnsRepliesFromAdSubnet                                                    |
| Public IP Address          | Resource Group | 1 - 80 | Case-insensitive | Alphanumeric, dash, underscore, and period              | `{environment}-{serviceworkload}-{role}{instance:02}-{resource}{instance:02}`     | p-we1net-network-vpn-pip, p-we1net-network-fw-pip001                                                 |
| Load Balancer              | Resource Group | 1 - 80 | Case-insensitive | Alphanumeric, dash, underscore, and period              | `{environment}-{serviceworkload}-{role}-{resource}`                               | p-we1rmt-rdgw-lb                                                                                     |
| Web Application Firewall   | Resource Group | 1 - 80 | Case-insensitive | Alphanumeric, dash, underscore, and period              | `{environment}-{serviceworkload}-{role}{instance:02}-{resource}{instance:02}`     | p-we1waf-pri-waf01                                                                                   |
| Traffic Manager            | Resource Group | 1 - 63 | Case-insensitive | Alphanumeric, dash, and period                          | `{environment}-{serviceworkload}-{resource}`                                      | t-tstsp1-network-tm                                                                                  |
| Network Virtual Appliance  | Resource Group | 1 - 15 | Case insensitive | Alphanumeric, underscore, and hyphen                    | `{environment}-{serviceworkload}-{role}{instance:02}`                             | p-we1waf-pri-nva01                                                                                   |
| User defined routes (UDR)  | Resource Group |        | Case-insensitive | Alphanumeric, dash, and period                          | `{environment}-{serviceworkload}-{resource}-{subnet}-{resource}`                  | p-we1net-network-vnet-GatewaySubnet-rt                                                               |

#### Subnet Naming Standard

To keep a consistent naming standard for Subnets, all always postfix the workload element of the subnet with the word 'Subnet'

> `{workload}Subnet`

Some common examples include

* **AzureFirewallSub1net**: Host for the **Azure Firewall** resource
* **GatewaySubnet**: Hosts for the **Azure VPN Gateway** resource
* **ADSubnet**: Host to VMs, deployed as Domain Controllers for AD
* **AzureBastionSubnet**: Host for the **Azure Bastion** resource

#### Firewall Rules Collection Naming Standard

Use this pattern when naming a firewall rules collection.

> {type}-{action}-{workload name}

| Element       | Value                                                                                                                  |
| ------------- | ---------------------------------------------------------------------------------------------------------------------- |
| Type          | `Nat`, `Network` or `Application`                                                                                      |
| Action        | `Allow` or `Deny`                                                                                                      |
| Workload name | The name of the workload being affected. In the case of any workload hosted in a spoke, the name of the spoke is used. |

* **Application-Allow-p-we1dc**
* **Nat-Allow-p-we1dc**
* **Network-Allow-p-we1dc**
* **Network-Deny-p-we1dc**

#### Firewall and NSG Rule Naming Standard

Use this pattern when naming a rule in a firewall or network security group.

> {**action**}{**content**}\[From{**source**}To{**destination**}]

| Element     | Value                                        |
| ----------- | -------------------------------------------- |
| Action      | `Allow` or `Deny`.                           |
| Content     | Brief description of the traffic.            |
| Source      | Brief description of the source.             |
| Destination | Brief description of the target/destination. |

Examples:

* **AllowTcpforaddsFromAllworkloadsToAdservers**: Allow ADDS TCP traffic from all workloads to AD servers.
* **AllowUdpforaddsFromAllworkloadsToAdservers**: Allow ADDS UDP traffic from all workloads to AD servers.
* **AllowDnsRequestsFromFirewallToDnsservers**: Allow DNS requests from firewall to DNS servers.
* **AllowDnsFromInternetToAdservers**: Allow DNS from internet to AD servers.
* **DenyAll**: Deny all other traffic.

#### Automation Account Deployment Schedule Naming Standard

Use this pattern when naming automation account deployment schedules.

> {**region**}, {**interval**}, {**hour**} {**operating system**}

|Element | Value
|---|---|
|Region/Time Zone| Azure region short code, e.g. WE for West Europe, representing a time zone.
|Interval| The interval for the schedule, more details below.
|Hour| The hour of the day, in 24-hour clock, e.g. 23.
|Operating system| `Windows` or `Linux`.

The interval can have one of the following definitions:

**Hourly (Example: Definition Updates):**

Value pattern: H{hourly interval number}

Example values:

* **H1**: hourly
* **H4**: every 4 hours
* **H6**: every 6 hours

**Daily:**

Value pattern: D

**Weekly:**

Value pattern: W{day of week number}

Example values:

* **W1**: Every Monday
* **W3**: Every Wednesday
* **W7**: Every Sunday

**Monthly (date):**

Value pattern: M{day of month number}

Examples:

* **M1**: 1st of every month
* **M10**: 10th of every month
* **M31**: 31st of every month

**Monthly (specified day):**

Value pattern: N{week number}{day of week number}

Examples:

* **N11**: 1st Monday of the month
* **N33**: 3rd Wednesday of the month
* **N01**: Last Monday of the month

Examples:

* **WE, H6, 00, Windows**: West Europe, every 6 hours, at 00:00 hours, Windows machines.
* **WE, W6, 20, Windows**: West Europe, every Saturday, at 20:00 hours, Windows machines.
* **WE, W6, 23, Windows**: West Europe, every Saturday, at 23:00 hours, Windows machines.
* **WE, W6, 23, Linux**: West Europe, every Saturday, at 23:00 hours, Linux machines.
* **WE, W7, 20, Windows**: West Europe, every Sunday, at 20:00 hours, Windows machines.
* **WE, W7, 23, Windows**: West Europe, every Sunday, at 23:00 hours, Windows machines.
* **WE, W7, 23, Linux**: West Europe, every Sunday, at 23:00 hours, Linux machines.

Note that **Deployment Schedules** are created per time zone where there is one or more Virtual Data Center instances. For example:

1. **WE1**: A Virtual Data Center instance is created in West Europe (Middenmeer, Netherlands). Deployment schedules, as documented above, may be used.
1. **NO1**: A Virtual Data Center instance is deployed in Norway East. It is in the same timezone as WE1 so it may also use the WE1 **Deployment Schedules**.
1. **NE1**: A Virtual Data Center instance is made in North Europe (Dublin, Ireland). This is a different time zone, so a set of **Deployment Schedules** should be created with the NE designation for use in this time zone.
1. **LO1**: A Virtual Data Center instance is created in UK South (London, UK). The new instance shares a common time zone with NE1 so it may also use the NE1 **Deployment Schedules**.
