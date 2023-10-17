# Architecture Overview

This section of the document is the functional or high-level design, providing an overview of how the solution will function.

The complete solution (Azure Cloud Framework and Virtual Data Centre instances) is an environment for hosting infrastructure, platform and data services in a secure, managed, and governed way.

The Azure Cloud Framework implements the principles and logic of traditional data centres in a cloud environment. It enables high-level data security, compliance, and governance without compromising on user agility. The concept leverages infrastructure as code methods and a modern Azure governance model.

## Inspired by Physical Data Centres

A physical data centre is a physical building that hosts network, compute, and storage services:

* A physical building or room contains the resources.
* All networking into and out of the data centre passes through a network core.
* The network core contains centralized public IP addresses, a firewall or highly available firewall cluster, router(s), and core switches.

The network core is a mission critical environment because it is the entry and exit point for the data centre and provides internal connectivity; it must be:

* Highly managed.
* Have restricted access.
* Be highly available.

Services and data are deployed into virtual networks in the data centre. These virtual networks, VLANs or software-defined virtual networks, are connected to the core switches of the network core, meaning that:

* All connectivity between the virtual networks must pass through the network core. Ideally, a firewall isolates the virtual networks. However, it is all-too common to find that there is no security segmentation of the data centre network, enabling an attack to spread with no resistance.
* All traffic into services hosted in the data centre must pass through the network core; here, network security specialists are able to log and control the ingress of traffic to ensure that only valid and approved traffic may reach the assets of the organization.
* All traffic leaving the data centre must pass through the network core. Once again, network security specialists are able to log, inspect and block flows leaving the data centre, potentially with sensitive data.

A mature data centre is typically a tightly run facility, controlled by an operations manager and a data centre manual:

* **Role-based access control (RBAC)**: Who can do what?
* **Physical security**: Who can enter and leave the facility and how?
* **Network security**: What is allowed in and out and how is it logged and inspected?
* **Cost management**: How are the services of the data centre paid for?

The above points are essential elements of governance, the processes of controlling how resources are deployed, kept secure, used, and paid for.

## Architected for Cloud

The Virtual Data Centre instance is an implementation of the legacy data centre concept using cloud-first technologies. The primary objectives are to provide a location to host services and data that is:

* Secure by default.
* Governed from day one.

All cloud resources have some form of networking. However, platform resources typically use public endpoints, by default, that are not connected to a customer-managed virtual network. Where a workload (a combination of resources) requires network connections, either for technical/security/compliance reasons, the resources shall be network connected where possible.

The patterns of network core and virtual networks are reused, but with different terminology:

* **Hub (network core):** An implementation of an Azure virtual network that provides shared network services and/or external connectivity.
* **Workload (virtual network):** A place to connect services and/or data that require a network connection. If the services use network connectivity, then the virtual network of the workload is connected to the hub, using virtual network peering.

As with the physical data centre, the hub is the only part of the Virtual Data Centre instance that has external connectivity and public IP addresses. (some required exceptions will exist). All communications into and out of the instance must pass through a hub. Furthermore, each workload is connected only to the hub of the instance. This means that the workload is isolated from all other workloads; firewall functionality in the hub must allow communications for it to successfully happen:

* From a workload to the Internet.
* From The Internet to a workload.
* From outside the Virtual Data Centre instance, including Azure, on-premises, other Virtual Data Centre instances, or The Internet, to a workload.
* From a workload to outside the Virtual Data Centre instance, including Azure, on-premises, other data centres, or The Internet.

::: Note
Exceptions sometimes (typically often) are made in the case of Azure platform services that require direct connectivity to the control plane of Azure.
:::

Not all workloads will be connected to a network. The placement of such workloads in a Virtual Data Centre instance will still be relevant; the Virtual Data Centre instance is a border for governance, security, and management that is aligned to a regional deployment. Governance, security, and management are relevant to all workloads, whether they are connected to a network or not.

By default, the firewalls of the hub block all traffic. Exceptions are made to allow traffic to flow. The implementation can include a number of pre-defined exceptions to:

* Allow required functionality, such as monitoring of virtual machines, guest operating system activation, DNS queries, Active Directory Domain Services replication, and so on.
* Pre-seed the environment with rules for complex Azure platform resources that can be associated with any deployments of those services.

Azure Management Groups provide a basis for:

* Subscription organization based on the administrative model of the organization.
* Policy association and inheritance.
* Role-based access control.

Management functionality provides a basis for:

* Performance monitoring.
* Diagnostics logging.
* Auditing.
* Security recommendations and monitoring.
* Security information and event management (SIEM)

## Concepts

The following are core concepts of the design:

* **Organisation:** An organisation will have single governance, management, and security plane, called the Azure Cloud Framework, for centralized control of all deployed services. The organisation may have one or more Virtual Data Centre instances.
* **Region:** A Virtual Data Centre instance, like a physical data centre, is associated with a physical location. All resources of a Virtual Data Centre instance, except for Azure global resources such as Traffic Manager, are deployed in a single region. For example:
  *  An Virtual Data Centre instance is deployed into West Europe, then everything in that Virtual Data Centre instance is deployed into West Europe.
  *  If an Virtual Data Centre instance reaches the maximum number of possible network-connected workloads (495 based on /25 IPv4 workloads) then an additional Virtual Data Centre instance can be deployed in the same region.
  *  An organisation requires additional locations, either for distributed placement of resources or for disaster recovery, then additional Virtual Data Centre instances can be deployed.
* **Enable Controlled DevSecOps:** The Innofactor Azure Cloud Framework enables self-service with the guardrails of governance and security. The people that know security continue to implement security in the hub. Governance controls what is deployed. However, developers and operators are free to work within the loose constraints provided by the organisation.
* **Isolation By Default:** An individual Virtual Data Centre instance does not trust anything outside of its boundary. It does not trust The Internet, other Virtual Data Centre instances owned by the organisation, or even the organisation's on-premises networks. The Virtual Data Centre instance design isolates neighbouring workloads inside the same Virtual Data Centre instance. The goal is to prevent the spread of any attack or malware and to limit access by authorized staff at the network layer. Likewise, a workload does not trust anything outside of its own boundaries. And tiers within a workload should not trust other tiers in the same workload.
* **Connections:** The only public IP addresses allowed in the network of a Virtual Data Centre instance are typically constrained to the hub unless there is a specific requirement for a resource type by Microsoft Azure. This means that all data flow will pass through the hub - with some Microsoft-documented exceptions for the control plane of Azure platform services.
  * All flows between networked workloads of the same Virtual Data Centre instance will pass through its hub.
  * No workload should peer with another workload.
  * Two Virtual Data Centre instances owned by the same organisation can be connected only via their hubs; ExpressRoute, VNet peering at the Network Hub, or Azure WAN any-to-any connectivity.
* **Resilience:** The Virtual Data Centre instance design does not rely on anything outside of its boundary.
  * Any authentication/authorization services are required, those services are deployed and consumed from inside of the Virtual Data Centre instance.
  * Any administrative operations requiring a remote desktop connection into a Virtual Data Centre instance, will be provided by components hosted within the instance boundary, not by services from another Virtual Data Centre instance.
  * The architecture goal is that the Virtual Data Centre instance will continue to operate despite failures that may happen in on-premises networks, other Virtual Data Centre instances, or other Azure regions.
* **High Availability:** The services of a Virtual Data Centre instance are mission-critical. For example, a virtual network gateway provides a secure connection between on-premises networks and the Virtual Data Centre instance.
  * A firewall provides connectivity to workload services.
  * A web application firewall provides secure sharing of HTTP/S applications.
  * Domain controllers provide DNS and authentication/authorization services to the network.
  * Each of these components is deployed in a way to maximize the service level agreement (SLA) and the actual availability of the services. For example:
    * If a Virtual Data Centre instance's Azure region supports Availability Zones, the zone redundancy is implemented with network resources and virtual machines deployed across different zones.
    * If a Virtual Data Centre instance's Azure region does not support Availability Zones, then virtual machines are deployed with Availability Sets.
* **Subscriptions:** Each service will be deployed into its own subscription. For example, if a new n-tier application with web, application, and database is being deployed, this service will be deployed into a single subscription. This approach simplifies support, cost-management, and role-based access control.
* **Edge Data Centre (EDC)**: Sometimes, there will be a need to deploy a specific service outside of a Virtual Data Centre instance. For example, a Virtual Data Centre instance is placed in a small Azure region that does not support some required resource types or the nature of the service contradicts the design concepts of a Virtual Data Centre instance. In this case, the management and governance design provides the concept of an Edge Data Centre (EDC), a service deployment that sits outside of a Virtual Data Centre instance but still under the same oversight and control.
* **PaaS and IaaS:** A Virtual Data Centre instance is not just for virtual machines. Admittedly, a lot of the conversation will be about networking, but most of the architecture of a Virtual Data Centre instance is designed to provide governance, security, and management for any kind of deployment in Microsoft Azure. A service does not need to be connected to a network to be a part of the governance and security architecture.

## Network Design

The following guidance is used in the design:

* Security is critical. Micro-segmentation is used to
  * Distrust the outside world (including on-premises networks)
  * Disconnect the outside world by default
  * Isolate workloads by default
  * Isolate resources within a workload by default.
* Central management of network security should be implemented by network security professionals, but there should be a balancing act to enable agile operations.
* Connectivity options should be flexible.
* *Infrastructure as Code* is used to deploy to Azure.
* Azure routing and firewall rules introduce the following terms:
  * **Virtual network:** Not referring to a virtual network resource; instead refers to all connected networks, including on-premises networks, peered virtual networks, and networks with routes in the subnets.
  * **Internet:** it refers to all network addresses outside of virtual network.

## Platform Services (PaaS) and Networking

It is important to emphasise that a virtual network design is not just for Virtual Machine (IaaS) workloads.

The virtual network will provide a security option for PaaS resources:

* Network integration for high-end SKUs of services, including **App Service Environment (ASE), Azure Kubernetes services, Redis Cache, API management,** etc.
* **Private endpoint**, through **Private Link** will allow many PaaS resources to be securely connected to subnets.
* **Service endpoint** may be used for a small subset of PaaS resource types.
* Even PaaS resources that are not VNet connected will require secured and accelerated Internet connectivity, which is made possible by networking features of Azure.

## Hub and spoke architecture

The network of a Virtual Data Centre instance is implemented as a *Hub and Spoke* architecture, somewhat mimicking the pattern of a physical data centre network.

* A hub plays the role of a network core.
* Networked workloads will be deployed as spokes

The following flows are enforced

* All external connectivity should be through the hub. The hub will contain connectivity, routing resources, and firewall resources only.
* Ideally, all public IP addresses will only be in the hub. An Azure Policy will prevent unwanted public IP addresses in the spokes. Some Azure resources require public IP addresses, which will not be deployed in the hub. These resources will require approved exceptions in Azure Policy.
* The hub will contain a firewall, playing the role of security device and router between the spokes and the outside world (including on-premises).
* All networked workloads will be placed in a spoke. A spoke is a workload deployment with an **Azure Virtual Network (vNet)**
  * The Azure Virtual Network is dedicated to the workload and peered with the hub.
  * Routing in the Virtual Network subnets will force traffic that is leaving the VNet to route via the hub firewall.
  * Some platform resources require route overrides for their control plane, bypassing the firewall to route directly to Internet.
* Resiliency will be a part of the hub and spoke architecture. This may imply
  * The design should offer high availability.
  * There should be elements of isolation and protection against threats in the design.

## DDoS Protection

All Azure virtual networks have the basic tier of **Distributed Denial of Service (DDoS)** attack protection. A standard tier with better protection and support is available and can extend DDoS protection into the Layer-7 protection of the **Web Application Firewall**.

::: Warning
By default, the standard tier is not enabled in the networks of a Virtual Data Centre because of the high cost of this security feature.
:::

An organization might choose to enable the standard tier, which takes approximately two weeks to learn normal patterns of behaviour before it becomes effective.

::: tip
If an organization decides to enable the standard tier, the virtual networks of the network hub and application hub are normally the ones which should be enabled. Due to the fact that these should be the only virtual networks that will be exposed to the public.
:::

## Multiple Virtual Data Centre instances

An organization might require to have more than one Virtual Data Centre instance

* **Scale-out:** Either the hub networks are reaching their limit of peered virtual networks (500 each) or the /16 IPv4 address block is close to being exhausted (495 x /25 spokes).
* **Location:** Workloads might need to be deployed closer to the end-users/customers.

The Azure Cloud Framework was designed to support multiple Virtual Data Centre instances, which maybe deployed:

* In one Azure region.
* In many regions.

Some of the features that enable this scale-out include:

* **Naming standard:** A Virtual Data Centre instance is named after the region it is deployed in plus a counter. For example, an organization might have three Virtual Data Centre instance in Azure West Europe called WE1, WE2, and WE3. Additional deployments might include KC1 (Korea Central 1), or NO1 (Norway East 1).
* **Governance:** The Management Group hierarchy allows for one Management Group per Virtual Data Centre instance in **Virtual Data Centre Root > Virtual Data Centre instance**. For example
  
  ```mermaid
  graph TD
    A[Root] --> B(Instance)
    B --> C[WE1]
    B --> E[NO1]
  ```
  
  Each Management Group will contain the child Management Groups and subscriptions deployed to the instance.
* **Networking:** The use of the Azure Global WAN greatly simplifies this design.

## Workloads

Workloads are deployed into the Virtual Data Centre instance in a dedicated subscription. A workload is a collection of Azure resources, combined with its configuration and data, to provide some unified functionality to the business. For example, an e-commerce platform might be made up of **Virtual Machines, Azure Application Sservices, Storage Accounts, Azure SQL**, and **Azure Key Vault**; together these resource provide a service.

Following this pattern, a single subscription is utilized for each workload.

To Illustrate this point, assume we have a workload called *Gemini*, which will be published to three envionments, Development, Testing and Production. The following subscriptions would be scaffolded to host the workloads:

* **p-gemini**: Production environment
* **d-gemini**: Development environment
* **t-gemini**: Test environment

This approach of using the subscription as a boundary solves issues that otherwise require manual/automated systems to manage:

* **Role-based access control:** Each subscription is a natural boundary for RBAC.
* **Cost management:** Each subscription generates its own invoice. If a workload is owned by a specific business team, then all costs for are appropriately allocated.
* **Support complexity:** When a support engineer filters their view in the Azure subscription to a single subscription, all resources that they observe will be dedicated to the workload hosted in that subscription, thus simplifying the overall architecture of Azure.
* **Isolation:** Core concepts of a Virtual Data Centre instance include resilience and isolation. Separating workloads into dedicated subscriptions enables natural boundaries,increases security, governance, manageability, and resilience.
* **Quota:** Each subscription has a dedicated quota, limited the quantity of a resource type/size that is permitted in an Azure region. Extremely large workloads will benefit from having a dedicated quota.

::: Note
Many Azure features are deployed on a per-subscription basis, such as Azure Recommendations or Service Health. Normally the alerts for these features must be configured on a per-subscription basis. The use of centralised logging combined with alerting means that the Azure Cloud Framework is pre-configured to create alerts for these Azure features in a central place, allowing scalability for many subscriptions.
:::

### Azure Firewall Policy

Azure Firewall provides a management service called **Azure Firewall Manager**, which is a user interface in the *Azure Portal* that is used to manage one or more firewalls. Under the covers, Azure Firewall Manager implements its actions using Azure Resource Manager, including:

* **Azure Firewall Policy:** To configure features and rules in *Azure Firewall*, with each Virtual Data Centre instance having one deployment of Azure Firewall in the network hub.
* **Route tables:** To direct network flows through/around an Azure Firewall in a hub.

Each deployment of Azure Firewall has an associated firewall policy. The firewall policy is deployed into the `p-[Virtual Data Centre instance name]net` subscription of the Virtual Data Centre instance, enabling distributed management for the network security operators.

Rules and configurations that are specific to the Virtual Data Centre instance are configured in this policy.

A parent policy is centrally managed; the purpose of this policy is to enable centralised management of organisation policy for firewall rules and features. The parent policy settings are inherited by the policies that are associated with the firewalls, and the settings are written through to the firewall.

### Azure Private DNS

The global network services of Project Virtual Data Centre include hosting of **Azure Private DNS zones**.

Azure platform resources can be connected to subnets in virtual networks using a service called **Private Link**. Each platform resource connects to the subnet using a **Private Endpoint**, an IP address from the subnet.

To connect to the platform resource, one will use the **Private Endpoint's** fully qualified domain name (FQDN) that resolves to the subnet IP address instead of the regular resource FQDN that will resolve to the regular public IP address.

A number of **Azure Private DNS zones** have been configured to support the documented DNS zones for **Private Endpoints**. One can send DNS requests to these zones by:

* Using Azure DNS in resources such as virtual networks or Azure Firewall.
* Enabling conditional forwarders in DNS servers (such as domain controllers) for the **Private Endpoint** zone names to redirect to the ***Azure virtual IP address*** of `168.63.129.16`.

### Azure Public DNS

Every organization has some form of **Public DNS service**, either hosted in a data centre, with a hosting company or directly with a DNS registrar. 

These zones can be hosted in **Azure Public DNS**. This is not a requirement, simply a benefit:

* **Azure Public DNS** is a platform service, removing managing infrastructure from the role of managing DNS.
* An **Azure Public DNS zone** is a global resource, replicated to and hosted in every Azure region and Microsoft edge data centre. This makes the service more highly available and places replicas closer to global clients, offering lower latency for the initial connection to FQDN-based Internet services.
* Azure provides a simple user interface, requiring little in the way of support, unlike most web portals or control panels that are used by DNS hosting providers.
* Hosting public DNS zones in the data centre will bring those zones into a consistent governance and security framework.

::: warning
At this time, the one identified issue is that there is **NO** support for DNSSEC in Azure Public DNS Zones.
:::

### Central Key Vault

**Azure Key Vaults** provides a secure place to store secrets such as certificates or passwords.

A central key vault is deployed into the `p-net` subscription in the `p-net-kv` resource group. This key vault is used to store global secrets that will be used by more than one workload in any data centre.

::: note
Secrets that are specific to workloads should be stored in a key vault that is created with the workload.
:::

Text based secrets that are of global importance may be stored in the key vault and made available to central network administrators through role-based access control.
#### Web Application Firewall

The **Web Application Firewalls (WAFs)** in each data centre can be use to provide end-to-end TLS-encrypted (HTTPS) access to web services hosted in workloads.

Instead of storing the SSL Certificates multiple times (WAFs and workloads), the certificates may be stored once in the Central Key Vault. Access can be delegated as necessary. For example, the Web Application Firewalls (WAFs) can have *LIST* and *GET* permissions to *secrets* and *certificates*.

#### Automated Domain Joins

If an automated domain join system is used, the secrets for joining virtual machines to the domain may be stored in the key vault, available for retrieval by the automated process.
