# p-we1mo Subscription

This workload hosts:

* The Montel Online virtual machine

## High-Level Design

### Concept

This workload will host one service:

* Montel Online: One of the main workloads providing services to Montel customers. The workload is based on Azure App Services.

### Networking

The workload was classified as critical to the business. Therefore, it was decided that resources, as much as possible, should have private network connections.

![Network Architecture](images/p-we1mo%20Networking.drawio.png)

A single virtual network is deployed to host one service. The virtual network is deployed with a /26 address space. Two subnets are deployed:

* **AseSubnet**: A /26 subnet to host the App Service Environment.
* **PrivateLinkSubnet**: A /26 subnet to connect PaaS resources using Private Endpoint. 

The virtual network will be peered with the hub virtual network. Each subnet will have a route table that forces egress traffic through the hub firewall. The only ingress path from outside of the virtual network will be through the hub.

Each subnet will have a Network Security Group. A custom low priority Inbound Rule will deny all traffic from all sources; this will mean that only traffic that is permitted by higher priority rules will be allowed:

* Traffic from outside the subnet.
* Traffic between NICs in the same subnet.

Per-policy, no resources will have a public IP address.

The compute for the workload is deployed as an App Service Environment (ASE), a deeply network-integrated environment for hosting App Service Plans (the compute) and App Services (the sites for web/API applications). The workload requires a Key Vault to store secrets; the Key Vault is deployed with Private Endpoint so that all workload-secret communications are private.

### Operations

#### Code Deployment

The workload does not have a public endpoint. The default SCM connection for delivering code is accessible only over the virtual network. A deployment workload, hosting a DevOps Agent(s) in p-we1dep, will be used as an agent pool in Azure DevOps. The p-we1dep workload has connectivity to deploy code, through firewall and NSG rules, to p-we1mo.

### Security

Role-based access control will limit who can see the resources of this workload and who can access them.

Microsoft Defender for Cloud is configured with Server Plan 1 for virtual machines, including anti-malware protection.

The workload was classified as requiring private network connections only:

* The default public endpoint was not suitable.
* Private Endpoint still leaves a TCP connection available to an App Service via a public endpoint, which may be vulnerable to an advanced persistent attack.
* App Service Environment v3 deploys a private stamp (load balancer, front ends, and compute) to host App Services without any public endpoints. This option was chosen.

The hub firewall and the subnet Network Security Groups will limit network traffic to only what is required. 

An Azure Key Vault will store secrets for the workload, including the default administrator username and password for virtual machines in this workload. The Key Vault is connected to the virtual network using a Private Endpoint.

### Governance

A budget for the workload will be configured and alerts will be enabled.

Auditing of the subscription will be enabled for short-term (usable) and long-term (compliance) purposes.

## Detailed Design

### Subscription Configuration

p-we1mo is deployed into a subscription called `p-we1mo`. The subscription is placed into a Management Group called `WE1 Production Spokes`.

The configuration of the subscription is described below.

#### Role-Based Access Control

Access to this subscription should be restricted to those supporting and operating the contained components. There are 3 Azure AD access groups to control access to the subscription and the contained resource groups and resources:

| Group Name                                             | Role        | Description                                                                                            |
| ------------------------------------------------------ | ----------- | ------------------------------------------------------------------------------------------------------ |
| `AZ RBAC sub p-we1mo Owner`       | Owners      | Members have full permissions, including permissions & policy. This group is ideally empty.                     |
| `AZ RBAC sub p-we1mo Contributor` | Contributor | Members have full permissions, excluding permissions & policy. This group has as few human members as possible. |
| `AZ RBAC sub p-we1mo Reader`      | Reader      | Members are limited to read permissions only. Ideally, this is where most human members are placed.    |

#### Diagnostics Settings

The diagnostics settings of the subscription are configured to send the Activity Log data of this subscription to two destinations:

* **Long-term audit logging**: Blob storage in the `p-gov-log` resource group in the `p-gov` subscription that is configured for read only, economic, long-term storage for legal and compliance purposes.
* **Platform monitoring**: A Log Analytics Workspace in the `p-mgt-mon` resource group in the `p-mgt` subscription for query-enabled functionality such as searching, reporting, and security monitoring.

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

#### Microsoft Defender for Cloud

Security and compliance features are provided by Microsoft Defender for Cloud. There are two tiers:

* **Free**: Basic features and configurations are possible.
* **Paid**: Special security monitoring features for resources can be enabled per-support resource type.

The configurations for this subscription are configured as follows:

### Defender Plans

The plans are configure as follows:

* Defender CSPM: `Off`
* Servers: `Off`
* App Service: `On`
* Databases: `Off`
* Storage: `On`
* Containers: `Off`
* Key Vault: `On`
* Resource Manager: `On`
* DNS: `Off`

### Auto Provisioning

The deployment of extensions is configured as follows:

* Log Analytics Agent/Azure Monitor Agent: `On`
  * Agent Type: `Log Analytics`
  * Custom Workspace: `p-mgt-montijczky7je-ws`
  * Security Events Storage: `Minimal`
* Vulnerability Assessment for Machines: `On`
  * Select A Vulnerability Assessment Soluiton: `Microsoft Defender Vulnerability Monitoring`
* Guest Configuration Agent: `Off`
* Agentless Scanning For Machines: `Off`
* Defender DaemonSet: `Off`
* Azure Policy for Kubernetes: `Off`

### Email Notifications

Notifications are configured as follows:

* Email Recipients:
  * All Users With The Following Roles: Owner, Contributor
  * Additional Email Addresses: incidents@montelgroup.com
* Notification Types:
  * Notify About Alerts With The Following Severity (Or Higher): Medium

### Integrations

The following integrations are configured:

* Enable Integrations:
  * Allow Microsoft Defender for Cloud Apps To Access My Data:Proximity `True`
  * Allow Microsoft Defender for Endpoint To Access My Data: `True`

### Integrations

The following integrations are configured:

* Enable Integrations:
  * Allow Microsoft Defender for Cloud Apps To Access My Data: `True`
  * Allow Microsoft Defender for Endpoint To Access My Data: `True`

### Workflow Automation

No configurations are included.

### Continuous Export

No configurations are included.

### Resource Groups

The following resource groups are created:

* `p-we1mo-network`
* `p-we1mo`
* `p-we1mo-mon`

All resources and groups are deployed into the West Europe Azure region.

#### Workload Network (`p-we1mo-network`)

The purpose of this resource group is to supply the networking for p-we1mo.

A lock is placed on the resource group:

* **Resource Group Lock**: resourceGroupDoNotDelete
  * Lock Type: Delete

The following resources are deployed to the resource group:

* **Network Watcher**: `p-we1mo-network-networkwatcher`
  * Purpose: `Enable network watcher for the subscription in the region.`
* **Virtual Network**: `p-we1mo-network-vnet`
  * Purpose: `Provide a virtual network that the workload resources connect to.`
  * Address Space: **10.100.13.64/26**
  * DNS Servers: **10.100.1.4**
  * Subnets:
    * AseSubnet:
      * Address Space: **10.100.13.64/27**
      * Network Security Group: `p-we1mo-network-vnet-AseSubnet-nsg`
      * Route Table: `p-we1mo-network-vnet-AseSubnet-rt`
      * Private Endpoint Network Policy:
        * Network Security Groups: `Enabled`
        * Route Tables: `Enabled`
    * PrivateLinkSubnet:
      * Address Space: **10.100.13.96/27**
      * Network Security Group: `p-we1mo-network-vnet-PrivateLinkSubnet-nsg`
      * Route Table: `p-we1mo-network-vnet-PrivateLinkSubnet-rt`
      * Private Endpoint Network Policy:
        * Network Security Groups: `Enabled`
        * Route Tables: `Enabled`
  * DDoS Protection Standard: `Disabled`
  * Peerings:
    * `p-we1net-network-vnet`:
      * Traffic To Remote Virtual Network: `Allow`
      * Traffic Forwarded From Remote Virtual Network: `Block traffic that originates from outside this virtual network`
      * Virtual Network Gateway Or Route Server: `Use the remote virtual network gateway or Route Server`
* **Network Security Group**: `p-we1mo-network-vnet-AseSubnet-nsg`
  * Purpose: `Protect the AseSubnet`
  * Inbound Security Rules (Custom): The rules are documented in [spoke-networking-nsg.tf](https://dev.azure.com/montel/Azure%20VDC/_git/p-we1mo?path=/cfg/spoke-networking-nsg.tf) in the p-we1mo repository.
  * Outbound Security Rules (Custom): None
  * Diagnostic Settings:
    * `p-mgt-montijczky7je-ws`
      * Logs: `All Logs`
      * Destination Details:
        * Send To Log Analytics: `Enabled`
          * Subscription: `p-mgt`
          * Log Analytics Workspace: `p-mgt-montijczky7je-ws`
        * Archive To A Storage Account: `Enabled`
          * Subscription: `p-we1mo`
          * Storage Account: `pwe1monetworkdiaglgywlx`
* **Network Security Group**: `p-we1mo-network-vnet-PrivateLinkSubnet-nsg`
  * Purpose: `Protect the PrivateLinkSubnet`
  * Inbound Security Rules (Custom): The rules are documented in [spoke-networking-nsg.tf](https://dev.azure.com/montel/Azure%20VDC/_git/p-we1mo?path=/cfg/spoke-networking-nsg.tf) in the p-we1mo repository.
  * Outbound Security Rules (Custom): None
  * Diagnostic Settings:
    * `p-mgt-montijczky7je-ws`
      * Logs: `All Logs`
      * Destination Details:
        * Send To Log Analytics: `Enabled`
          * Subscription: `p-mgt`
          * Log Analytics Workspace: `p-mgt-montijczky7je-ws`
        * Archive To A Storage Account: `Enabled`
          * Subscription: `p-we1mo`
          * Storage Account: `pwe1monetworkdiaglgywlx`
  * NSG Flow Logs:
    * `PrivateLinkSubnet-flowlog`
  * NSG Flow Logs:
    * `AseSubnet-flowlog`
* **Route Table**: `p-we1mo-network-vnet-AseSubnet-rt`
  * Purpose: `Override default and BGP routing for the AseSubnet`
  * Propagate Gateway Routes: `No`
  * Routes:
    * `Everywhere`:
      * Address Prefix Destination: `IP Addresses`
      * Destination IP Addresses: `0.0.0.0/0`
      * Next Hop Type: `Virtual Appliance`
      * Next Hop IP Address: `10.100.1.4`
* **Route Table**: `p-we1mo-network-vnet-PrivateLinkSubnet-rt`
  * Purpose: `Override default and BGP routing for the PrivateLinkSubnet`
  * Propagate Gateway Routes: `No`
  * Routes:
    * `Everywhere`:
      * Address Prefix Destination: `IP Addresses`
      * Destination IP Addresses: `0.0.0.0/0`
      * Next Hop Type: `Virtual Appliance`
      * Next Hop IP Address: `10.100.1.4`
* **NSG Flow Log**: `AseSubnet-flowlog`:
  * Purpose: `Enable Traffic Analytics for AseSubnet`
  * Flow Logs Version: `Version 2`
  * Select Storage Account:
    * Subscription: `p-we1mo`
    * Storage Account: `pwe1monetworkdiaglgywlx`
    * Retention (Days): `30`
  * Traffic Analytics: `Enabled`
    * Traffic Analytics Processing Interval: `Every 10 mins`
    * Subscription: `p-mgt`
    * Log Analytics Workspace: `p-mgt-montijczky7je-ws`
* **NSG Flow Log**: `PrivateLinkSubnet-flowlog`:
  * Purpose: `Enable Traffic Analytics for FrontendSubnet`
  * Flow Logs Version: `Version 2`
  * Select Storage Account:
    * Subscription: `p-we1mo`
    * Storage Account: `pwe1monetworkdiaglgywlx`
    * Retention (Days): `30`
  * Traffic Analytics: `Enabled`
    * Traffic Analytics Processing Interval: `Every 10 mins`
    * Subscription: `p-mgt`
    * Log Analytics Workspace: `p-mgt-montijczky7je-ws`
* **Storage Account** `pwe1monetworkdiaglgywlx`
  * Purpose: `Provides blob storage for NSG Flow Logs`
  * Performance: `Standard`
  * Replication: `ZRS`
  * Account Kind: `StorageV2`

### Workload Resources (`p-we1mo`)

The resource group, `p-we1mo`, contains the resources for the workload.  A lock is placed on the resource group:

* **Resource Group Lock**: `resourceGroupDoNotDelete`
  * Lock Type: `Delete`

These are the resources deployed to `p-we1mo`:

*Shared resources:*

* **Key Vault**: `p-we1molgywlx-kv`
  * SKU: `Premium`
  * Soft Delete: `Enabled, 90 days, Enable Purge Protection`
  * Access Policy:
    * `Backup Management Service`:
      * Key: `Get, List, Backup`
      * Secret: `Get, List, Backup`
      * Certificate: `None`
    * `AZ RBAC mg VDC Root Owner`:
      * Key: `Get, List, Backup`
      * Secret: `Get, List, Backup`
      * Certificate: `None`
    * `AZ RBAC mg VDC Root Contributor`:
      * Key: `Get, List, Backup`
      * Secret: `Get, List, Backup`
      * Certificate: `None`
  * Secrets:
    * AdminUsername: `sysadmin`
    * AdminPassword: `<Password for sysadmin>`
* **Private Endpoint**: `p-we1molgywlx-kv-pe`
  * Purpose: `Provide a private connection to the Key Vault`
  * Private Link Resource: `p-we1molgywlx-kv`
  * Virtual Network/Subnet: `p-we1mo-network-vnet/PrivateLinkSubnet`
  * Network Interface: `p-we1molgywlx-kv-pe-nic`
* **Network Interface**: `p-we1molgywlx-kv-pe-nic`
  * Purpose: `Connect the Key Vault private endpoint to the PrivateLinkSubnet`
  * Attached To: `p-we1molgywlx-kv-pe`
  * IP Configurations:
    * Name: `privateEndpointIpConfig.71ef7ea5-32eb-4b43-a37d-7bc12635e6f3`
    * IP Version: `IPv4`
    * Type: `Primary`
    * Private IP Address: `10.100.13.100`

*we1mo:*

* **App Service Environment**: `p-we1mo`
  * Purpose: `Host isolated tier App Service Plans for the workload`
  * Version: `App Service Environment v3`
  * Subnet: `AseSubnet`
  * Zone Redundant: `Disabled`
  * Configuration:
    * Platform Settings:
      * Internal Encryption: `Off`
      * Allow TLS 1.0 and 1.1: `On`
      * Upgrade Preference:
        * Mode: `Automatic`
        * Preference: `None`
    * Network Settings:
      * Allow Incoming FTP Connections: `Off`
      * Allow Remote Debugging: `Off`
      * Allow New Private Endpoints: `Off`
  * Custom Domain Suffix: `None`
* **App Service Plan**: `p-we1mo-plan`
  * Purpose: `An isolated tier app service plan to host workload app services`
  * Size: `I2v2`
  * Operating System: `Windows`
  * App Service Environment: `p-we1mo`
  * Scale Out:
    * Configure:
      * Mode: `Manual`
      * Instance Count: `1`
* **App Service**: `p-we1mo-montelonline-app`
  * Purpose: `Host the production Montel Online app`
  * App Service Plan: `p-we1mo-plan`
  * Deployment Slots:
    * p-we1mo-montelonline-app-p-we1mo-montelonline-app-deploy-slot
      * % Traffic: `0`
  * Custom Domains: `None`
  * Certificates: `None`
* **App Service (Slot)**: `p-we1mo-montelonline-app-deploy-slot`
  * Purpose: `Host the pre-production Montel Online app`
  * App Service Plan: `p-we1mo-plan`
  * Custom Domains: `None`
  * Certificates: `None`
* **Application Insights**: `p-we1molgywlx-insights`
  * Purpose: `Provide diagnostics for the Montel Online app`
  * Workspace: `p-mgt-apmpfdxpugzrb-ws`
  * 

#### Monitoring Resources (`p-we1mo-mon`)

The resource group, `p-we1mo-mon`, contains resources that play a role in monitoring and operations.  A lock is placed on the resource group:

* **Resource Group Lock**: `resourceGroupDoNotDelete`
  * Lock Type: `Delete`

These are the resources deployed to `p-we1mo-mon`:

* **Action Group**: `p-we1mo-mon-budget-ag`
  * Purpose: `Action(s) in response to workload budget alerts`
* **Action Group**: `p-we1mo-mon-ops-critical-ag`
  * Purpose: `Action(s) in response to workload critical operations alerts`
* **Action Group**: `p-we1mo-mon-ops-error-ag`
  * Purpose: `Action(s) in response to workload error operations alerts`
* **Action Group**: `p-we1mo mon-ops-warning-ag`
  * Purpose: `Action(s) in response to workload warning operations alerts`
* **Action Group**: `p-we1mo-mon-ops-info-ag`
  * Purpose: `Action(s) in response to workload informational operations alerts`
* **Shared Dashboard**: `p-we1mo`

### Azure Firewall Rules Collection Group

The Azure Firewall rules for this workload are stored in a Rules Collection Group called `p-we1mo`. The Rules Collection Group is a sub-resource of the Azure Firewall Policy, `p-we1net-network-fw-firewallpolicy`, which is deployed to the `p-we1net` subscription (the VDC instance hub).

The rules collections are documented in [spoke-azurefirewall.tf](https://dev.azure.com/montel/Azure%20VDC/_git/p-we1mo?path=/cfg/spoke-azurefirewall.tf) in the p-we1mo repository.

### Monitoring

This section describes the standard configuration for the systems management of the workload.

#### Resource Monitoring

The following resources should have diagnostics settings enabled:

* **Resource Group**: `p-we1mo-network`
  * **Network Security Group**: `p-we1mo-network-vnet-AseSubnet-nsg`
* **Resource Group**: `p-we1mo`
  * **Key Vault**: `p-we1mo<random string>-kv`
  * **Network Interface**: `p-we1mo-app01-nic00`
  * **Application Insights**: `p-we1molgywlx-insights`
  * **Network interface**: `p-we1molgywlx-kv-pe-nic`
  * **App Service Environment**: `p-we1mo`
  * **App Service plan**: `p-we1mo-plan`
  * **App Service**: `p-we1mo-montelonline-app`
  * **App Service (Slot)**: `p-we1mo-montelonline-app-deploy-slot`

Diagnostics Settings should be configured as follows:

* **Diagnostics Setting**: `p-mgt-montijczky7je-ws`
  * Purpose: `Send log and performance data for resources to the central platform monitoring Log Analytics Workspace.`
  * Logs: `All Logs`
  * Metrics: `Enabled`
  * Destination Details:
    * Send To Log Analytics Workspace: `Enabled`
      * Subscription: `p-mgt`
      * Log Analytics Workspace: `p-mgt-montijczky7je-ws`

#### Alerting

The following alerts are configured in the `p-we1mo` resource group:

#### Cost Management

* **Budget**: `p-we1mo`
  * Purpose: `Provide a budget and alerts for cost management of the workload subscription`
  * Create A Budget:
    * Scope: `p-we1mo`
    * Reset Period: `Monthly`
    * Creation Date: `<Today>`
    * Expiration Date: `<As late as Azure allows>`
    * Budget Amount: `850`
  * Set Alerts:
    * Alert Conditions:
      * Type: `Actual`
        * % of Budget: `100`
        * Action Group: `p-we1mo-mon-budget-ag`
      * Type: `Forecasted`
        * % of Budget: `100`
        * Action Group: `p-we1mo-mon-budget-ag`
          * Alert Recipients (Email):
            * `{Email distribution list}`
          * Language Preference:
            * `Norwegian (Norway)`