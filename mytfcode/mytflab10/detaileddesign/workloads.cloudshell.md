## Azure Cloud Shell

Azure Cloud Shell is an interactive, browser-accessible shell for managing Azure resources. Cloud Shell utilizes Azure file storage to persist files across sessions. A storage account has been created in the p-mgt-shl resource group, for use by central support teams.

Users working only within their respective spokes have the ability to establish a Cloud Shell storage account in their allocated subscription.

On initial start, Cloud Shell prompts each user to associate a new or existing file share to persist files across sessions. This is a one-time action, the file share mounts automatically in subsequent sessions.

When the storage setup prompt appears, select Show advanced settings to view additional options. Each user should populate the storage options filter with the following information to configure the storage account and create a personal file share:

* Subscription: `p-mgt`
* Cloud Shell region: `West Europe`
* Resource group: `p-mgt-shl`
* Storage account: `pmgtshldata{random string}`
* File share: `name-surname`

The resource group and the storage account depend on the chosen subscription.
