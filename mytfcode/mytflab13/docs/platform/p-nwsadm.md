# p-nwsadm Subscription

This workload hosts:

* The News Admin virtual machine

## High-Level Design

### Concept

This workload will host one service:

* News Admin: Internal system for our journalists and editors where they write, edit and publish our news.

### Networking

![Network Architecture](images/p-nwsadm%20Networking.drawio.png)

A single virtual network is deployed to host one services. The virtual network is deployed with a /26 address space. A single /27 subnet is deployed to host resources that will be accessible from outside of the workload.

The virtual network will be peered with the hub virtual network. Each subnet will have a route table that forces egress traffic through the hub firewall. The only ingress path from outside of the virtual network will be through the hub.

Each subnet will have a Network Security Group. A custom low priority Inbound Rule will deny all traffic from all sources; this will mean that only traffic that is permitted by higher priority rules will be allowed:

* Traffic from outside the subnet.
* Traffic between NICs in the same subnet.

Per-policy, no virtual machines will have a public IP address.

### Remote Sign-In

All RDP/SSH logins will be performed using Azure Bastion. An Azure Bastion is deployed in the hub and will be permitted access to the virtual machines in the workload.

### Operations

#### Backup

An Azure Recovery Services Vault is deployed with the workload. Azure Backup will:

* Back up virtual machines.

#### Patching

All virtual machines will be automatically patched using Azure Update Management.

### Security

Role-based access control will limit who can see the resources of this workload and who can access them.

Microsoft Defender for Cloud is configured with Server Plan 1 for virtual machines, including anti-malware protection.

The hub firewall and the subnet Network Security Groups will limit network traffic to only what is required. The Windows Firewall will remain enabled in the guest OS.

An Azure Key Vault will store secrets for the workload, including the default administrator username and password for virtual machines in this workload.

### Governance

A budget for the workload will be configured and alerts will be enabled.

Auditing of the subscription will be enabled for short-term (usable) and long-term (compliance) purposes.

## Detailed Design

### Subscription Configuration

p-nwsadm is deployed into a subscription called `p-nwsadm`. The subscription is placed into a Management Group called `WE1 Production Spokes`.

The configuration of the subscription is described below.

#### Role-Based Access Control

Access to this subscription should be restricted to those supporting and operating the contained components. There are 3 Azure AD access groups to control access to the subscription and the contained resource groups and resources:

| Group Name                                             | Role        | Description                                                                                            |
| ------------------------------------------------------ | ----------- | ------------------------------------------------------------------------------------------------------ |
| `AZ RBAC sub p-nwsadm Owner`       | Owners      | Members have full permissions, including permissions & policy. This group is ideally empty.                     |
| `AZ RBAC sub p-nwsadm Contributor` | Contributor | Members have full permissions, excluding permissions & policy. This group has as few human members as possible. |
| `AZ RBAC sub p-nwsadm Reader`      | Reader      | Members are limited to read permissions only. Ideally, this is where most human members are placed.    |

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
* Servers: `On`
  * Plan: `Server Plan 1`
* App Service: `Off`
* Databases: `On`
  * Types:
    * Azure SQL Databases: `Off`
    * SQL Servers On Machines: `On`
    * Open-source relational databases: `Off`
    * Azure Cosmos DB: `Off`
* Storage: `On`
* Containers: `Off`
* Kubernetes: `Off`
* Container Registries: `Off`
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

* `p-nwsadm-network`
* `p-nwsadm`
* `p-nwsadm-mon`

All resources and groups are deployed into the West Europe Azure region.

#### Workload Network (`p-nwsadm-network`)

The purpose of this resource group is to supply the networking for p-nwsadm.

A lock is placed on the resource group:

* **Resource Group Lock**: resourceGroupDoNotDelete
  * Lock Type: Delete

The following resources are deployed to the resource group:

* **Network Watcher**: `p-nwsadm-network-networkwatcher`
  * Purpose: `Enable network watcher for the subscription in the region.`
* **Virtual Network**: `p-nwsadm-network-vnet`
  * Purpose: `Provide a virtual network that the workload resources connect to.`
  * Address Space: **10.100.11.64/26**
  * DNS Servers: **10.100.1.4**
  * Subnets:
    * FrontendSubnet:
      * Address Space: **10.100.11.192/27**
      * Network Security Group: `p-nwsadm-network-vnet-FrontendSubnet-nsg`
      * Route Table: `p-nwsadm-network-vnet-FrontendSubnet-rt`
      * Service Endpoints:
        * `Microsoft.KeyVault`
        * `Microsoft.Storage`
  * DDoS Protection Standard: `Disabled`
  * Peerings:
    * `p-we1net-network-vnet`:
      * Traffic To Remote Virtual Network: `Allow`
      * Traffic Forwarded From Remote Virtual Network: `Block traffic that originates from outside this virtual network`
      * Virtual Network Gateway Or Route Server: `Use the remote virtual network gateway or Route Server`
* **Network Security Group**: `p-nwsadm-network-vnet-FrontendSubnet-nsg`
  * Purpose: `Protect the FrontendSubnet`
  * Inbound Security Rules (Custom): The rules are documented in [spoke-networking-nsg.tf](https://dev.azure.com/montel/Azure%20VDC/_git/p-nwsadm?path=/cfg/spoke-networking-nsg.tf) in the p-nwsadm repository,
  * Outbound Security Rules (Custom): None
  * Diagnostic Settings:
    * `p-mgt-montijczky7je-ws`
      * Logs: `All Logs`
      * Destination Details:
        * Send To Log Analytics: `Enabled`
          * Subscription: `p-mgt`
          * Log Analytics Workspace: `p-mgt-montijczky7je-ws`
        * Archive To A Storage Account: `Enabled`
          * Subscription: `p-nwsadm`
          * Storage Account: `{workloadname}networkdiag<randomstring>`
  * NSG Flow Logs:
    * `FrontendSubnet-flowlog`
* **Route Table**: `p-nwsadm-network-vnet-FrontendSubnet-rt`
  * Purpose: `Override default and BGP routing for the FrontendSubnet`
  * Propagate Gateway Routes: `No`
  * Routes:
    * `Everywhere`:
      * Address Prefix Destination: `IP Addresses`
      * Destination IP Addresses: `0.0.0.0/0`
      * Next Hop Type: `Virtual Appliance`
      * Next Hop IP Address: `10.100.1.4`
* **NSG Flow Log**: `FrontendSubnet-flowlog`:
  * Purpose: `Enable Traffic Analytics for FrontendSubnet`
  * Flow Logs Version: `Version 2`
  * Select Storage Account:
    * Subscription: `p-nwsadm`
    * Storage Account: `{subscriptionname}networkdiag<randomstring>`
    * Retention (Days): `30`
  * Traffic Analytics: `Enabled`
    * Traffic Analytics Processing Interval: `Every 10 mins`
    * Subscription: `p-mgt`
    * Log Analytics Workspace: `p-mgt-montijczky7je-ws`
* **Application Security Group**: `p-nwsadm-networking-app-asg`
  * Purpose: `Used for all Frontend in NSG rules`
* **Storage Account** `{subscriptionname}networkdiag<randomstring>`
  * Purpose: `Provides blob storage for NSG Flow Logs`
  * Performance: `Standard`
  * Replication: `ZRS`
  * Account Kind: `StorageV2`

### Workload Resources (`p-nwsadm`)

The resource group, `p-nwsadm`, contains the resources for the workload.  A lock is placed on the resource group:

* **Resource Group Lock**: `resourceGroupDoNotDelete`
  * Lock Type: `Delete`

These are the resources deployed to `p-nwsadm`:

*Shared resources:*

* **Key Vault**: `p-nwsadmao0gu3-kv`
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
* **Recovery Services Vault**: `p-nwsadmao0gu3-rsv`
  * Replication: `GRS`
  * Backup Policies:
    * Azure Virtual Machine:
      * **Name**: `VM Daily Backup`
        * Backup Schedule:
          * Frequency: `Daily`
          * Start Time: `23:00`
          * Time Zone: `Berlin`
        * Retention Range:
          * Retention Of Daily Backup Point:
            * Days: `30`
          * Retention Of Weekly Backup Point:
            * On: `Friday`
            * For: `5 weeks`
          * Retention Of Monthly Backup Point:
            * Type: `Week Based`
            * On: `Last`
            * Day: `Friday`
            * For: `13 months`
          * Retention of Yearly Backup Point:
            * Type: `Week Based`
            * In: `December`
            * On: `Last`
            * Day: `Friday`
            * For: `10 Years`
        * Enable Tiering: `Disabled`
        * Assigned To: `p-nwsadm-app01`
* **Storage Account** `pnwsadmdiagao0gu3`
  * Purpose: `Provides blob storage VM diagnostics`
  * Performance: `Standard`
  * Replication: `ZRS`
  * Account Kind: `StorageV2`

*Nwsadm:*

* **Availability Set**: `p-nwsadm-app-as`
  * Purpose: `Used for potential future high availability`
* **Virtual Machine**: `p-nwsadm-app01`:
  * Purpose: Hosts the {app01 name} services
  * Image Reference:
    * Publisher: `MicrosoftWindowsServer`
    * Offer: `WindowsServer`
    * SKU: `2019-datacenter-gensecond`
    * Version: `latest`
  * Availability Set: `p-nwsadm-app-as`
  * SKU: `Standard_F4s_v2`
  * Disks:
    * **Standard SSD**: `p-nwsadm-app01-osdisk`, 128 GiB, Read/Write Caching, SSE with PMK & ADE Encryption
  * Networking:
    * Network Interface: `p-nwsadm-app01-nic00`
      * Subnet: `p-nwsadm-network-vnet-FrontendSubnet`
      * Static IP Address: `10.100.11.196`
      * Application Security Groups:
        * p-nwsadm-networking-app-asg
      * Accelerated Networking: `Enabled`
  * Diagnostics:
    * Boot Diagnostics: `Enabled`
    * Insights: `Enabled`
  * Updates:
    * Association: `p-mgt-auto-auto`
    * Deployment Schedules:
      * `WE, H6, 00, Windows` (Weekly, Hour 6, Starting Midnight, Windows - Definition Updates)
      * `WE, W6, 23, Windows` (Weekly, Sunday, Starting 20:00, Windows - All Updates)
  * Extensions:
    * `IaaSAntimalwareDependencyAgent`
    * `ConfigurationforWindows`
    * `CustomScriptExtension`
    * `DependencyAgentWindows`
    * `AzureDiskEncryption`
    * `IaaSDiagnostics`
    * `AzureDefenderForServers`
    * `MicrosoftMonitoringAgent`
    * `NetworkWatcherAgentWindows`
  * OS Settings:
    * Time Zone: `Berlin`

#### Monitoring Resources (`p-nwsadm-mon`)

The resource group, `p-nwsadm-mon`, contains resources that play a role in monitoring and operations.  A lock is placed on the resource group:

* **Azure Workbook**: `p-nwsadm`
  * Purpose: Document the health of the workload.
* **Shared Dashboard**: `p-nwsadm`
  * Purpose: Document the health of the workload.

* **Resource Group Lock**: `resourceGroupDoNotDelete`
  * Lock Type: `Delete`

These are the resources deployed to `p-nwsadm-mon`:

* **Action Group**: `p-nwsadm-mon-budget-ag`
  * Purpose: `Action(s) in response to workload budget alerts`
* **Action Group**: `p-nwsadm-mon-ops-critical-ag`
  * Purpose: `Action(s) in response to workload critical operations alerts`
* **Action Group**: `p-nwsadm-mon-ops-error-ag`
  * Purpose: `Action(s) in response to workload error operations alerts`
* **Action Group**: `p-nwsadm mon-ops-warning-ag`
  * Purpose: `Action(s) in response to workload warning operations alerts`
* **Action Group**: `p-nwsadm-mon-ops-info-ag`
  * Purpose: `Action(s) in response to workload informational operations alerts`
* **Shared Dashboard**: `p-nwsadm`
* **Azure Workbook**: `p-nwsadm`

### Azure Firewall Rules Collection Group

The Azure Firewall rules for this workload are stored in a Rules Collection Group called `p-nwsadm`. The Rules Collection Group is a sub-resource of the Azure Firewall Policy, `p-we1net-network-fw-firewallpolicy`, which is deployed to the `p-we1net` subscription (the VDC instance hub).

The rules collections are documented in [spoke-azurefirewall.tf](https://dev.azure.com/montel/Azure%20VDC/_git/p-nwsadm?path=/cfg/spoke-azurefirewall.tf) in the p-nwsadm repository,

### Monitoring

This section describes the standard configuration for the systems management of the workload.

#### Resource Monitoring

The following resources should have diagnostics settings enabled:

* **Resource Group**: `p-nwsadm-network`
  * **Network Security Group**: `p-nwsadm-network-vnet-FrontendSubnet-nsg`
* **Resource Group**: `p-nwsadm`
  * **Recovery Services Vault**: `p-nwsadmao0gu3-rsv`
  * **Key Vault**: `p-nwsadmao0gu3-kv`
  * **Network Interface**: `p-nwsadm-app01-nic00`

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

The following alerts are configured in the `p-nwsadm` resource group:

* **Activity Log Alert**: `A Virtual Machine was deleted in Resource Group p-nwsadm in Azure`
  * Purpose: `Detect when a virtual machine has been deleted from the resource group.`
  * Condition:
    * Signal: `Delete Virtual Machine (virtualMachines)`
  * Action Group Name: `p-mgt-mon-ops-warning-ag`
* **Metric Alert**: `p-nwsadm-app01 CPU credits`
  * Purpose: `Detect when the Bs-Series grb has run out of CPU credits.`
  * Condition:
    * Signal: `CPU Credits Remaining (Platform)`
    * Threshold: `Static`
    * Operator: `Less than`
    * Aggregation Type: `Count`
    * Threshold Value: `1`
    * Unit: `Count`
    * Aggregation Granularity (Period): `5 minutes`
    * Frequency Of Evaluation: `5 minutes`
  * Action Group Name: `p-mgt-mon-ops-warning-ag`
  * Severity: `2 - Warning`
* **Metric Alert**: `p-nwsadm-app01 CPU utilization`
  * Purpose: `Detect when the CPU utilisation is over 90% for 5 minutes.`
  * Condition:
    * Signal: `Percentage CPU (Platform)`
    * Threshold: `Static`
    * Operator: `Greater than`
    * Aggregation Type: `Count`
    * Threshold Value: `90`
    * Aggregation Granularity (Period): `5 minutes`
    * Frequency Of Evaluation: `5 minutes`
  * Action Group Name: `p-mgt-mon-ops-warning-ag`
  * Severity: `2 - Warning`
* **Metric Alert**: `p-nwsadm-app01 OS disk queue depth`
  * Purpose: `Detect when disk transactions are being queued more than usual on the OS disk.`
  * Condition:
    * Signal: `OS Disk Queue Depth (Platform)`
    * Threshold: `Dynamic`
    * Operator: `Greater than`
    * Aggregation Type: `Average`
    * Threshold Sensitivity: `Low`
    * Aggregation Granularity (Period): `5 minutes`
    * Frequency Of Evaluation: `5 minutes`
  * Action Group Name: `p-mgt-mon-ops-warning-ag`
  * Severity: `2 - Warning`
* **Scheduled Query Rule**: `p-nwsadm-app01 Available Memory is low`
  * Purpose: `Detect when there is less than 15% of memory available.`
  * Condition:
    * Search Query: `InsightsMetrics | where TimeGenerated > now() - 5m | where _ResourceId == '/subscriptions/<p-nwsadm subscription ID>/resourcegroups/p-nwsadm/providers/microsoft.compute/virtualmachines/p-nwsadm-app01' | where Namespace == 'Memory' and Name == 'AvailableMB' | extend TotalMemory = toreal(todynamic(Tags)['grb.azm.ms/memorySizeMB']) | extend AvailableMemoryPercentage = (toreal(Val) / TotalMemory) * 100.0 | where AvailableMemoryPercentage < 15`
    * Based On: `Number of results`
    * Operator: `Greater than or equal to`
    * Threshold Value: `1`
    * Period (In Minutes): `5`
    * Frequency (In Minutes): `5`
  * Email Subject: `True`
    * Subject Line: `There is less than 15% of RAM available.`
  * Action Group Name: `p-mgt-mon-ops-warning-ag`
  * Severity: `2 - Warning`
  * Mute Actions For: `20`
* **Scheduled Query Rule**: `p-nwsadm-app01 System disk IOPS is high`
  * Purpose: `Detect when disk transactions reach 500.`
  * Condition:
    * Search Query: `InsightsMetrics | where TimeGenerated > now() - 5m | where Namespace == 'LogicalDisk' and Name == 'TransfersPerSecond' | extend Disk=tostring(todynamic(Tags)['grb.azm.ms/mountId']) | where _ResourceId == '/subscriptions/<p-nwsadm subscription ID>/resourcegroups/p-nwsadm/providers/microsoft.compute/virtualmachines/p-nwsadm-app01' and Disk == 'C:' | where Val >= 500`
    * Based On: `Number of results`
    * Operator: `Greater than or equal to`
    * Threshold Value: `1`
    * Period (In Minutes): `5`
    * Frequency (In Minutes): `5`
  * Email Subject: `True`
    * Subject Line: `The C drive is at 500 IOPS or higher.`
  * Action Group Name: `p-mgt-mon-ops-warning-ag`
  * Severity: `2 - Warning`
  * Mute Actions For: `20`
* **Scheduled Query Rule**: `p-nwsadm-app01 System disk free space is low`
  * Purpose: `The disk has less than 20% of free capacity.`
  * Condition:
    * Search Query: `InsightsMetrics | where TimeGenerated > now() - 5m | where Namespace == 'LogicalDisk' and Name == 'FreeSpacePercentage' | extend Disk=tostring(todynamic(Tags)['grb.azm.ms/mountId']) | where _ResourceId == '/subscriptions/<p-nwsadm subscription ID>/resourcegroups/p-nwsadm/providers/microsoft.compute/virtualmachines/p-nwsadm-app01' and Disk == 'C:' | where Val < 20`
    * Based On: `Number of results`
    * Operator: `Greater than or equal to`
    * Threshold Value: `1`
    * Period (In Minutes): `5`
    * Frequency (In Minutes): `5`
  * Email Subject: `True`
    * Subject Line: `The C drive has less than 20% free capacity.`
  * Action Group Name: `p-mgt-mon-ops-warning-ag`
  * Severity: `2 - Warning`
  * Mute Actions For: `20`

#### Cost Management

* **Budget**: `p-nwsadm`
  * Purpose: `Provide a budget and alerts for cost management of the workload subscription`
  * Create A Budget:
    * Scope: `p-nwsadm`
    * Reset Period: `Monthly`
    * Creation Date: `<Today>`
    * Expiration Date: `<As late as Azure allows>`
    * Budget Amount: `400`
  * Set Alerts:
    * Alert Conditions:
      * Type: `Actual`
        * % of Budget: `100`
        * Action Group: `p-nwsadm-mon-budget-ag`
      * Type: `Forecasted`
        * % of Budget: `100`
        * Action Group: `p-nwsadm-mon-budget-ag`
          * Alert Recipients (Email):
            * `{Email distribution list}`
          * Language Preference:
            * `Norwegian (Norway)`