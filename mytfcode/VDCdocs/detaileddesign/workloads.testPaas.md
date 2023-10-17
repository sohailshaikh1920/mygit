## Test Spoke 2 - PaaS Sample

The first test workload is Test Spoke 2, also known as t-tstsp2, deployed to the WE1 VDC instance.

### Purpose

Test Spoke 2 is a workload that is based on PaaS resources. The purposes of this test workload are:

* Verify that platform resources work correctly in the Virtual Data Centre instance.
* The workload can be used for troubleshooting.
* Provide a sample workload for the organisation that is based on non-networked platform resources.

### Functional Design

Test Spoke 2 is a very simple PaaS workload with no network connections, base on Azure App Services.

A single App Service, hosted on an App Service Plan hosts a default website. The App Service uses access restriction to prevent requests from anywhere except the address space of the Virtual Data Centre instance - this allows testing from any subnet in the Virtual Data Centre instance that has the Azure.Web service endpoint enabled.

The WAF shares the workload as `vdc-tstsp2.montelnews.com`. The WAF will reverse proxy client requests, via the hub firewall, to the two web servers over HTTP.

### Detailed Design

#### Subscription Configuration

The ADDS workload name is `t-tstsp2`. It is placed in the Management Group called `WE1 Non Production Spokes`.

##### Role-Based Access Control

Access to this subscription should be restricted to those supporting and operating the contained components. There are 3 Azure AD access groups to control access to the subscription and the contained resource groups and resources.:

| Group Name                       | Role        | Description                                                                                            |
| -------------------------------- | ----------- | ------------------------------------------------------------------------------------------------------ |
| AZ RBAC sub t-tstsp2 Owner       | Owners      | Members have full permissions, including permissions. This group is ideally empty.                     |
| AZ RBAC sub t-tstsp2 Contributor | Contributor | Members have full permissions, excluding permissions. This group has as few human members as possible. |
| AZ RBAC sub t-tstsp2 Reader      | Reader      | Members are limited to read permissions only. Ideally, this is where most human members are placed.    |

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

#### Resource Groups

There is one Resource Group in the design. The Resource Group contains the workload resources:

There is no resource group for networking because this PaaS workload does not require it.

* **Resource Group**: `t-tstsp2`
  * **Application Insights**: `t-tstsp226b4sxu7wv-insights`
    * Purpose: `Provide application monitoring`
    * Workspace: `p-mgt-apm<randomstring>-ws`
  * **App Service Plan**: `t-tstsp226b4sxu7wv-plan`
    * Purpose: `Host the App Service`
    * Size: `B1`
    * Instance Count: `1`
  * **App Service**: `t-tstsp226b4sxu7wv-web`
    * Purpose: `Provide a default web site for the test workload`
    * App Service Plan: `t-tstsp226b4sxu7wv-plan`
    * URL: `https://t-tstsp226b4sxu7wv-web.azurewebsites.net`
    * Networking:
      * Access Restrictions:
        * `https://t-tstsp226b4sxu7wv-web.azurewebsites.net`:
          * Priority: `200`
            * Name: `PublicWafSubnet`
            * Source: `p-we1waf-network-vnet/PublicWafSubnet`
            * Action: `Allow`
        * `https://t-tstsp226b4sxu7wv-web.scm.azurewebsites.net`:
          * Same restrictions as …: `Enabled`

There is no resource group for monitoring & alerting because this workload does not require it.

#### Azure Firewall Rules Collection Group

There is no Rules Collection Group because the workload is not connected to a virtual network.

#### Monitoring

This section describes the standard configuration for the systems management of the workload.

###### Action Groups

This is a test workload and should be powered down or removed. Alerting is not important.

###### Workbooks

This is a test workload and should be powered down or removed. Monitoring visualisations are not important.

###### Dashboards

This is a test workload and should be powered down or removed. Monitoring visualisations are not important.

##### Cost Management

This is a test workload and should be powered down or removed. Cost management is not important.
