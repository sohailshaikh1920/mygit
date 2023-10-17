## Azure Policy

Business and legal requirements, recommended configurations and architecture concepts can be audited, restricted and enforced using Azure Policy.

Once defined, policies can be assigned to a scope, such as a Management Group or a subscription.

To reduce number of assignments, policy definitions can be grouped into policy initiatives. Most policies and initiatives have parameters to specialize the configuration.

If the assignment is scoped to a Management Group, then the policies contained within that assignment are effective to:

* The Management Group.
* Child Management Groups.
* All subscriptions under the Management Group.
* All resource groups and resources under the Management Group.

If the assignment is scoped to a subscription then the policies contained within that assignment are effective only to that subscription..

The policies below do not cover all aspects of auditing and policy enforcements that may be needed. They are intended as a starting point.

Some policies may prevent necessary implementations for some business or technical requirements. One such example is the use of Public IP Addresses. It is the desire of the Azure Cloud Framework to restrict the use of Public IP Addresses to the hub in an Virtual Data Centre instance.

However, resources outside of the hub may require a Public IP Address:

* An Azure Application Gateway
* API Management with virtual network integration
* Azure Bastion

In these cases, an exception may be implemented in the assignment to allow the denied configuration. The scope of the override might be:

* The subscription.
* The resource group.
* The resource ID of the denied resource - this is preferred to avoid the override from being misused with other deployments.

Policies must be reviewed and customized on a regular basis.
