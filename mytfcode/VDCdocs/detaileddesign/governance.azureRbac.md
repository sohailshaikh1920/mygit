## Role-Based Access Control

Within every level of scope it is possible to grant fine-grained privileges using Azure Role-Based Access Control (RBAC). The process (ideally) is:

1. A role defines permissions to a management group, subscription, resource group, or resource. The permissions are inherited from management group to subscription, to resource group, and to resource. Built-in roles may be used but Azure AD administrators can define custom roles, if needed.
1. An Azure AD group is assigned a role to a management group or subscription (or resource group or resource).
1. One or more users are assigned as members of the group, gaining the permissions assigned to the group, via the role, to the management group or subscription (or resource group or resource).

Inheritance flows top to bottom, Management Group to subscription to resource group to resource.

* Adhere to the least privilege approach.
* Always use organizational accounts not Microsoft accounts / Live IDs.
* Apply RBAC at the lowest sensible level, for example resource groups in preference to subscriptions.
* Keep an active audit on access changes.
* Delegate roles and access through the use of groups, never delegate to single users.
* Owners and Contributors at subscription level should be, at a minimum, enabled for multi-factor authentication.
* All automation related account's must be documented with information related to its owner, and its purpose, etc.
* Make use of the built-in roles as much as possible; only if none of these roles apply should you create a custom role.
* Apply segregation of duties for privileged roles; e.g. create a separate, but still private, user account that is only used when it's not possible to do with the normal user.
* Users with privileged roles should be, at a minimum, enabled for multi-factor authentication and conditional access.
* Adopt a structured naming standard for all group names regardless of originating directory source (Azure AD or on-premise AD).

### Just Enough Access

Users should have enough permissions to do their job, but not more. This will prevent accidental damage, deliberate misuse of services and data, and limit the potential damage of malware that might leverage a compromised users rights.
