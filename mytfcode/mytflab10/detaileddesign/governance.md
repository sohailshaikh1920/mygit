# Governance

The cloud introduced a new procurement model, where engineers make infrastructure purchasing decisions in real-time. The time-to-market and the added-value of a company depend on their engineering department’s ability to run experiments for R&D and digital transformation. In many scenarios gatekeepers are still the right answer for the organization to manage security and compliance in the company, and mission critical and regulated workloads such as the ones that require HIPPA compliance.

Governance is a business responsibility owned by the business and instituted across the enterprise. It involves people, processes, tools, standards and activities that are managed at both strategic and operational levels.

It is important to establish a clear and achievable vision for the cloud and its governance so to establish a unified view and reduce confusion and conflict.

* **Executives must have oversight** over the cloud: The business as a whole needs to recognize the value of the cloud-based technology and data.
* **Management must own the risks associated with its use of cloud services**: It should evaluate risk on an on-going basis, including ensuring compliance with appropriate laws, regulations, policies and frameworks.

The traditional approach for cost control has been gatekeepers - an approach which often introduces delays in the approval chain. However, to stay competitive, business demands more agility. Engineering needs full flexibility to move at its rapid pace of innovation and modernization.

The good news is that all the information for decision-making is available in near real-time. With guardrails cloud costs can be kept in check by setting limits and rules on the expenditures.

Companies leveraging cloud to accelerate their speed of innovation need to re-evaluate how they manage cost and usage. Old processes that leveraged gatekeepers are anti-pattern with why an organisation moves to the cloud. Identifying opportunities to implement near real time guardrails and automation will align cost management with the speed of innovation

Cloud introduced a new challenge for managing spend. Companies today are building large Finance Operations (FinOps) teams to address this challenge which is introducing a whole new investment requirement. Automated guardrails can help remove the manual effort, thus reducing the investment requirements in a Cloud Financial Management or FinOps team.

* Automation/Guardrails reduce the size of FinOps teams.
* Proper Cost management helps reduce cloud costs by 23%.

We begin, illustrating why Guardrails, in most cases, are the right answer for any business that requires a rapid pace of innovation to stay competitive and enable effective cost management.

## The Problem

::: Tip
Empowering engineering while keeping costs under control
:::

Do we want to empower our engineers to be able to deliver more? Or do we want a safe, more conservative approach? In traditional IT operations, this trade-off was a zero sum scenario. If you wanted more agility you would sacrifice control. Cloud introduces opportunities to make them mutually beneficial and achieve improved agility while implementing strong controls.

There are examples of cloud costs gone awry. As reported by Logical Insights and The Information:

> *"When Adobe moved their core software products to the cloud in 2013, making them only available to users via subscription, business quickly grew. But an Adobe development team unintentionally racked up $80,000 a day in charges for a computing job that wasn’t discovered for more than a week."* - Andy Jassy, CEO, Amazon Web Services

This shows how quickly costs can spin out of control without appropriately managing them

As *Andy Jassy* explained at the *Amazon Re-Invent 2019* conference, invention requires experimentation, whether the engineers need flexibility to run experiments, or in the case of lack of knowledge, while trying to develop cloud-native applications, it’s common to use inappropriate tools and solutions that lead to cost inefficiencies. For example, using instances that are far too large for the job at hand. While the applications cloud-native, cost-saving techniques can be applied to boost this transformation

> *"Invention requires two things: the ability to try a lot of experiments, and not having to live with the collateral damage of failed experiments."* - Andy Jassy, CEO, Amazon Web Services

## The Solution

> *"Through 2024, 80% of companies that are unaware of the mistakes made in their cloud adoption will overspend by 20 to 50%"* - Gartner

How can the companies provide flexibility to their employees while keeping control of their costs? In a traditional audit world, there are preventative and detective controls. In this context, the following approaches can be considered:

* *Gatekeepers*: Identify appropriate owners for each product line/department/area for engineers to get authorization from. Technically, the person creating the resources shouldn’t be the same as the one who needs it. We can set up the approvals process for new account/subscription creations, Storage, VM, RDS, Databases or other kinds of resources. Gatekeepers represent preventative controls. An action cannot happen before the gatekeeper authorizes it. This approach strictly enforces controls but will slow down agility.

* *Guardrails*: Implement policies, limits, rules, restrictions, and alerts on the cloud resources. For instance, it’s possible to implement a budget with warnings that can trigger a soft or hard lock-down. We can also define limits on the parameters for a savings instrument, such as Reservation Utilization must be over 95% while Reservation Coverage over 90%, where reservation gets you commitment-based discounted prices on your compute needs vs paying retail on-demand prices. Guardrails generally represent detective controls that allow actions to happen but monitor them for non-compliance. They will not always prevent non-compliance, but they will enable agility while quickly identifying potential control violations.

In the first case, waiting for approvals introduces a significant delay. In some cases, the needs are not clear to the engineers until the console is accessed. This coupled with the wait for approvals to unlock the previous step, results in additional delays.

Implementing a gatekeeper driven resource procurement approval workflow for cloud resources may require relatively minor changes to be made to the existing internal processes. Though, once the resource is created, additional workflows are needed, for instance, setting up “*Security Groups*”, and communicating them to engineering. Doing a fine grain control of permissions to enable all different options for all the services is overly restrictive and stifles both creativity and agility.

Moreover, every time Azure increases its service offerings, the permissions and approvals must be reviewed.

In the second case, we can complement the guardrail feedback with recommendations that enable more efficient use of deployed resources and communicate opportunities to accelerate digital modernization. For SMB companies, this could be a cumbersome task as a lot of internal processes would need to be revisited.

Let’s take a look at different use cases where cost control is necessary:

### Experimentation With New Products or Technology

This can lead to substantial and unexpected costs due to the metered billing of PaaS services and lack of visibility for the total cost of ownership of interdependent services.

For instance, unexpected data transfer costs are a common surprise that most have had to deal with due to challenges predicting/forecasting the cost.

When engineers are able to experiment, they’re often not aware of the full cost implication. Sometimes, when they are empowered to make these purchases, it ends up in waste due to over-provisioning and unconstrained usage. They are and should be focused on creating value for the company. This experimentation usually happens in development environments that offer an excellent opportunity to be more aggressive on the cost-saving measures.

> *"In many organizations, cloud adoption decisions were made by line-of-business leaders without central IT governance, creating inefficiencies and a large number of cloud vendors for "Infrastructure & Operations" to manage"* - Miguel Angel Borrega, Senior Director Analyst, Gartner.

**Recommended Guardrail:** Budget limitation per Azure Subscription

### Under-Utilization of Savings Instruments

Savings instruments allow you to make long-term commitments to receive up to a 70% discount on on-demand prices, which is typically 60% of the total cloud infrastructure costs. Not having reservations for most of your workloads is a direct and easily avoidable waste.

**Recommended Guardrail:** Saving Instruments Autopilot with pre-approved targets

### Neglecting Serverless Techniques

For instance, when you use a database only for a few hours a day, you can leverage platform offers, for example Azure Managed Instances. This will permit options, for example to switch off the database on your behalf when no traffic is detected, and it will switch it on again automatically whenever the endpoint receives the first packet. Typical initial services to be adopted for these features include Azure Functions, Logic Apps, and Containers.

**Recommended Guardrail:** Leveraging serverless techniques

Resources:

* Moving to Serverless with **Azure Container Services**
* Moving to Serverless with **Azure Functions**

### Wrong Size of Resources

This is especially true whenever a service suffers a performance problem, as the first mitigation technique is to increase resources and then fix the issue. Problems arise when proper care is not taken to decrease the size of the resources (e.g. to a smaller instance size).

Another important cause for wrong-sized legacy resources is that during the first phase of the digital transformation, most enterprises did a 1:1 migration for their classical workload in the physical and virtual servers into virtual machines, and moving forward to correct sizing of the applications was not re-evaluated.

**Recommended Guardrail:** Right-sizing agent with decentralized costs and targeted communications

### Generation of Zombie Assets

Zombie assets, such as those created after working on a prototype, or the intermediate results during migrations can be problematic. When engineers create experiments, many zombie assets will be created unless they’re following strict teardown procedures, which it’s not usually the case.

**Recommended Guardrail:** Monitoring agents and automation's

## Implementing Guardrails

Achieving long term success requires a step-by-step approach.

> *"**’Infrastructure & Operations’** leaders must shift to a strategic approach to automation. By 2025, more than 90% of enterprises will have an automation architect, up from less than 20% today"* - Gartner

Once the vision is articulated and the risk management organization is in place, the next step in the road map is to ensure visibility of what needs to be done and the risk of doing it. Here are three principles related to ensuring visibility:

* **All necessary staff must have knowledge of the cloud**: All users of the cloud should have knowledge of the cloud and its risk, understand their responsibilities and be accountable for their use of the cloud. Considering this scenario, The line-of-business owner and the IT manager work together to ensure that the involved business and technology staff have the appropriate skills to embark on the cloud initiative or that the needed expertise is obtained externally.
* **Management must know who is using the cloud**: Appropriate security controls must be in place for all uses of the cloud, including human resources practices (e.g. recruitment, transfers, terminations). Considering this scenario, the line of business owner must ensure that the necessary background checks, segregation of duties, least privilege and user access review controls are in place in the business, IT and cloud service provider. This will require working with the IT manager and the possible engagement of external assessment organizations.

Management must authorize what is put in the cloud: All cloud-based technology and data must be formally classified for confidentiality, integrity and availability and must be assessed for risk in business terms, and best practice business and technical controls must be incorporated and tested to mitigate the risk throughout the asset life cycle.

### Preparation

Define how much freedom you want your engineers to have.

Decide if you want to provide an unlimited budget or want to restrict budgets. Decide on the scope of the budget, the team, and the product-line. Think about these questions

* Are you using tags effectively?
* Are you using different Azure Subscriptions for each team?
* What is the budget amount?
* Do you want the restrictions to be daily, weekly, monthly? For a given period of time?
* How do you identify the teams or product-lines?

Do you want to limit the cloud products the team can use? For instance, it would be possible to limit cloud services to Compute or Containers, and Cache systems.

* What services do you want on Safelist / Blocklist?
* Do you want to be constrained to a certain Virtual Machine hardware and size within that family?
* Maybe, you want to enforce the usage of Spots?
* What are the target metrics for Virtual Machine Reservations?

Only when these settings are defined, it’s possible to move to the next steps.

### Savings Instruments

The easiest way to start saving is by setting up automated Saving Instruments, for example native tooling includes configuring Azure Advisor Cost Management.

These savings will allow the company to re-invest in the modernization of the applications, infrastructure, and products, so it is one of the first steps.

Reservations allows growth while minimizing the extension of the commitment and shrinking of the monthly commitment when applying the refinance operation. Also, it is possible to revamp old 3-year reservations to achieve significant savings with shorter commitments.

### Review Process

Even if we have guardrails in place, it’s important to establish a regular cadence to investigate the Cost Variance and the other findings to avoid the guardrail coverage gaps.

If a developer can launch an overly expensive resource by mistake for which there was no protection, there needs to be a process in place to mitigate the effects. Cloud vendors usually provide some service limits that might be insufficient for damage control.

A weekly meeting (or whatever periodicity fits in the organization) is often the first step to review the cost incidents and all the recommendations as elastic behaviour or changes introduced by engineers require reviews.

This process is not scalable and a better solution is to have automated delivery of these reports done directly to the engineering teams (via Slack / Microsoft teams / Jira) to gather their input. Combined with a centralized dashboard, this process can reduce reaction time to hours.

### Operate

Establish a process to provide isolated resources to developers. The Azure Subscription is the right boundary as it’s completely isolated, and it can be governed centrally.

Configure the Service Control Policies to implement Guardrails:

* **Enforce tagging**: Make Owner and/or Cost-Centre related tags mandatory.
* **Compliance Control**: Such as enforcing encryption at rest.
* **Cost Control**: Having a capped budget.
* **Resources limitation**: Capped Instance Families (for instance, a developer can’t launch an instance that cost more than €1/h).
* **Security**: for instance to prevent the creation of unrestricted security groups for public subnets.
* **Other limitations**: Developers can only launch “Spot” instances, which are up to 90% cheaper, or they can launch instances where Reserved Instances exist.

Once all of the above are configured, create internal procedures for exceptions.

## Risk Mitigation

It is important to identify and understand corporate risks when adopting the cloud.

An agile yet robust governance supports corporate and technical growth. Failure to embrace implement such a strategy can slow technical growth and potentially risking current and future market share growth.

**Future-proofing**: There is a risk of not empowering growth, but also a risk of not providing the right protections against future risks.

This business risk can be broken down tactically into several technical risks:

* Well-intended corporate policies could slow transformation efforts or break critical business processes, if not considered within a structured approval flow.
* The application of governance to deployed assets could be difficult and costly.
* Governance may not be properly applied across an application or workload, creating gaps in security.
* With many teams working in the cloud, there is a risk of inconsistency.
* Costs may not properly align to business units, teams or other budgetary management units.
* The use of multiple identities to manage various deployments could lead to security issues.
* Despite current policies, there is a risk that protected data could be mistakenly deployed to the cloud.

### Policy and Compliance

Once risks are identified they must be converted into policy statements that support any compliance requirements.

It is important to evaluate current risk tolerance and the appetite for investing in cloud governance. The tolerance indicators act as an early warning system to trigger the investment of time and energy.

### Corporate Policy Processes

Processes must be established to ensure compliance with corporate policies. If no budget has been allocated for ongoing monitoring and enforcement of these governance policies, the following could serve as a start:

* **Education**: The cloud governance team is investing time to educate the cloud adoption teams on the governance guides that support these policies.
* **Deployment reviews**: Before deploying any asset, the cloud governance team will review the governance guide with the cloud adoption teams.

### Disciplines of Cloud Governance

Many different risks can affect our consumption and use of the cloud the following topics highlight the most common challenges, with examples as we adopt the behaviours of operating on the cloud

#### Cost Management

If the scale of deployment exceeds 1,000 assets to the cloud, or monthly spending exceeds €10,000 per month, it would be wise to advance the governance strategy.

* For tracking purposes, all assets should be assigned to an application owner within one of the core business functions.
* When cost concerns arise, additional governance requirements should be established with the finance team.

#### Security Baseline

If protected data is to be included in cloud adoption, it would be wise to advance the governance strategy.

* Any asset deployed to the cloud must have an approved data classification.

  *This can be accomplished by extending the Tag Policy Definition*

* No assets identified with a protected level of data may be deployed to the cloud, until sufficient requirements for security and governance can be approved and implemented.

  Embracing Policy management techniques, for audit and compliance is recommended, for example defining Azure Policy, or deploying Azure Purview.

* Until minimum network security requirements can be validated and governed, cloud environments are seen as a demilitarized zone and should meet similar connection requirements to other data centres or internal networks.

  *The Azure Cloud Framework delivers on this foundational requirement*

#### Resource Consistency

If any mission-critical applications are to be included in cloud adoption, as part of the Migration Strategy, the associated governance and architecture requirements should be addressed early in the effort.

#### Identity Baseline

If applications with legacy or third-party multi-factor authentication requirements is to be included in cloud adoption, it would be wise to advance the governance strategy.

* All assets deployed to the cloud should be controlled using identities and roles approved by current governance policies.
* All groups in the on-premises Active Directory infrastructure that have elevated privileges should be mapped to an approved access role.

#### Deployment Acceleration

All assets should be grouped and tagged according to defined grouping and tagging strategies.

* All assets should use an approved deployment model.
* Once a governance foundation has been established for a cloud provider, any deployment tooling should be compatible with the tools defined by the governance team.
