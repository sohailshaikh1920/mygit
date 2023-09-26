## Azure Activities

The function **event_AzureActivitiesSink** is designed to respond to an Event Grid topic.

### How it works

When a Resource Write Success event occur for a resource that supports tagging, and the **CreatedBy** or **CreatedOn** tag is not present, this function will add the tag to the resource and to the Resource Group of the resource.

::: NOTE
When a resource is redeployed with tags, the existing tags will not be preserved.
This function will add the **CreatedBy** and **CreatedOn** tag after a redeploy, but with new values.
:::

### Event Grid topic

Each subscription can be configured to send events to this function.

The template artifacts included with Project Virtual Data Centre include the required configuration.

To configure it manually, or to verify settings, [open a subscription in the portal](https://portal.azure.com/#blade/Microsoft_Azure_Billing/SubscriptionsBlade) and select **Events**.

If configured, the Event Subscription **governance** should be present. It should be linked to a **microsoft.resources.subscriptions** system topic with a name that start with subscription name and end with **-audit-governance-egst**.

The Event Subscription **governance** should have an AzureFunction endpoint pointing to the Concierge Function App and include **Microsoft.Resources.ResourceWriteSuccess** Event Types.

When the **governance** event subscription is opened, the **Filters** should include **Advanced filters** where **Key** is **data.operationName** and **Operator** is **String does not contain** and the **Value** has the following list:

* `Microsoft.Resources/tags/write`
* `Microsoft.Resources/deployments/write`
* `Microsoft.Security/policies/write`
* `Microsoft.Authorization/locks/write`
* `Microsoft.Authorization/roleAssignments/write`
* `microsoft.insights/diagnosticSettings/write`
* `Microsoft.EventGrid/systemTopics/eventSubscriptions/write`
* `Microsoft.Web/sites/Extensions/write`
* `Microsoft.Web/sites/host/functionKeys/write`
* `Microsoft.Compute/restorePointCollections/restorePoints/write`
* `Microsoft.OperationalInsights/workspaces/linkedServices/write`
* `Microsoft.Security/workspaceSettings/write`
* `Microsoft.Security/pricings/write`
