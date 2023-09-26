## Test Spoke 1 - IaaS Sample

The first test workload is **Test Spoke 1**, also known as **t-tstsp1**, deployed into the WE1 Virtual Data Centre instance.

### Purpose

Test Spoke 1 is a workload that is based on IaaS virtual machines. The purposes of this test workload are:

* Enable end-to-end testing of Virtual Data Centre instance functions with Azure virtual machines.
* The workload can be used for troubleshooting.
* Provide a sample workload for the organisation that is based on Azure virtual machines.

Virtual machines are familiar and easier to understand, from a networking perspective, than PaaS workloads, making them an ideal resource type to demonstrate design and features.

Benefits of using virtual machines for testing and troubleshooting are:

* You can log into virtual machines to perform ICMP based tests (ping and tracert, which are of limited value in an Azure virtual network) and test-netconnection.
* Virtual machines support more features, such as Connection Troubleshoot & Connection Monitor in Network Watcher and Effective Routes in the Azure Network Interface.
* The concept of virtual machines is more familiar to operators than PaaS resources.

### Functional Design

Test Spoke 1 is a simple workload with a common design based on Windows Server virtual machines. The workload emulates, without any application or data deployment, a fault-tolerant two-tier web application:

* Two IIS web servers that are load balanced by the Virtual Data Centre instance WAF and shared to the Internet
* A pair of SQL Server virtual machines - that do not have SQL Server installed to avoid license costs.

The virtual network has two subnets:

* FrontendSubnet: For the web servers.
* BackendSubnet: For the SQL Server virtual machines.

Each of the subnets has:

* **Network Security Group**:
  
  Each subnet is micro-segmented using a Network Security Group. A **DenyAll** rule blocks all traffic - higher priority rules are required to allow necessary flows for the workload only.

* **Routing**:
  
  The next hop from the subnets is the firewall in the hub to reach anything outside of the virtual network. Flows inside of the virtual network do not leave the virtual network.

An Azure Key Vault is deployed to store secrets:

* The guest OS default administrator username and password for the virtual machines.
* Any other secrets or certificates for the workload - there are none.

A Recovery Services Vault is deployed to protect the virtual machines using Azure Backup.

The WAF shares the workload as `vdc-tstsp1.montelnews.com`. The WAF will reverse proxy client requests, via the hub firewall, to the two web servers over HTTP.

### Detailed Design

#### Subscription Configuration

The workload name is `t-tstsp1`. It is placed in the Management Group called `WE1 Non Production Spokes`.

##### Role-Based Access Control

Access to this subscription should be restricted to those supporting and operating the contained components. There are 3 Azure AD access groups to control access to the subscription and the contained resource groups and resources.:

| Group Name                         | Role        | Description                                                                                            |
| ---------------------------------- | ----------- | ------------------------------------------------------------------------------------------------------ |
| `AZ RBAC sub t-tstsp1 Owner`       | Owners      | Members have full permissions, including permissions. This group is ideally empty.                     |
| `AZ RBAC sub t-tstsp1 Contributor` | Contributor | Members have full permissions, excluding permissions. This group has as few human members as possible. |
| `AZ RBAC sub t-tstsp1 Reader`      | Reader      | Members are limited to read permissions only. Ideally, this is where most human members are placed.    |

##### Microsoft Defender for Cloud

Security and compliance features are provided by Microsoft Defender for Cloud. There are two tiers:

* **Free**: Basic features and configurations are possible.
* **Paid**: Special security monitoring features for resources can be enabled per-support resource type.

The configurations for this subscription are configured as follows:

###### Defender Plans

The plans that will be activated will depend on the workload architecture and security classification. The following plans should be considered:

* Defender CSPM: `Off`
* Servers: `Off`
* App Service: `Off`
* Databases: `Off`.
* Storage: `Off`.
* Key Vault: `Off`.
* Resource Manager: Off.
* DNS: Off.

###### Auto Provisioning

The deployment of extensions is configured as follows:

* Log Analytics Agent/Azure Monitor Agent: On
  * Agent Type: Log Analytics
  * Custom Workspace: p-mgt-montijczky7je-ws
  * Security Events Storage: Minimal
* Vulnerability Assessment for Machines: Off
* Guest Configuration Agent: Off
* Microsoft Defender for Containers Components: Off

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

###### Workflow Automation

No configurations are included.

###### Continuous Export

No configurations are included.

##### Auditing

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

There are two Resource Groups in the design. The first Resource Group contains the network resources:

* **Resource Group**: `t-tstsp1-network`
  * **Flow Log**: `FrontendSubnet-flowlog`
    * Purpose: `Enable NSG Traffic Analytics for the FrontendSubnet`
    * Flow Logs Version: `Version 2`
    * Select Storage Account:
      * Subscription: `t-tstsp1`
      * Storage Account: `ttstsp1networkdiagd57kc`
      * Retention (Days): `30`
    * Traffic Analytics: `Enabled`
      * Traffic Analytics Processing Interval: `Every 10 mins`
      * Subscription: `p-mgt`
      * Log Analytics Workspace: `p-mgt-montijczky7je-ws`
  * **Flow Log**: `BackendSubnet-flowlog`
    * Purpose: `Enable NSG Traffic Analytics for the BackendSubnet`
    * Flow Logs Version: `Version 2`
    * Select Storage Account:
      * Subscription: `t-tstsp1`
      * Storage Account: `ttstsp1networkdiagd57kc`
      * Retention (Days): `30`
    * Traffic Analytics: `Enabled`
      * Traffic Analytics Processing Interval: `Every 10 mins`
      * Subscription: `p-mgt`
      * Log Analytics Workspace: `p-mgt-montijczky7je-ws`
  * **Application Security Group**: `t-tstsp1-network-web-asg`
    * **Purpose**: `Group the NICs of the web server VMs for NSG rules`
  * **Application Security Group**: `t-tstsp1-network-sql-asg`
    * **Purpose**: `Group the NICs of the SQL Server VMs for NSG rules`
  * **Network Watcher**: `t-tstsp1-network-networkwatcher`
    * **Purpose**: `Enable Network Watcher for the workload subscription in the Azure region of the Virtual Data Centre instance.`
  * **Virtual Network**: `t-tstsp1-network-vnet`
    * Purpose: `Provide a virtual network for the workload virtual machines to connect to.`
    * Address Space: **10.100.9.0/25**
    * DNS Servers: `The IP address of the hub firewall`
    * Subnets:
      * FrontendSubnet:
        * Address Space: **10.100.9.0/26**
        * Network Security `Group: t-tstsp1-network-vnet-FrontendSubnet-nsg`
        * Route Table: `t-tstsp1-network-vnet-FrontendSubnet-rt`
        * Service Endpoints:
          * `Microsoft.KeyVault`
          * `Microsoft.Storage`
      * BackendSubnet:
        * Address Space: **10.100.9.64/26**
        * Network Security Group: `t-tstsp1-network-vnet-BackendSubnet-nsg`
        * Route Table: `t-tstsp1-network-vnet-BackendSubnet-rt`
        * Service Endpoints:
          * `Microsoft.KeyVault`
          * `Microsoft.Storage`
    * DDoS Protection Standard: `Disabled`
    * Peerings:
      * `p-we1net-network-vnet`:
        * Traffic To Remote Virtual Network: `Allow`
        * Traffic Forwarded From Remote Virtual Network: `Block traffic that originates from outside this virtual network`
        * Virtual Network Gateway Or Route Server: **Use the remote virtual network gateway or Route Server**
  * **Network Security Group**: `t-tstsp1-network-vnet-FrontendSubnet-nsg`
    * Purpose: `Control traffic into and inside the FrontendSubnet.`
    * Inbound Security Rules (Custom):
      * `AllowDnsFromFirewallToFrontendsubnet`:
        * Source: `IP Addresses`
        * Source IP Addresses: `10.100.1.4`
        * Source Port Ranges: `*`
        * Destination: `Application Security Group`
          * `t-tstsp1-network-web-asg`
        * Service: `DNS (UDP)`
        * Destination Port Ranges: `53`
        * Protocol: `UDP`
        * Action: `Allow`
        * Priority: `1100`
      * `AllowHttpFromTestonpremToWebservers`:
        * Source: `IP Addresses`
        * Source IP Addresses: `10.100.4.0/24`
        * Source Port Ranges: `*`
        * Destination: `Application Security Group`
          * `t-tstsp1-network-web-asg`
        * Service: `HTTP`
        * Destination Port Ranges: `80`
        * Protocol: `TCP`
        * Action: `Allow`
        * Priority: `1200`
      * `AllowProbeFromAzureloadbalancerToFrontendsubnet`:
        * Source: `Service Tag`
        * Source Service Tag: `AzureLoadBalancer`
        * Source Port Ranges: `*`
        * Destination: `IP Addresses`
        * Destination IP Addresses: `10.100.9.0/26`
        * Service: `Custom`
        * Destination Port Ranges: `*`
        * Protocol: `Any`
        * Action: `Allow`
        * Priority: `3900`
      * `DenyAll`:
        * Source: `Any`
        * Source Port Ranges: `*`
        * Destination: `Any`
        * Service: `Custom`
        * Destination Port Ranges: `*`
        * Protocol: `Any`
        * Action: `Allow`
        * Priority: `4000`
    * Outbound Security Rules (Custom): `None`
    * Diagnostic Settings:
      * `p-mgt-montijczky7je-ws`
        * Logs: `All Logs`
        * Destination Details:
          * Send To Log Analytics: `Enabled`
            * Subscription: `p-mgt`
            * Log Analytics Workspace: `p-mgt-montijczky7je-ws`
          * Archive To A Storage Account: `Disabled`
  * **Network Security Group**: `t-tstsp1-network-vnet-BackendSubnet-nsg`
    * Purpose: `Control traffic into and inside the BackendSubnet`.
    * Inbound Security Rules (Custom):
      * `AllowDnsFromFirewallToBackendSubnet`:
        * Source: `IP Addresses`
        * Source IP Addresses: `10.100.1.4`
        * Source Port Ranges: `*`
        * Destination: `Application Security Group`
          * `t-tstsp1-network-sql-asg`
        * Service: `DNS (UDP)`
        * Destination Port Ranges: `53`
        * Protocol: `UDP`
        * Action: `Allow`
        * Priority: `1100`
      * `AllowSqlFromWebserversToSqlservers`:
        * Source: `Application Security Group`
          * `t-tstsp1-network-web-asg`
        * Source Port Ranges: `*`
        * Destination: `Application Security Group`
          * `t-tstsp1-network-sql-asg`
        * Service: `MS SQL`
        * Destination Port Ranges: `1433`
        * Protocol: `TCP`
        * Action: `Allow`
        * Priority: `1200`
      * `AllowProbeFromAzureloadbalancerToBackendSubnet`:
        * Source: `Service Tag`
        * Source Service Tag: `AzureLoadBalancer`
        * Source Port Ranges: `*`
        * Destination: `IP Addresses`
        * Destination IP Addresses: `10.100.9.64/26`
        * Service: `Custom`
        * Destination Port Ranges: `*`
        * Protocol: `Any`
        * Action: `Allow`
        * Priority: `3900`
      * `DenyAll`:
        * Source: `Any`
        * Source Port Ranges: `*`
        * Destination: `Any`
        * Service: `Custom`
        * Destination Port Ranges: `*`
        * Protocol: `Any`
        * Action: `Allow`
        * Priority: `4000`
    * Outbound Security Rules (Custom): `None`
    * Diagnostic Settings:
      * `p-mgt-montijczky7je-ws`
        * Logs: All Logs
        * Destination Details:
          * Send To Log Analytics: `Enabled`
            * Subscription: `p-mgt`
            * Log Analytics Workspace: `p-mgt-montijczky7je-ws`
          * Archive To A Storage Account: `Disabled`
  * **Route Table**: `t-tstsp1-network-vnet-FrontendSubnet-rt`
    * Purpose: `Override default and BGP routing for the FrontendSubnet`
    * Propagate Gateway Routes: `No`
    * Routes:
      * Internet:
        * Address Prefix Destination: `IP Addresses`
        * Destination IP Addresses: `0.0.0.0/0`
        * Next Hop Type: `Appliance`
        * Next Hop IP Address: `<Address of the hub firewall>`
  * **Route Table**: `t-tstsp1-network-vnet-BackendSubnet-rt`
    * Purpose: `Override default and BGP routing for the BackendSubnet`
    * Propagate Gateway Routes: `No`
    * Routes:
      * Internet:
        * Address Prefix Destination: `IP Addresses`
        * Destination IP Addresses: `0.0.0.0/0`
        * Next Hop Type: `Appliance`
        * Next Hop IP Address: `<Address of the hub firewall>`
  * **Storage Account**: `ttstsp1networkdiagd57kc`
    * Purpose: `Provides blob storage NSG Traffic Analytics`
    * Performance: `Standard`
    * Replication: `LRS`
    * Account Kind: `StorageV2`

The second resource group contains the resources for the workload:

* **Resource Group**: `t-tstsp1`
  * **Key Vault**: `t-tstsp1x5ry47gk-kv`
    * SKU: `Premium`
    * Soft Delete: `Enabled, 90 days, Enable Purge Protection`
    * Access Policy:
      * Backup Management Service:
        * Key: `Get, List, Backup`
        * Secret: `Get, List, Backup`
        * Certificate: `None`
  * **Recovery Services Vault**: `t-tstsp1x5ry47-rsv`
    * **Backup Policy**:
      * Settings: `?`
      * Assigned: `t-tstsp1-web01, t-tstsp1-web02, t-tstsp1-sql01, t-tstsp1-sql02`
  * **Virtual Machine**: `t-tstsp1-web01`:
    * Image Reference:
      * Publisher: `MicrosoftWindowsServer`
      * Offer: `WindowsServer`
      * SKU: `2019-Datacenter`
      * Version: `Latest`
    * Availability Zone: `1`
    * SKU: `B2ms`
    * Disks:
      * **Standard SSD**: `t-tstsp1-web01-osdisk`, 128 GiB, Read/Write Caching, SSE with PMK & ADE Encryption
    * NIC:
      * **Subnet**: `t-tstsp1-network-vnet-FrontendSubnet`
      * **Static IP Address**: `10.100.9.4`
    * Diagnostics:
      * Boot Diagnostics: `Enabled`
      * Insights: `Enabled`
    * Updates:
      * Association: `p-mgt-auto-auto`
      * Deployment Schedules:
        * `WE, H6, 00, Windows` (Weekly, Hour 6, Starting Midnight, Windows - Definition Updates)
        * `WE, W7, 23, Windows` (Weekly, Sunday, Starting 20:00, Windows - All Updates)
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
  * **Virtual Machine**: `t-tstsp1-web02`:
    * Image Reference:
      * Publisher: `MicrosoftWindowsServer`
      * Offer: `WindowsServer`
      * SKU: `2019-Datacenter`
      * Version: `Latest`
    * Availability Zone: `1`
    * SKU: `B2ms`
    * Disks:
      * **Standard SSD**: `t-tstsp1-web02-osdisk`, 128 GiB, Read/Write Caching, SSE with PMK & ADE Encryption
    * NIC:
      * **Subnet**: `t-tstsp1-network-vnet-FrontendSubnet`
      * **Static IP Address**: `10.100.9.5`
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
  * **Virtual Machine**: `t-tstsp1-sql01`:
    * Image Reference:
      * Publisher: `MicrosoftWindowsServer`
      * Offer: `WindowsServer`
      * SKU: `2019-Datacenter`
      * Version: `Latest`
    * Availability Zone: `1`
    * SKU: `B2ms`
    * Disks:
      * **Standard SSD**: `t-tstsp1-sql01-osdisk`, 128 GiB, Read/Write Caching, SSE with PMK & ADE Encryption
    * NIC:
      * **Subnet**: `t-tstsp1-network-vnet-FrontendSubnet`
      * **Static IP Address**: `10.100.9.68`
    * Diagnostics:
      * Boot Diagnostics: `Enabled`
      * Insights: `Enabled`
    * Updates:
      * Association: `p-mgs-auto-auto`
      * Deployment Schedules:
        * `WE, H6, 00, Windows` (Weekly, Hour 6, Starting Midnight, Windows - Definition Updates)
        * `WE, W7, 23, Windows` (Weekly, Sunday, Starting 20:00, Windows - All Updates)
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
  * **Virtual Machine**: `t-tstsp1-sql02`:
    * Image Reference:
      * Publisher: `MicrosoftWindowsServer`
      * Offer: `WindowsServer`
      * SKU: `2019-Datacenter`
      * Version: `Latest`
    * Availability Zone: `1`
    * SKU: `B2ms`
    * Disks:
      * **Standard SSD**: `t-tstsp1-sql02-osdisk`, 128 GiB, Read/Write Caching, SSE with PMK & ADE Encryption
    * NIC:
      * **Subnet**: `t-tstsp1-network-vnet-FrontendSubnet`
      * **Static IP Address**: `10.100.9.69`
    * Diagnostics:
      * Boot Diagnostics: `Enabled`
      * Insights: `Enabled`
    * Updates:
      * Association: `p-mgs-auto-auto`
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

There is no resource group for monitoring & alerting because this workload does not require it.

##### Azure Firewall Rules Collection Group

The Azure Firewall rules for this workload are stored in a Rules Collection Group called `t-tstsp1`. The Rules Collection Group is a sub-resource of the Azure Firewall Policy, `p-we1net-network-fw-firewallpolicy`, which is deployed to the `p-we1net` subscription (the Virtual Data Centre instance hub).

The following are the Rules Collections in the Rules Collection Group:

* **Rules Collection**: `Nat-Dnat-t-tstsp1`
  * Purpose: `Enable DNAT from The Internet to private IP addresses`
  * Type: `DNAT`
  * Priority: `100`
  * Action: `Allow`
  * Rules: `None`
* **Rules Collection**: `Network-Deny-t-tstsp1`
  * Purpose: `Create specific overrides for rules in Network-Allow-t-tstsp1`
  * Type: `Network`
  * Priority: `200`
  * Action: `Deny`
  * Rules: `None`
* **Rules Collection**: `Network-Allow-t-tstsp1`
  * Purpose: `Allow TCP, UDP ICMP flows.`
  * Type: `Network`
  * Priority: `300`
  * Action: `Allow`
  * Rules:
    * `AllowHttpFromTestonpremTotstsp1`:
      * Source Type: `IP Address`
      * Source: `10.100.4.0/24`
      * Protocol: `TCP`
      * Destination Ports: `80`
      * Destination Type: `IP Address`
      * Destination: `10.100.9.4`, `10.100.9.5`
    * `AllowRdpFromBastionsubnetTotstsp1`:
      * Source Type: `IP Address`
      * Source: `10.100.3.128/26`
      * Protocol: `TCP`
      * Destination Ports: `3389`
      * Destination Type: `IP Address`
      * Destination: `10.100.9.4`, `10.100.9.5`
* **Rules Collection**: `Application-Deny-t-tstsp1`
  * Purpose: `Create specific overrides for rules in Application-Allow-t-tstsp1`
  * Type: `Application`
  * Priority: `400`
  * Action: `Deny`
  * Rules: `None`
* **Rules Collection**: `Application-Allow-t-tstsp1`
  * Purpose: `Allow outbound flows to HTTP/HTTPS/SQL Server`
  * Type: `Application`
  * Priority: `500`
  * Action: `Allow`
  * Rules: `None`

##### Monitoring

This section describes the standard configuration for the systems management of the workload.

###### Resource Monitoring

The following resources should have diagnostics settings enabled:

* **Resource Group**: `t-tstsp1-network`
  * **Network Security Group**: `t-tstsp1-network-vnet-FrontendSubnet-nsg`
  * **Network Security Group**: `t-tstsp1-network-vnet-BackendSubnet-nsg`
* **Resource Group**: `t-tstsp1`
  * **Recovery Services Vault**: `t-tstsp1x5ry47-rsv`
  * **Key Vault**: `t-tstsp1x5ry47gk-kv`
  * **Network Interface**: `t-tstsp1-web01-nic00`
  * **Network Interface**: `t-tstsp1-web02-nic00`
  * **Network Interface**: `t-tstsp1-sql01-nic00`
  * **Network Interface**: `t-tstsp1-sql02-nic00`

Diagnostics Settings should be configured as follows:

* **Diagnostics Setting**: `p-mgt-montijczky7je-ws`
  * Purpose: `Send log and performance data for resources to the central platform monitoring Log Analytics Workspace.`
  * Logs: `All Logs`
  * Metrics: `Enabled`
  * Destination Details:
    * Send To Log Analytics Workspace: `Enabled`
      * Subscription: `p-mgt`
      * Log Analytics Workspace: `p-mgt-montijczky7je-ws`

###### Action Groups

This is a test workload and should be powered down or removed. Alerting is not important.

###### Workbooks

This is a test workload and should be powered down or removed. Monitoring visualisations are not important.

###### Dashboards

This is a test workload and should be powered down or removed. Monitoring visualisations are not important.

##### Cost Management

This is a test workload and should be powered down or removed. Cost management is not important.
