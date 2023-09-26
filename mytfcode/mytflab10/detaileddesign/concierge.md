# Concierge

Innofactor Concierge is a function app used for automation and event handling in Azure.

In order to perform it's tasks in the tenant, the function app must have the Contributor role of the subscriptions that it will serve. It will need this in order to tag resources that are created and to start and stop virtual machines plus other tasks.

When a resource is tagged with who created the resource, Concierge will sometimes not find the name of who created the resource in the Event data, but instead only the object id. To find the name, Concierge must therefore be added to the 'Directory Reader' role in Azure Active Directory
