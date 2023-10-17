## Azure

### Azure Management Groups

Management Groups provide the highest level of scope for management in Azure.

When organizing subscriptions into containers represented by Management Groups we can apply governance conditions to them. All subscriptions scoped within a Management Group automatically inherit the conditions applied to the Management Group. Management Groups provide enterprise-grade management at a large scale no matter what type of subscriptions you might have.

For example, we can apply policies to a Management Group that limits the regions available for virtual machine creation. This policy would be applied to all Management Groups, subscriptions and resources under that Management Group, thus allowing virtual machines to be created only in that region.

Within this structure, we also assign access using defined roles that inherit to the departments under that Management Group.

Limitations:

* 10,000 Management Groups can be supported in a single directory.
* A Management Group tree can support up to six levels of depth.
* Each Management Group can only support one parent.
* Each Management Group can have multiple children.

### Azure Subscriptions

An Azure subscription is the basic unit containing all resources. It defines several limits within Azure, such as number of cores, resource limits, how resource usage is reported and billed and more.

A common model used is to leverage multiple subscriptions, one dedicated subscription for each category of an application.

Test and production workloads should not be present in the same subscription since that might expose data, functionality or technology to the wrong personnel.

Careful consideration should be applied to the architecture of services, and how to distribute them. The use of shared resource subscriptions is recommended, and will help with consistency and cost management.

The life cycle flow is recommended to follow a DevSecOps approach, moving in a left to right motion, as services are created initially in development, deployed (using code preferably) to testing, and then with a repeat deployment targeted to production. All issues in production should be logged, and fixes applied ONLY to development and test environments, which must then be released as a hot-fix to production.

The subscription is not an administrative boundary. Instead, role-based access control is used to assign administrative rights down to the resource level, with dozens of pre-defined roles.

The subscription is the billing unit. A strategy for naming and tagging of Azure resources is recommended to be adopted so to clarify billing across projects, business units or other desired views.

Each subscription has logical limits by which resources can be allocated. These limits include both hard and soft caps of various resource types (like 10,000 compute cores per subscription). The subscription strategy should account for growth as consumption increases.

### Azure Resource Groups

The resource group is the logical container within the subscription that is used to group resources. Resources that are developed together, managed together and retired together belong in the same resource group.

The resource groups can help ensure cost control and role-based access control for applications and supporting infrastructure.

### Azure Resources

Resources can have different costs based on its kind or stock keeping unit (SKU) (e.g. Basic, Standard, Premium). Azure Policy can be used to restrict specific resources from being created.

There are various ways to protect a resource and it's data. For example, some resources have the option to turn on a private network connection which only allow access from selected networks and optionally by trusted Microsoft services.

Because a policy can be applied at different scope levels, it's easy to apply different governance requirements to production and non-production or to specific services for example.

Azure tagging facilitates resource categorization according to requirements for managing and billing. The defined tag taxonomy is described in the section “Tag Policy Definition”. Mandatory tags can be enforced with the use of Azure Policy.
