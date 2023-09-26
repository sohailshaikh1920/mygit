
## Infrastucture State (`p-iac`)

The `p-iac` subscription hosts components related to Infrastructure-as-Code.

### Subscription Configuration

The configuration of the subscription is described below.

#### Role-Based Access Control

Access to this subscription should be restricted to those supporting and operating the contained components. There are 3 Azure AD access groups to control access to the subscription and the contained resource groups and resources.:

| Group Name                    | Role        | Description                                                                                            |
| ----------------------------- | ----------- | ------------------------------------------------------------------------------------------------------ |
| AZ RBAC sub p-iac Owner       | Owners      | Members have full permissions, including permissions. This group is ideally empty.                     |
| AZ RBAC sub p-iac Contributor | Contributor | Members have full permissions, excluding permissions. This group has as few human members as possible. |
| AZ RBAC sub p-iac Reader      | Reader      | Members are limited to read permissions only. Ideally, this is where most human members are placed.    |

#### Diagnostics Settings

The diagnostics settings of the subscription are configured to send the Activity Log data of this subscription to two destinations:

* **Long-term audit logging:** Blob storage in the `p-gov-log` resource group in the `p-gov` subscription that is configured for read only, economic, long-term storage for legal and compliance purposes.
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
* Key Vault: `Off`
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

* Terraform State File (`p-iac`)

#### Terraform State File (`p-iac`)

The purpose of this component is to securely store Terraform state files in a central, secure, shared location.

##### Overview

The IaC language, Terraform, uses a state file to identify changes (limiting the quantity and size of deployment tasks) and to enable integration between code modules. The state files will contain secrets, therefore, the state files should be stored in a shared and secured location.

An Azure Storage Account is capable of storing Terraform storage accounts in blob storage. Each Git repository (repo) that deploys Terraform code has a container in an Azure Storage Account. The container is named after the workload that is deployed & managed by the repository. A SAS token is created for the container to permit the creation and use of blobs (state files) in the container. The SAS token is stored in an Azure Key Vault, dedicated to this component, for later reference. The token is used by the deployment pipeline to authenticate against the Storage Account and to gain authorisation to use the container and any contained state files.

##### Resource Groups

The resource group, `p-iac-state`, is created in the `p-iac` subscription, which is in the management group called Management.

A lock is placed on the resource group:

* **Resource Group Lock**: `Resource_Group_Delete_Lock`
  * Lock Type: `Delete`

The resources in this resource group are:

* **Backup Vault**: `p-iac-state-bv`
  * Purpose: `Enable the backup of blobs (state files) from the storage account.`
  * Storage Redundancy: `GRS`
  * Backup Policies:
* **Key Vault**: `p-iac-<random string>-kv`
  * Purpose: `Stores SAS keys to access state file containers for each Terraform-managed workload.`
  * SKU: `Premium`
  * Soft Delete: `Enabled`
  * Purge Protection: `Enabled`
* **Storage Account**: `piacdata<random string>`
  * Purpose: `Provides blob storage to store state files for Terraform-managed workloads.`
  * Lock: `storageDoNotDelete`
    * Lock Type: `Delete`
  * Performance: `Standard`
  * Replication: `GRS`
  * Account Kind: `StorageV2`
