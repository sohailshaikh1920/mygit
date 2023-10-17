### {subscription name} Subscription

#### Subscription Configuration

{subscription name} is deployed into a subscription called `{subscription name}`. The subscription is placed into a Management Group called `WE1 Production Spokes`.

The configuration of the subscription is described below.

##### Role-Based Access Control

Access to this subscription should be restricted to those supporting and operating the contained components. There are 3 Azure AD access groups to control access to the subscription and the contained resource groups and resources:

| Group Name                                             | Role        | Description                                                                                            |
| ------------------------------------------------------ | ----------- | ------------------------------------------------------------------------------------------------------ |
| `AZ RBAC sub {subscription name} Owner`       | Owners      | Members have full permissions, including permissions & policy. This group is ideally empty.                     |
| `AZ RBAC sub {subscription name} Contributor` | Contributor | Members have full permissions, excluding permissions & policy. This group has as few human members as possible. |
| `AZ RBAC sub {subscription name} Reader`      | Reader      | Members are limited to read permissions only. Ideally, this is where most human members are placed.    |

##### Diagnostics Settings

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

##### Microsoft Defender for Cloud

Security and compliance features are provided by Microsoft Defender for Cloud. There are two tiers:

* **Free**: Basic features and configurations are possible.
* **Paid**: Special security monitoring features for resources can be enabled per-support resource type.

The configurations for this subscription are configured as follows:

###### Defender Plans

The plans are configure as follows:

* Defender CSPM: `Off`
* Servers: `On`
  * Plan: `Server Plan 1`
* App Service: `Off`
* Databases: `Off`
* Storage: `On`
* Containers: `Off`
* Kubernetes: `Off`
* Container Registries: `Off`
* Key Vault: `On`
* Resource Manager: `On`
* DNS: `Off`

###### Auto Provisioning

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

###### Email Notifications

Notifications are configured as follows:

* Email Recipients:
  * All Users With The Following Roles: Owner, Contributor
  * Additional Email Addresses: A distribution list to be provided
* Notification Types:
  * Notify About Alerts With The Following Severity (Or Higher): Medium

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

#### Resource Groups

The following resource groups are created:

* `{subscription name}-network`
* `{subscription name}-pub`
* `{subscription name}-mon`

All resources and groups are deployed into the {Azure Region name} Azure region.

##### Workload Network (`{subscription name}-network`)

The purpose of this resource group is to supply the networking for {subscription name}. 

A lock is placed on the resource group:

* **Resource Group Lock**: resourceGroupDoNotDelete
  * Lock Type: Delete

The following resources are deployed to the resource group:

* **Network Watcher**: `{subscription name}-network-networkwatcher`
  * Purpose: `Enable network watcher for the subscription in the region.`
* **Virtual Network**: `{subscription name}-network-vnet`
  * Purpose: `Provide a virtual network that the workload resources connect to.`
  * Address Space: **{ip address space}.0/25**
  * DNS Servers: **10.100.1.4**
  * Subnets:
    * FrontendSubnet:
      * Address Space: **{ip address space}.0/26**
      * Network Security Group: `{subscription name}-network-vnet-FrontendSubnet-nsg`
      * Route Table: `{subscription name}-network-vnet-FrontendSubnet-rt`
      * Service Endpoints:
        * `Microsoft.KeyVault`
        * `Microsoft.Storage`
      * DDoS Protection Standard: `Disabled`
  * Peerings:
    * `p-we1net-network-vnet`:
      * Traffic To Remote Virtual Network: `Allow`
      * Traffic Forwarded From Remote Virtual Network: `Block traffic that originates from outside this virtual network`
      * Virtual Network Gateway Or Route Server: `Use the remote virtual network gateway or Route Server`
* **Network Security Group**: `{subscription name}-network-vnet-FrontendSubnet-nsg`
  * Purpose: `Protect the FrontendSubnet`
  * Inbound Security Rules (Custom):
    * `AllowAllFromInternalAddressesToFrontendSubnet`:
      * Source: `IP Addresses`
      * Source IP Addresses: `192.168.0.0/16`, `172.16.0.0/12`, `10.0.0.0/8`
      * Source Port Ranges: `*`
      * Destination: `{ip address space}.0/26`
      * Service: `Custom`
      * Destination Port Ranges: `*`
      * Protocol: `All`
      * Action: `Allow`
      * Priority: `1000`
    * `AllowProbeFromAzureloadbalancerToFrontendSubnet`:
      * Source: `Service Tag`
      * Source Service Tag: `AzureLoadBalancer`
      * Source Port Ranges: `*`
      * Destination: `IP Addresses`
      * Destination IP Addresses: `{ip address space}.0/26`
      * Service: `Custom`
      * Destination Port Ranges: `*`
      * Protocol: `Any`
      * Action: `Allow`
      * Priority: `3900`
    * `DenyAll`:
      * Source: `Any`
      * Source Port Ranges: `*`
      * Destination: `IP Addresses`
      * Destination IP Addresses: `Any`
      * Service: Custom
      * Destination Port Ranges: `*`
      * Protocol: `Any`
      * Action: `Allow`
      * Priority: `4000`
  * Outbound Security Rules (Custom): None
  * Diagnostic Settings:
    * `p-mgt-montijczky7je-ws`
      * Logs: `All Logs`
      * Destination Details:
        * Send To Log Analytics: `Enabled`
          * Subscription: `p-mgt`
          * Log Analytics Workspace: `p-mgt-montijczky7je-ws`
        * Archive To A Storage Account: `Enabled`
          * Subscription: `{subscription name}`
          * Storage Account: `{workloadname}networkdiag<randomstring>`
  * NSG Flow Logs:
    * `FrontendSubnet-flowlog`
* **Route Table**: `{subscription name}-network-vnet-FrontendSubnet-rt`
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
    * Subscription: `{subscription name}`
    * Storage Account: `{subscriptionname}networkdiag<randomstring>`
    * Retention (Days): `30`
  * Traffic Analytics: `Enabled`
    * Traffic Analytics Processing Interval: `Every 10 mins`
    * Subscription: `p-mgt`
    * Log Analytics Workspace: `p-mgt-montijczky7je-ws`
* **Storage Account** `{subscriptionname}networkdiag<randomstring>`
  * Purpose: `Provides blob storage for NSG Flow Logs`
  * Performance: `Standard`
  * Replication: `ZRS`
  * Account Kind: `StorageV2`

#### Workload Resources (`{subscription name}`)

The resource group, `{subscription name}`, contains the resources for the workload.  A lock is placed on the resource group:

* **Resource Group Lock**: `resourceGroupDoNotDelete`
  * Lock Type: `Delete`

These are the resources deployed to `{subscription name}`:

* **Resource Group**: `{subscription name}`
  * **Key Vault**: `{subscription name}<random string>-kv`
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
  * **Recovery Services Vault**: `{subscription name}<random string>-rsv`
    * **Backup Policy**: 
      * Settings: `?`
      * Assigned: `{subscription name}-vm01`
  * **Virtual Machine**: `{subscription name}-vm01`:
    * Image Reference:
      * Publisher: `MicrosoftWindowsServer`
      * Offer: `WindowsServer`
      * SKU: `2019-Datacenter`
      * Version: `Latest`
    * Availability Zone: `1`
    * SKU: `B2ms`
    * Disks:
      * **Standard SSD**: `{subscription name}-vm01-osdisk`, 128 GiB, Read/Write Caching, SSE with PMK & ADE Encryption
      * **Standard SSD**: `{subscription name}-vm01-data001`, 32 GiB (ADDS data), Read-Only Caching, SSE with PMK & ADE Encryption
    * Subnet: `{subscription name}-network-vnet-FrontendSubnet`
    * Static IP Address: `{ip address space}.4`
    * Diagnostics:
      * Boot Diagnostics: `Enabled`
      * Insights: `Enabled`
    * Updates: 
      * Association: `p-mgt-auto-auto`
      * Deployment Schedules: 
        * `WE, H6, 00, Windows` (Weekly, Hour 6, Starting Midnight, Windows - Definition Updates)
        * `WE, W7, 20, Windows` (Weekly, Sunday, Starting 20:00, Windows - All Updates)
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
* **Storage Account** `{subscriptionname}diag<randomstring>`
  * Purpose: `Provides blob storage VM diagnostics`
  * Performance: `Standard`
  * Replication: `ZRS`
  * Account Kind: `StorageV2`

##### Monitoring Resources (`{subscription name}-mon`)

The resource group, `{subscription name}-mon`, contains resources that play a role in monitoring and operations.  A lock is placed on the resource group:

* **Resource Group Lock**: `resourceGroupDoNotDelete`
  * Lock Type: `Delete`

These are the resources deployed to `{subscription name}-mon`:

* **Resource Group**: `{subscription name}-mon`
  * **Action Group**: `{subscription name}-mon-budget-ag`
    * Purpose: `Action(s) in response to workload budget alerts`
  * **Action Group**: `{subscription name}-mon-ops-critical-ag`
    * Purpose: `Action(s) in response to workload critical operations alerts`
  * **Action Group**: `{subscription name}-mon-ops-error-ag`
    * Purpose: `Action(s) in response to workload error operations alerts `
  * **Action Group**: `{subscription name} mon-ops-warning-ag`
    * Purpose: `Action(s) in response to workload warning operations alerts`
  * **Action Group**: `{subscription name}-mon-ops-info-ag`
    * Purpose: `Action(s) in response to workload informational operations alerts`
  * **Shared Dashboard**: `{subscription name}`
  * **Azure Workbook**: `{subscription name}`

#### Azure Firewall Rules Collection Group

The Azure Firewall rules for this workload are stored in a Rules Collection Group called `{subscription name}`. The Rules Collection Group is a sub-resource of the Azure Firewall Policy, `p-we1net-network-fw-firewallpolicy`, which is deployed to the `p-we1net` subscription (the VDC instance hub).

The following are the Rules Collections in the Rules Collection Group:

* **Rules Collection**: `Nat-Dnat-{subscription name}`
  * Purpose: `Enable DNAT from The Internet to private IP addresses`
  * Type: `DNAT`
  * Priority: `100`
  * Action: `Allow`
  * Rules: `None`
* **Rules Collection**: `Network-Deny-{subscription name}`
  * Purpose: `Create specific overrides for rules in Network-Allow-{subscription name}`
  * Type: `Network`
  * Priority: `200`
  * Action: `Deny`
  * Rules: `None`
* **Rules Collection**: `Network-Allow-{subscription name}`
  * Purpose: `Allow TCP, UDP ICMP flows.`
  * Type: `Network`
  * Priority: `300`
  * Action: `Allow`
  * Rules:
    * `AllowAllFromInternalAddressesToFrontendSubnet`:
      * Source Type: `IP Address`
      * Source IP Addresses: `192.168.0.0/16`, `172.16.0.0/12`, `10.0.0.0/8`
      * Protocol: `Any`
      * Destination Ports: `*`
      * Detination Type: `IP Address`
      * Destination: `{ip address space}.0/26`
* **Rules Collection**: `Application-Deny-{subscription name}`
  * Purpose: `Create specific overrides for rules in Application-Allow-{subscription name}`
  * Type: `Application`
  * Priority: `400`
  * Action: `Deny`
  * Rules: `None`
* **Rules Collection**: `Application-Allow-{subscription name}`
  * Purpose: `Allow outbound flows to HTTP/HTTPS/SQL Server`
  * Type: `Application`
  * Priority: `500`
  * Action: `Allow`
  * Rules:
    * AllowAllFromFrontendSubnetToInternet
      * Source Type: `IP Address`
      * Source: `{ip address space}.0/26`
      * Protocol: `http:80`, `https:443`
      * Destination Type: `FQDN`
      * Destination: `*`

#### Monitoring

This section describes the standard configuration for the systems management of the workload.

##### Resource Monitoring

The following resources should have diagnostics settings enabled:

* **Resource Group**: `{subscription name}-network`
  * **Network Security Group**: `{subscription name}-network-vnet-FrontendSubnet-nsg`
* **Resource Group**: `{subscription name}`
  * **Recovery Services Vault**: `{subscription name}<random string>-rsv`
  * **Key Vault**: `{subscription name}<random string>-kv`
  * **Network Interface**: `{subscription name}-vm01-nic00`
  * **Network Interface**: `{subscription name}-vm02-nic00`

Diagnostics Settings should be configured as follows:

* **Diagnostics Setting**: `p-mgt-montijczky7je-ws`
  * Purpose: `Send log and performance data for resources to the central platform monitoring Log Analytics Workspace.`
  * Logs: `All Logs`
  * Metrics: `Enabled`
  * Destination Details:
    * Send To Log Analytics Workspace: `Enabled`
      * Subscription: `p-mgt`
      * Log Analytics Workspace: `p-mgt-montijczky7je-ws`

##### Alerting

The following alerts are configured in the `{subscription name}` resource group:

* **Activity Log Alert**: `A Virtual Machine was deleted in Resource Group {subscription name} in Azure`
  * Purpose: `Detect when a virtual machine has been deleted from the resource group.`
  * Condition:
    * Signal: `Delete Virtual Machine (virtualMachines)`
  * Action Group Name: `p-mgt-mon-ops-warning-ag`
* **Metric Alert**: `{subscription name}-vm01 CPU credits`
  * Purpose: `Detect when the Bs-Series VM has run out of CPU credits.`
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
* **Metric Alert**: `{subscription name}-vm01 CPU utilization`
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
* **Metric Alert**: `{subscription name}-vm01 OS disk queue depth`
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
* **Metric Alert**: `{subscription name}-vm01 data disk queue depth`
  * Purpose: `Detect when disk transactions are being queued more than usual on the data disk.`
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
* **Scheduled Query Rule**: `{subscription name}-vm01 Available Memory is low`
  * Purpose: `Detect when there is less than 15% of memory available.`
  * Condition:
    * Search Query: `InsightsMetrics | where TimeGenerated > now() - 5m | where _ResourceId == '/subscriptions/<{subscription name} subscription ID>/resourcegroups/{subscription name}/providers/microsoft.compute/virtualmachines/{subscription name}-vm01' | where Namespace == 'Memory' and Name == 'AvailableMB' | extend TotalMemory = toreal(todynamic(Tags)['vm.azm.ms/memorySizeMB']) | extend AvailableMemoryPercentage = (toreal(Val) / TotalMemory) * 100.0 | where AvailableMemoryPercentage < 15`
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
* **Scheduled Query Rule**: `{subscription name}-vm01 Data disk IOPS is high`
  * Purpose: `Detect when disk transactions reach 500.`
  * Condition:
    * Search Query: `InsightsMetrics | where TimeGenerated > now() - 5m | where Namespace == 'LogicalDisk' and Name == 'TransfersPerSecond' | extend Disk=tostring(todynamic(Tags)['vm.azm.ms/mountId']) | where _ResourceId == '/subscriptions/<{subscription name} subscription ID>/resourcegroups/{subscription name}/providers/microsoft.compute/virtualmachines/{subscription name}-vm01' and Disk == 'F:' | where Val >= 500`
    * Based On: `Number of results`
    * Operator: `Greater than or equal to`
    * Threshold Value: `1`
    * Period (In Minutes): `5`
    * Frequency (In Minutes): `5`
  * Email Subject: `True`
    * Subject Line: `The F drive is at 500 IOPS or higher.`
  * Action Group Name: `p-mgt-mon-ops-warning-ag`
  * Severity: `2 - Warning`
  * Mute Actions For: `20`
* **Scheduled Query Rule**: `{subscription name}-vm01 Data disk free space is low`
  * Purpose: `The disk has less than 20% of free capacity.`
  * Condition:
    * Search Query: `InsightsMetrics | where TimeGenerated > now() - 5m | where Namespace == 'LogicalDisk' and Name == 'FreeSpacePercentage' | extend Disk=tostring(todynamic(Tags)['vm.azm.ms/mountId']) | where _ResourceId == '/subscriptions/<{subscription name} subscription ID>/resourcegroups/{subscription name}/providers/microsoft.compute/virtualmachines/{subscription name}-vm01' and Disk == 'F:'| where Val < 20`
    * Based On: `Number of results`
    * Operator: `Greater than or equal to`
    * Threshold Value: `1`
    * Period (In Minutes): `5`
    * Frequency (In Minutes): `5`
  * Email Subject: `True`
    * Subject Line: `The F drive has less than 20% free capacity.`
  * Action Group Name: `p-mgt-mon-ops-warning-ag`
  * Severity: `2 - Warning`
  * Mute Actions For: `20`
* **Scheduled Query Rule**: `{subscription name}-vm01 System disk IOPS is high`
  * Purpose: `Detect when disk transactions reach 500.`
  * Condition:
    * Search Query: `InsightsMetrics | where TimeGenerated > now() - 5m | where Namespace == 'LogicalDisk' and Name == 'TransfersPerSecond' | extend Disk=tostring(todynamic(Tags)['vm.azm.ms/mountId']) | where _ResourceId == '/subscriptions/<{subscription name} subscription ID>/resourcegroups/{subscription name}/providers/microsoft.compute/virtualmachines/{subscription name}-vm01' and Disk == 'C:' | where Val >= 500`
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
* **Scheduled Query Rule**: `{subscription name}-vm01 System disk free space is low`
  * Purpose: `The disk has less than 20% of free capacity.`
  * Condition:
    * Search Query: `InsightsMetrics | where TimeGenerated > now() - 5m | where Namespace == 'LogicalDisk' and Name == 'FreeSpacePercentage' | extend Disk=tostring(todynamic(Tags)['vm.azm.ms/mountId']) | where _ResourceId == '/subscriptions/<{subscription name} subscription ID>/resourcegroups/{subscription name}/providers/microsoft.compute/virtualmachines/{subscription name}-vm01' and Disk == 'C:' | where Val < 20`
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

##### Cost Management

* **Budget**: `{subscription name}`
  * Purpose: `Provide a budget and alerts for cost management of the workload subscription`
  * Create A Budget:
    * Scope: `{subscription name}`
    * Reset Period: `Monthly`
    * Creation Date: `<Today>`
    * Expiration Date: `<As late as Azure allows>`
    * Budget Amount: `500`
  * Set Alerts:
    * Alert Conditions:
      * Type: `Actual`
        * % of Budget: `100`
        * Action Group: `{subscription name}-mon-budget-ag`
      * Type: `Forecasted`
        * % of Budget: `100`
        * Action Group: `{subscription name}-mon-budget-ag`
          * Alert Recipients (Email):
            * `{Email distribution list}`
          * Language Preference:
            * `Norwegian (Norway)`
