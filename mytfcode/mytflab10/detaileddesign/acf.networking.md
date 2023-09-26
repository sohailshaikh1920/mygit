
## Shared Networking (`p-net`)

The `p-net` subscription hosts components that provide networking features that can be used by more than one Virtual Data Centre instance. Even if there is currently only one Virtual Data Centre instance, this may change and this architecture will allow for scalability.

### Subscription Configuration

The configuration of the subscription is described below.

Access to this subscription should be restricted to those supporting and operating the contained components. There are 3 Azure AD access groups to control access to the subscription and the contained resource groups and resources.:

| Group Name                      | Role        | Description                                                                                            |
| ------------------------------- | ----------- | ------------------------------------------------------------------------------------------------------ |
| `AZ RBAC sub p-net Owner`       | Owners      | Members have full permissions, including permissions. This group is ideally empty.                     |
| `AZ RBAC sub p-net Contributor` | Contributor | Members have full permissions, excluding permissions. This group has as few human members as possible. |
| `AZ RBAC sub p-net Reader`      | Reader      | Members are limited to read permissions only. Ideally, this is where most human members are placed.    |

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
    * Recommendation: Enabled
    * Policy: Enabled
    * Autoscale: Enabled
    * ResourceHealth: Enabled
* Destination Details:
  * Send To Log Analytics Workspace: Enabled
    * Subscription: `p-mgt`
    * Log Analytics Workspace: `p-mgt-montijczky7je-ws`
  * Archive To Storage Account: Enabled
    * Subscription: `p-gov`
    * Storage Account: `pgovlogauditxnlolmbkkxb`

#### Microsoft Defender for Cloud

Security and compliance features are provided by Microsoft Defender for Cloud. There are two tiers:

* **Free**: Basic features and configurations are possible.
* **Paid**: Special security monitoring features for resources can be enabled per-support resource type.

The configurations for this subscription are configured as follows:

##### Defender Plans

The plans are configure as follows:

* Cloud Security Posture management: Grey Out
* Servers: Off
* App Service: Off
* Databases: Off
* Storage: On
* Containers: Off
* Kubernetes: Off
* Container Registries: Off
* Key Vault: On
* Resource Manager: On
* DNS: Off

##### Auto Provisioning

The deployment of extensions is configured as follows:

* Log Analytics Agent/Azure Monitor Agent: On
  * Agent Type: Log Analytics
  * Custom Workspace: `p-mgt-montijczky7je-ws`
  * Security Events Storage: Minimal
* Vulnerability Assessment for Machines: Off
* Guest Configuration Agent: Off
* Microsoft Defender for Containers Components: Off

##### Email Notifications

Notifications are configured as follows:

* Email Recipients:
  * All Users With The Following Roles: Owner, Contributor
  * Additional Email Addresses: A distribution list to be provided
* Notification Types:
  * Notify About Alerts With The Following Severity (Or Higher): Medium

##### Integrations

The following integrations are configured:

* Enable Integrations:
  * Allow Microsoft Defender for Cloud Apps To Access My Data: True
  * Allow Microsoft Defender for Endpoint To Access My Data: True

##### Workflow Automation

No configurations are included.

##### Continuous Export

No configurations are included.

### Components

The following components are hosted in the subscription:

* Central Firewall Resources (`p-net-azfw`)
* Shared Azure Key Vault (`p-net-kv`)

#### Central Firewall Resources (`p-net-azfw`)

The purpose of this function is to store resources that can be used by more than one Azure Firewall.

##### Overview

The architecture of the Azure Cloud Framework allows for more than one Virtual Data Centre instance Each Virtual Data Centre instance has an Azure Firewall in the hub. If managed independently, each firewall will have redundant (wasted) effort that may lead to inconsistent deployment of configurations that should be standardised across all firewalls. Two kinds of resource are stored in this function:

* Parent Azure Firewall Policy
* IP Groups

##### Parent Azure Firewall Policy

Azure Firewall features and rules are managed using an Azure Firewall Policy. A policy is associated with a firewall. The policy writes through the firewall to store the features and rules configuration to highly resilient storage in the platform.

A parent-child configuration of Azure Firewall Policy can be created. A parent policy can store standard configurations for all firewall (Virtual Data Centre instance) instances:

* Firewall features
* Firewall rules

The child policy is associated with the firewall instance. The child policy inherits rules and configurations from the parent policy. When the parent policy is updated, the changes are written through the firewall to the highly resilient storage in the platform - the child policy is not actually updated by the parent policy.

Settings and rules should be configured as follows:

* Any settings or rules that should be configured for all firewalls should be configured in the parent policy.
* Anything unique to a Virtual Data Centre instance or its workloads should be configured in the child policy.

##### IP Groups

An **IP Group** is a resource type that works with **Azure Firewall** policies (not with **Network Security Groups**). An **IP Group** enables one or more IP addresses or CIDRs (IP prefixes) to be represented as a reusable resource. The name (Azure Portal) or resource ID (infrastructure-as-code) of the IP Group can be used instead of the IP address(es) or CIDR(s).

When an **IP Group** is updated, it will trigger an update to any firewall that has rules that contain the **IP Group** - the change is written directly to the firewall’s highly resilient storage in the platform.

Care must be taken with **IP Groups**. If a deployment attempts to deploy multiple **IP Groups** in parallel then the firewall will be locked with the first update to run; following updates attempting to run in parallel will fail due to the firewall being locked.

::: warning
Until there is a solution from Azure, it is recommended that use of **IP Group**s is limited, or probably, excluded.
:::

##### Resource Groups

The resource group, `p-net-azfw`, is created in the `p-net` subscription, which is in the Management Group called `GlobalNet`.

A lock is placed on the resource group:

* **Resource Group Lock**: `resourceGroupDoNotDelete`
  * Lock Type: `Delete`

The resources in this resource group are:

* [Firewall Policy] `p-net-azfw-global-firewallpolicy`
  * Purpose: `Parent Azure Firewall Policy`
  * SKU: `Premium`
  * DNS: `Enabled`
    * DNS Servers: `Default (to be customised at child firewall level)`
    * DNS Proxy: `Enabled`
  * Threat Intelligence: `Alert And Deny`
  * IDPS: `Alert And Deny`
    * Private IP Ranges:
      * `10.0.0.0/8`
      * `172.16.0.0/12`
      * `192.168.0.0/16`
      * `100.64.0.0/10`
    * Private IP Ranges (SNAT): For All IP Addresses Except Those Specified Below:
      * `10.0.0.0/8`
      * `172.16.0.0/12`
      * `192.168.0.0/16`
      * `100.64.0.0/10`
  * **Rules Collection Group**: `globalrules`
    * **Rules Collection**: `Nat-Dnat-Global`
      * Purpose: `Enable DNAT from The Internet to private IP addresses`
      * Type: `DNAT`
      * Priority: `100`
      * Action: `Allow`
      * Rules: `None`
    * **Rules Collection**: `Network-Deny-Global`
      * Purpose: `Create specific overrides for rules in Network-Allow-t-tstsp1`
      * Type: `Network`
      * Priority: `200`
      * Action: `Deny`
      * Rules: `None`
    * **Rules Collection**: `Network-Allow-Global`
      * Purpose: `Allow TCP, UDP ICMP flows.`
      * Type: `Network`
      * Priority: `300`
      * Action: `Allow`
      * Rules:
        * `AllowAzureservicetagsFromAllworkloadsToAzure`:
          * Source Type: `IP Address`
          * Source: `10.100.0.0/16`
          * Protocol: `TCP`
          * Destination Ports: `*`
          * Destination Type: `Service Tag`
          * Destination:
            * `AzureActiveDirectory`
            * `AzureMonitor`
            * `AzurePlatformDNS`
            * `ActionGroup`
            * `AzureBackup`
        * `AllowKmsFromAllworkloadsToAzure`:
          * Source Type: `IP Address`
          * Source: `10.100.0.0/16`
          * Protocol: `TCP`
          * Destination Ports: `1688`
          * Destination Type: `FQDN`
          * Destination: `kms.core.windows.net`
    * **Rules Collection**: `Application-Deny-Global`
      * Purpose: `Create specific overrides for rules in Application-Allow-Global`
      * Type: `Application`
      * Priority: `400`
      * Action: Deny
      * Rules: `None`
    * **Rules Collection**: `Application-Allow-Global`
      * Purpose: `Allow outbound flows to HTTP/HTTPS/SQL Server`
      * Type: `Application`
      * Priority: `500`
      * Action: `Allow`
      * Rules:
        * `AllowEventsFromAllworkloadsToMicrosoft`:
          * Source Type: `IP Address`
          * Source: `10.100.0.0/16`
          * Protocol: `Https:443`
          * TLS Inspection: `Disabled`
          * Destination Type: `FQDN`
          * Destination: `*.events.data.microsoft.com`
        * `AllowNuGetFromAllworkloadsToMicrosoft`:
          * Source Type: `IP Address`
          * Source: `10.100.0.0/16`
          * Protocol: `Https:443`
          * TLS Inspection: `Disabled`
          * Destination Type: `FQDN`
          * Destination: `onegetcdn.azureedge.net`        * `AllowWindwosupdateoptimisationFromAllworkloadsToMicrosoft`:
          * Source Type: `IP Address`
          * Source: `10.100.0.0/16`
          * Protocol: `Https:443`
          * TLS Inspection: `Disabled`
          * Destination Type: `FQDN`
          * Destination: `geo-prod.do.dsp.mp.microsoft.com`
        * `AllowManagementFromAzurevipToEverywhere`:
          * Source Type: `IP Address`
          * Source: `168.63.129.16`
          * Protocol: `Https:443`
          * TLS Inspection: `Disabled`
          * Destination Type: `FQDN`
          * Destination: `*`
        * `AllowBlobstorageforloganalyticsFromAllworkloadsToAzure`:
          * Source Type: `IP Address`
          * Source: `10.100.0.0/16`
          * Protocol: `Https:443`
          * TLS Inspection: `Disabled`
          * Destination Type: `FQDN`
          * Destination: `scadvisorcontent.blob.core.windows.net,opinsightsweuomssa.blob.core.windows.net`
        * `AllowServiceBusFromAllworkloadsToAzure`:
          * Source Type: `IP Address`
          * Source: `10.100.0.0/16`
          * Protocol: `Https:443`
          * TLS Inspection: `Disabled`
          * Destination Type: `FQDN`
          * Destination: `*.servicebus.windows.net`
        * `AllowGuestConfigurationFromAllworkloadsToAzure`:
          * Source Type: `IP Address`
          * Source: `10.100.0.0/16`
          * Protocol: `Https:443`
          * TLS Inspection: `Disabled`
          * Destination Type: `FQDN`
          * Destination: `agentserviceapi.guestconfiguration.azure.com,norwayeast-gas.guestconfiguration.azure.com`
        * `AllowOdsFromAllworkloadsToAzure`:
          * Source Type: `IP Address`
          * Source: `10.100.0.0/16`
          * Protocol: `Https:443`
          * TLS Inspection: `Disabled`
          * Destination Type: `FQDN`
          * Destination: `*.ods.opinsights.azure.com`
        * `AllowOmsFromAllworkloadsToAzure`:
          * Source Type: `IP Address`
          * Source: `10.100.0.0/16`
          * Protocol: `Https:443`
          * TLS Inspection: `Disabled`
          * Destination Type: `FQDN`
          * Destination: `*.oms.opinsights.azure.com`
        * `AllowAutomationFromAllworkloadsToAzure`:
          * Source Type: `IP Address`
          * Source: `10.100.0.0/16`
          * Protocol: `Https:443`
          * TLS Inspection: `Disabled`
          * Destination Type: `FQDN`
          * Destination: `*.azure-automation.net`
        * `AllowFqdnTags`:
          * Source Type: `IP Address`
          * Source: `10.100.0.0/16`
          * Protocol: `Https:443`
          * TLS Inspection: `Disabled`
          * Destination Type: `FQDN`
          * Destination:
            * `AppServiceEnvironment`
            * `AzureBackup`
            * `AzureKubernetesService`
            * `HDInsight`
            * `MicrosoftActiveProtectionService`
            * `WindowsDiagnostics`
            * `WindowsUpdate`
            * `WindowsVirtualDesktop`
        * `AllowDefenderFromAllworkloadsToMicrosoft`:
          * Source Type: `IP Address`
          * Source: `10.100.0.0/16`
          * Protocol: `Https:443`
          * TLS Inspection: `Disabled`
          * Destination Type: `FQDN`
          * Destination: `winatp-gw-weu3.microsoft.com,*.cp.wd.microsoft.com`

> No IP Groups are deployed by default.

#### Shared Azure Key Vault (`p-net-kv`)

This component provides a place to share certificates and secrets that will be used in more than one place across the network.

##### Overview

Some secrets are used many times across the network, such as a wildcard certificate. Such secrets could be uploaded and stored in many places but operations, such as renewal, could become unnecessarily complicated.

This component provides an Azure Key Vault that can store secrets that are used many times.

##### Resource Groups

The resource group, `p-net-kv`, is created in the `p-net` subscription, which is in the Management Group called `GlobalNet`.

A lock is placed on the resource group:

* **Resource Group Lock**: `resourceGroupDoNotDelete`
  * Lock Type: `Delete`

The resources in this resource group are:

* **Key Vault**: `p-net-<random string>-kv`
  * Purpose: `Stores secrets that are used across the network.`
  * Lock: `keyvaultDoNotDelete`
    * Lock Type: `Delete`
  * SKU: `Premium`
  * Soft Delete: `Enabled`
  * Purge Protection: `Disabled`
  * Secrets:
    * VPNSitesSharedKey: `Pre-shared key for the VPN`

#### Azure Virtual WAN (`p-net-wan`)

This component provides Azure Virtual WAN for those organisations that are implementing software-defined WAN (SD-WAN) using Azure Virtual WAN.

##### Overview

Azure Virtual WAN is a routing solution for Azure networking. Primarily it is a solution to implement SD-WAN using platform resources.

The overall architecture is a hub & spoke architecture. The hub (a network core) is a transit network that provides connectivity to external locations connectivity:

* Site-to-site networking through site-to-site VPN and ExpressRoute (known as branches in Azure Virtual WAN).
* Devices through point-to-site VPN (also known as branches).
* The Internet through Azure Firewall.

Workloads are deployed into spokes (workload networks) - the hub contains networking features for the transit network only.

A benefit of this approach is a routing solution that is based on a central configuration of route tables in the hub that are associated with spokes (workload networks) to attract traffic through the hub. Spoke traffic is forced through the Azure Firewall by these routes:

* Branch to Azure
* Azure to branch
* Workload to Internet
* Internet (DNAT) to Workload
* Workload to Workload

A custom route is created for the `p-no1bst` (shared Azure Bastion) workload. Azure Bastion requires that is has a direct route to Internet. The custom Route Table forces only flows to the same Virtual Data Centre instance to flow via the hub firewall. All other flows retain their default path - traffic to **0.0.0.0** from **AzureBastionSubnet** will flow directly to Internet - as is required by Azure Bastion.

##### Resource Groups

The resource group, `p-net-kv`, is created in the `p-net` subscription, which is in the Management Group called `GlobalNet`.

A lock is placed on the resource group:

* **Resource Group Lock**: `resourceGroupDoNotDelete`
  * Lock Type: `Delete`

It may be necessary to remove the above lock if a third-party SD-WAN solution is integrating with Azure Virtual WAN and excepts to be able to add and remove resources.

There is one hub per Virtual Data Centre instance. The name of the Virtual Data Centre instance is used to name the hub. The hub will have an Azure Firewall resource. The name of the Virtual Data Centre instance is used as a part of the firewall resource name. Each Virtual Data Centre instance is assigned a /16 address space.

The resources in this resource group are:

* **Virtual WAN**: `p-net-wan-vwan`
  * Purpose: `A routing domain containing one or more hubs (one per Virtual Data Centre instance)`
  * Branch-to-Branch: `Enabled`
  * Hubs:
    * Name: `p-net-wan-vwan-no1-hub`
      * Location: `Norway East`
      * Private Address Space: `10.75.0.0/22`
      * Route Tables:
        * Name: Default:
          * Routes:
            * Route Name: `all_traffic`
            * Destination Type: `CIDR`
            * Destination Prefix: `0.0.0.0/0,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16`
            * Next Hop: `p-net-wan-vwan-no1-fw`
          * Associate This Route Table Across All Connections: `Yes`
          * Choose Virtual Networks (Associations): All workload spokes selected except `p-no1bst-network-vnet`
          * Propagate routes from connections to this route table: `No`
          * Propagate routes from all branch connections to these labels across virtual WAN: `0 selected`
          * Choose Virtual Networks (Propagations): `0 selected`
        * Name: `None`
          * Routes: `None`
          * Associate This Route Table Across All Connections: `No`
          * Choose Virtual Networks (Associations): `0 selected`
          * Propagate routes from connections to this route table: `Yes`
          * Propagate routes from all branch connections to these labels across virtual WAN: `0 selected`
          * Choose Virtual Networks (Propagations): `All workload spokes selected`
        * Name: `p-no1bst`:
          * Routes: `None`
            * Route Name: `NO1`
            * Destination Type: `CIDR`
            * Destination Prefix: `10.75.0.0/16`
            * Next Hop: `p-net-wan-vwan-no1-fw`
          * Associate This Route Table Across All Connections: `Greyed Out`
          * Choose Virtual Networks (Associations): `p-no1bst-network-vnet`
          * Propagate routes from connections to this route table: `No`
          * Propagate routes from all branch connections to these labels across virtual WAN: `0 selected`
          * Choose Virtual Networks (Propagations): `0 selected`
* **Azure Firewall**: `p-net-wan-vwan-<Virtual Data Centre instance name>-fw`
  * Purpose: A firewall for each hub (one per Virtual Data Centre instance)
  * Firewall SKU: Premium
  * Firewall Policy: `p-<Virtual Data Centre instance name>net-network-fw-firewallpolicy` (from the Virtual Data Centre instance hub subscription)
* **Storage Account**: `pnetwanvwandiag<random string>`
  * Purpose: Provides blob storage for Azure Firewall and Gateway logs
  * Performance: Standard
  * Replication: ZRS
  * Account Kind: StorageV2
* **VPN Gateway**:
  * Purpose: `Enable site-to-site VPN connections`
  * Associated Route Table: `Default`
  * Propagated Route Table: `None`
  * Static Routes: `None`
  * VPN Link Connections:
    * Name: `advania-primary`
      * Purpose: `Connect the VPN Gateway to the Advania VPN site link`
      * VPN Site Link: `advania-primary-link`
      * Connection Bandwidth: `10`
      * ipsecPolicies: `None`
      * VPN Connection Protocol Type: `IKEv2`
      * Shared Key: *Value stored in Keyvault* ***p-net-kv26fzcyeu-kv*** *as* ***VPNSitesSharedKey***
      * Enable BGP: `False`
      * Enable Rate Limiting: `False`
      * Use Local Azure IP Address: `False`
      * Use Policy Based Traffic Selectors: `False`
      * Routing Weight: `0`
      * VPN Link Connection Mode: `Default`
* **VPN Site**: p-net-wan-vwan-advania-vpnsite
  * Purpose: Provide a location definition for the Advania facility. Enables ADDS replication. Can be removed after Advania is decommissioned.
  * Device Vendor: Azure
  * Private Address Space:
    * 192.168.18.0/24
    * 192.168.191.0/24
    * 192.168.20.0/24
  * Links:
    * advania-primary-link
  * VPN Site Links: advania-primary-link
    * Purpose: Document the public presence of the VPN site.
    * Link Provider Name: Azure
    * Link Speed: 100
    * Link IP Address/FQDN: 185.120.101.30

Other sub-resources will be added depending on the design of workloads and branch connectivity.
