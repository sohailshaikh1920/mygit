## Cost Control

Azure Cost Management is the primary tool for cost management. The approach of 1 workload per subscription for production workloads provides a natural boundary for cost management:

* Costs can easily be determined by filtering to the subscription (workload).
* Budgets and budget alerts can be set per subscription (workload).

::: Warning
If test and development workloads should reside in a single subscription there will be no natural boundary to identify individual workloads and a form of tagging will be required.

It is recommended that test and development environments have dedicated subscriptions, following the naming schema where the subscription uses a prefix to denote the environment type.
:::

### Cost Management

Your FinOps practice will likely have different maturity levels for different functional areas. For example, tagging may be in the Operate phase while forecasting is in the Inform phase. Over time, all areas will mature, but not all need to graduate to the Operate phase.

For example, an annual process with low impact on the business may stay in the Inform phase indefinitely, and that’s fine. Further optimization of this type of process would consume resources that can be better prioritized elsewhere.

#### Inform Phase

* Tagging will be done at a higher level (for example, VP, business unit or cost centre)
* Cost allocation will be performed by simply apportioning the cloud bill by account, project or subscription
* Shared costs will be apportioned without further detail until costs become more substantial
* Cloud native tools and spreadsheets are predominantly used

#### Optimize Phase

* Tagging will have a well-defined strategy that reaches the application or service level
* Cost allocation will use metadata to identify engineering leads responsible for specific workloads
* Shared costs will use well-established mechanisms like shared pools to apportion costs fairly to business owners
* A combination of native and third party tools will be used to accomplish various tasks
* Key performance indicators (KPIs) for cost allocation are being introduced, but may not be automated yet

#### Operate Phase

* Tagging will be as granular as the business requires and utilize automation for deployment, governance and management of changes over time
* Cost allocation will be automated and able to manage shared costs as well as untaggable and untagged resources
* There will be few gaps of costs that are unidentified and little to no manual tracking is required
* A combination of native, third party and in-house tools is used to accomplish all required business activities
* KPIs are automated and regularly reviewed

#### Measuring Success Using KPIs

KPIs help you drive business goals, and they allow you to identify trends over time. Using historical KPI trends, thresholds can be set to identify outliers.

Commonly leverage KPI's for Tagging and Cost Managmement

* Percentage of taggable resources with tags
* Percentage of tags complying with tagging standard
* Percentage of total cloud spend that is allocated
* Percentage of shared cost that is allocated
* Percentage of untaggable and untagged cost that is allocated

A typical target for the Inform phase is 80%, while the Operate phase will target above 90%. More mature practices will also utilize automation to notify workload owners when non-compliant deployments are made.

### Budgets

Cloud costs need to be allocated to their responsible owners by mapping tags to employees. But since people leave, new people join and existing staff are reassigned, we should avoid assigning owner tags directly to cloud workloads.

This is because changing a cloud tag is a relatively heavy lift. The tag information may be stored in the source code, which then must go through a merge and approval process, after which the workload needs to be redeployed - all without impacting your customers. Ideally, we map cloud tags to business owners in a database where those owners can be quickly reassigned without requiring this process.

For show-back and charge-back, it’s important to show cloud cost at a high level, such as VP, business unit or cost centre. But it’s also useful to be able to drill down to an individual team lead or engineer for troubleshooting, such as when determining the root cause of a budget overrun.

Once a budget is determined for a workload, a budget can be configured for an Azure subscription (workload). Threshold alerts may be configured:

* **Forecasted**: Triggered when Azure estimates that a subscriptions cost at the end of the billing period will exceed the budget.
* **Actual**: Triggered when the cost of a subscription exceeds the budget.

In addition, anomaly alerting will indicate when there is an unusual change in spending patterns in an established subscription (workload).

### Managing Shared Costs

Once a tag combination has been classified as a shared cost, there is nothing preventing engineers from using this tag combination for other workloads. This can result in scope creep of shared costs and requires regular reviews to determine if the workloads are tagged correctly.

Some common types of shared costs include:

* Shared resources, such as network or shared storage
* Platform services, such as Kubernetes or logging infrastructure
* Enterprise level support
* Enterprise level discounts
* Licensing, such as third-party Software as a Service (SaaS) costs

Commonly used shared costs models include:

* **Proportional**: Based on the relative percentage of direct costs of cloud workloads
* **Even split**: Total shared cost is evenly split across cloud workloads
* **Fixed**: A business-defined percentage, which adds up to 100%

### Managing Untaggable and Untagged Resources

Even if we were able to fully tag all cloud resources, which is not possible due to the velocity of innovation, some cloud services, such as those related to data transfer, do not support tagging. Untaggable and untagged resources need to be allocated using the same principles outlined above, in Managing Shared Costs.
