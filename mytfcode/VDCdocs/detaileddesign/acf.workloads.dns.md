### Shared DNS (`p-dns`)

The `p-dns` subscription hosts components related to DNS.

#### Subscription Configuration

The configuration of the subscription is described below.

##### Role-Based Access Control

Access to this subscription should be restricted to those supporting and operating the contained components. There are 3 Azure AD access groups to control access to the subscription and the contained resource groups and resources.:

| Group Name                      | Role        | Description                                                                                            |
| ------------------------------- | ----------- | ------------------------------------------------------------------------------------------------------ |
| `AZ RBAC sub p-dns Owner`       | Owners      | Members have full permissions, including permissions. This group is ideally empty.                     |
| `AZ RBAC sub p-dns Contributor` | Contributor | Members have full permissions, excluding permissions. This group has as few human members as possible. |
| `AZ RBAC sub p-dns Reader`      | Reader      | Members are limited to read permissions only. Ideally, this is where most human members are placed.    |

##### Diagnostics Settings

The diagnostics settings of the subscription are configured to send the Activity Log data of this subscription to two destinations:

* **Long-term audit logging**: Blob storage in the p-gov-log resource group in the p-gov subscription that is configured for read only, economic, long-term storage for legal and compliance purposes.
* **Platform monitoring**: A Log Analytics Workspace in the p-mgt-mon resource group in the p-mgt subscription for query-enabled functionality such as searching, reporting, and security monitoring.

The diagnostics setting for the subscription is configured as follows:

* Logs:
  * Categories:
    * Administrative: `Enabled`
    * Security: `Enabled`
    * ServiceHealth: `Enabled`
    * Alert: `Enabled`
    * Recommendation: `Enabled`
    * Policy: `Enabled`
    * Autoscale: `Enabled`
    * ResourceHealth: `Enabled`
* Destination Details:
  * Send To Log Analytics Workspace: `Enabled`
    * Subscription: `p-mgt`
    * Log Analytics Workspace: `p-mgt-montijczky7je-ws`
  * Archive To Storage Account: `Enabled`
    * Subscription: `p-gov`
    * Storage Account: `pgovlogauditxnlolmbkkxb`

##### Microsoft Defender for Cloud

Security and compliance features are provided by Microsoft Defender for Cloud. There are two tiers:

* *Free*: Basic features and configurations are possible.
* *Paid*: Special security monitoring features for resources can be enabled per-support resource type.

The configurations for this subscription are configured as follows:

###### Defender Plans

The plans are configure as follows:

* Cloud Security Posture management: `Grey Out`
* Servers: `Off`
* App Service: `Off`
* Databases: `Off`
* Storage: `Off`
* Containers: `Off`
* Kubernetes: `Off`
* Container Registries: `Off`
* Key Vault: `Off`
* Resource Manager: `On`
* DNS: `On`

###### Auto Provisioning

The deployment of extensions is configured as follows:

* Log Analytics Agent/Azure Monitor Agent: `On`
  * Agent Type: `Log Analytics`
  * Custom Workspace: `p-mgt-montijczky7je-ws`
  * Security Events Storage: `Minimal`
* Vulnerability Assessment for Machines: `Off`
* Guest Configuration Agent: `Off`
* Microsoft Defender for Containers Components: `Off`

###### Email Notifications

Notifications are configured as follows:

* Email Recipients:
  * All Users With The Following Roles: `Owner, Contributor`
  * Additional Email Addresses: `A distribution list to be provided`
* Notification Types:
  * Notify About Alerts With The Following Severity (Or Higher): `Medium`

###### Integrations

The following integrations are configured:

* Enable Integrations:
  * Allow Microsoft Defender for Cloud Apps To Access My Data: `True`
  * Allow Microsoft Defender for Endpoint To Access My Data: `True`

###### Integrations

The following integrations are configured:

* Enable Integrations:
  * Allow Microsoft Defender for Cloud Apps To Access My Data: `True`
  * Allow Microsoft Defender for Endpoint To Access My Data: `True`

###### Workflow Automation

No configurations are included.

###### Continuous Export

No configurations are included.

#### Components

The following components are hosted in the subscription:

* Azure Private DNS (`p-dns-pri`)
* Azure Public DNS (`p-dns-pub`)

##### Azure Private DNS (`p-dns-pri`)

This component hosts Azure Private DNS Zones that will be shared across different workloads.

###### Overview

In the standard design of a Virtual Data Centre instance, a pair of DNS servers are used to resolve DNS queries. However, there are times when additional resolution is required. An example of this is when Private Endpoints are used with PaaS resources to increase security and/or compliance. Such PaaS resources require an alternative name to resolve to the Private Endpoint private IP address. The DNS zones for Private Link should support a DevOps/DevSecOps approach where records can be added to Azure via infrastructure-as-code. The solution is to use Azure Private DNS Zones.

###### Resource Groups

The resource group, `p-dns-pri`, is created in the `p-dns` subscription, which is in the Management Group called `GlobalNet`.

A lock is placed on the resource group:

* **Resource Group Lock**: `resourceGroupDoNotDelete`
  * Lock Type: `Delete`

The resources in this resource group are:

The following Private Azure DNS zones are deployed by default. Additional zones may be required later.

| Zone Name                            | Azure Resource Type                         |
| ------------------------------------ | ------------------------------------------- |
| `privatelink.azure-automation.net`   | Azure Automation Accounts                   |
| `privatelink.azurewebsites.net`      | Azure App Services.                         |
| `privatelink.blob.core.windows.net`  | Blob storage in Azure Storage Accounts.     |
| `privatelink.database.windows.net`   | Azure SQL databases.                        |
| `privatelink.file.core.windows.net`  | File shares in Azure Storage Accounts.      |
| `privatelink.queue.core.windows.net` | Queue storage in Azure Storage Accounts.    |
| `privatelink.table.core.windows.net` | Table storage in Azure Storage Accounts.    |
| `privatelink.web.core.windows.net`   | Static web sites in Azure Storage Accounts. |

Each Azure Private DNS Zone will, by default, be associated with the virtual network of the DNS servers in each Virtual Data Centre instance. This will enable those DNS servers to forward requests for the above zones to the Azure DNS service. All DNS clients of the DNS servers will therefore be able to resolve names from the above DNS zones.

##### Azure Public DNS (`p-dns-pub`)

This optional component allows an organisation to host public DNS zones in Microsoft Azure.

###### Overview

Azure can host public DNS zones. The benefits are scalability (DNS hosted in all Azure and Edge Centre facilities), performance (zones are closer to Internet clients), resilience (AnyCast redirects requests to available replicas), and improved security & governance (using Azure instead of a third party control panel).

::: warning
Azure Public DNS does not support DNSSEC; this has prevented many organisations from adopting this component.
:::

###### Resource Groups

The resource group, `p-dns-pri`, is created in the `p-dns` subscription, which is in the Management Group called `GlobalNet`.

A lock is placed on the resource group:

* **Resource Group Lock**: `resourceGroupDoNotDelete`
  * Lock Type: `Delete`
