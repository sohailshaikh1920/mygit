## Tags

Tagging cloud resources for segmentation lays the foundation for show-back and charge-back as well as for automations around cloud governance and waste elimination. Cloud invoices typically only support very basic groupings of costs, such as by account, project or subscription.

Tagging is the way to further separate your cloud costs and align them with your business: cost centres, business units, teams, applications and micro services. All major cloud providers support the tagging of most resources with some exceptions, such as network traffic. This solution places focus on practices around tagging your cloud resources to gain greater visibility into your costs.

### Tagging Standards

Consistency is key when it comes to tagging, so the first thing you’ll need to do is build a set of standards for your business. When designing a tagging standard, using fewer mandatory tags generally works better.

In our experience, many businesses have a multi-cloud configuration, not excluding Kubernetes which is highly dependent on Labels (tags). Each provider has their own limitations on character counts and types for a tag’s key and value properties. Implementing the same tagging standard across providers requires working each vendor’s limitations into your standard.

### Establishing a Standard

A tag is simply a key and value pair, For example, **environment**: `production`.

* Start by determining how your business looks at cost from a finance perspective
* Build a minimum set of mandatory tag keys
* Socialize your draft tagging standard with engineering leaders to collect feedback
* Be sure to manage intersections with any existing tags

::: Important
Tags are case-sensitive, so you will also need to manage the likely scenarios of engineers using incorrect character case or misspelled tags.
:::

### Convention

Tags are used to organize and categorize resources in Azure. Through their careful use we can easily identify the costs of different projects or departments in Azure.

There are many options and opinions on which tags may be appropriate for your inclusion within the governance of your ecosystem. The following list of tags have been identified as appropriate from various implementations, and should assist in identifying the valid set to adopt and implement.

It is also quite important to determine whether the tag should be considered as mandatory, and also how its value may be assigned, for example where there is a potential to automate the assignment, this should be adopted so to influence a better compliance result. Examples include:

|Element         |Description|Presented
|---|---|---|
|companyName    |Holding Company Identifier                   |Name
|environment    |Deployment Target                            |Name + Tag
|department     |Department which will manage the resource. Eg. IT|Tag
|projectId      |Project ID, eg 416002660                     |Tag
|description    |Project name of Customer Name                |Tag
|datacentre     |Hosting Datacentre                           |Name + Tag
|application    |Overall Application Identification           |Name + Tag
|service        |Service (Microservice) (Application Module)  |Name + Tag
|resource       |Resource Entity                              |Name
|instancenumber |Deployed Instance Number                     | Name
|revisionnumber |Deployed Build or Revision Number            |Tag
|dataprofile    |Data Privacy/Sensitivity which the resource will process |Tag
|criticality    |Availability requirements HR/DR |Tag|
|managedBy       |Product, Solution or Resource Owner UPN      |Tag
|primaryContact  |Primary contact for overall Service or App   |Tag
|partner         |Development Team/Partner Name/Id             |Tag
|costcentre      |Budget Owner of the resource.                |Tag
|bu              |Department which will manage the resource.   |Tag
|createdBy       |Resource creator UPN                         |Tag *Automated*
|createdTime     |Timestamp of creation                        |Tag *Automated*
|Customer Name   |Target Customer |
|neighbours      |Reference list of directly related resources |
|tier            |Resource Tier                                |Tag
|audit           |Utilized with resources which do not adhere to compliance |Tag *Automated*
|lifeCycleStage  |The stage of the life cycle this environment is currently at|Tag
|endoflife       |Date stamp resource expected end of life     |Tag
|backup          |Identify if the resource should be backed-up |Tag
|AccessControl   |Name of the RBAC Security Groups             |Tag

### Tag Policy Definition

The following tags have been defined as **required for implementation** as a foundation for governance of the cloud environment. The table identifies Tags which will be considered mandatory as well as those which can be automatically applied by the platform using various automation options.

|Element         |Description                  |Presented|Assignment|
|---|---|---|---|
|application  |Overall Application Identification|Name + Tag|Inherit from Subscription
|environment  |Deployment Target                 |Name + Tag|Inherit from Subscription
|createdBy    |Resource creator UPN              |Tag *Automated*|Automation Policy
|createdOn    |Timestamp of creation             |Tag *Automated*|Automation Policy
|IaCVersion   |Version of the infrastructure-as-code code deployment|Tag|Code
|ConfigVersion|Version of the IaC deployment|Tag|Code
|Purpose      |Intention of the item|Tag|Code

#### Environment

For consistency, the set of environments which are available for deployment should be restricted to the following approved set. If necessary, an increment number may be post-fixed to the environment if multiple instances are required.

There are 4 different environment setups in our azure naming conventions. They all have their own abbreviation.

Environment|Short Code|Long Code|Description
---|---|---|---
Development|d|dev|Development this is the playground for developing and explore new things on the Azure platform and can be removed without further notice.
Production|p|prd|This is live and is actively being used by customers. This is running on real data and exist on the azure production subscriptions.
Staging|s|stg|Staging this is a validation system that new features are evaluated in before final approval and roll-out to the production system. This is running on data as close to the reality as possible.
Testing|t|tst|Testing this is a system for trying out newly developed features that might not be fully completed. This is running on testing data.

### Tag Enforcement

There are different methods for enforcing tagging in the cloud. The strictest option is to deny workload deployment when tags do not follow the standard. This will ensure more consistent tag use but will also introduce delays and even frustration.

A more collaborative approach is to produce a tagging compliance report, in which each workload owner is assigned a compliance percentage goal. This allows leadership and engineers to build tagging compliance roadmaps into their sprint planning.

### Managing Tag Changes

Over time, your staff will experience turnover. Teams and their workloads will be split, merged or reassigned to match organisational changes. This means that your tags will change over time, too.

For example, a workload that had the tag **application** = `mobile` for the period of January through June. Now, the team will start using the tags **mobile_api** and **mobile_cache** beginning in July.

When applying budgets or forecasts, the two new tags will not have any history in their billing data. This necessitates an due diligence, or an external system to manually model tag transitions in order to provide consistency in reporting.
