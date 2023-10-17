# The Azure Firewall & Network Security Group Rule Cheat Sheet

## Introduction

The purpose of this document is to provide some very simple guidelines on how to create and maintain rules in Azure Firewall and NSGs.

## Purposes

Azure Firewall is used to inspect:

* Traffic entering the spoke network.
* Traffic leaving the spoke network.

Azure Firewall is not normally used to inspect traffic inside of a spoke network.

NSGs are normally implemented with inbound rules only. The NSG is associated with a subnet but applies to the NICs of resources connected to the subnet. NSG rules control traffic entering a NIC:

* From outside of the subnet, including other subnets in the same virtual network and outside of the virtual network.
* From inside the subnet.

## Common Structure

A rule should be present in the firewall and in the NSG when:

* The traffic is inbound to a workload resource.
* The traffic is from outside of the workload virtual network.

The structure of the rules should be the same:

* The name
* Source(s)
* Destination(s)
* Protocol and port(s)

*Note that sources and destinations in the firewall will be IP addresses. Sources and destinations in NSG rules should be Application Security Groups if the source/destination is a virtual machine in the workload.*

## Rule Naming

The structure of a firewall/NSG rule name is:

[Action][Service]From[Source]To[Destination]

For example:

AllowHttpFromFdr01ToStockmarket

The components of the standard are:

* Action: Allow or Deny
* Service: The name of the service being used. For example: Rdp, Https, Sftp, Rpc
* Source: Name the actual source of the traffic. For example: Onpremclientsubnet, Fdr01, Sql02.
* Destination: Name the actual destination of the traffic. For example: Sqlsubnet, Sql01, Sql02.

Each component starts with uppercase and the rest of the component is in lowercase. The purpose of this is to easily separate the components. For example:

* Incorrect: OnPremClientSubnet
* Correct: Onpremclientsubnet

## Platform Versus Workload

We can break rules into two types:

* Platform: Rules that make the network function. For example: DNS, Azure Bastion, Azure Load Balancer.
* Workload: Rules that allow the workload to function. For example: Enabling one VM to reach another using SQL (TCP 1433) or HTTPS (TCP 443).

## Source & Destination

The source/destinations of a rule should be as precise as possible. Specific items should be used.

*In the case of "platform rules", the source or destination may be a subnet or virtual network address space - this is to make the workload more usable for developers/operators as the add resources over time.*

For example:

* Example 1: A source will be one virtual machine. The source should be the virtual machine, not an address space.
* Example 2: A destination will be two private endpoints. The destination should be the two private endpoints, not an address space.

Each virtual machine (NIC) or private endpoint (NIC) should be associated with at least one Application Security Group. When a NSG rule uses a virtual machine or private endpoint from the same workload as a source/destination then the application security group should be used, not the IP address.

*Azure Firewall does not support Application Security Groups. We do not encourage the use of IP Groups in Azure Firewall because of scaling limitations with deployment/update actions. Azure Firewall should use IP Addresses.*

NSGs allow the abstraction of Azure services using Service Tags. Where possible, Service Tags should be used.

Azure Firewall offers abstractions for Microsoft and Azure services using FQDN Tags and Service Tags. Where possible, FQDN Tags and Service Tags should be used.

## Rule Placement

Rules that affect more than one VDC instance should be added to the parent Firewall Policy in p-net-azfw in the globalrules rules collection group.

Rules that will affect an entire VDC instance should be added to the <VDC instance name>rules child rules collection group in the p-<VDC instance name>net-network-fw-firewallpolicy policy resource in p-<VDC instance name>net-network.

Rules that enable a workload to function should be placed in a rules collection group named after the workload. The rules collection group will be deployed to the child firewall policy for the VDC instance.

## Rule Priorities

### Azure Firewall

In Azure Firewall, there are two sets of priorities affecting processing order:

1. Rules collection groups: Rules collection groups are processed in order.
2. Rules collections: Rules collections are processed in order inside of a rules collection group.

The globalrules rules collection group in the parent policy is given a priority of 100.

The <VDC instance name>rule rules collection group in the child policy is given a priority of 200.

Workloads in a child policy start with 10000 and increment by 100. For example, 10000, 10100, 10200, and so on.

Rules collections start at 100 and increment by 100. For a workload called t-tstsp1, the possible rules collections are:

* 100: Nat-Dnat-t-tstsp1
* 200: Network-Deny-t-tstsp1
* 300: Network-Allow-t-tstsp1
* 400: Application-Deny-t-tstsp1
* 500: Application-Allow-t-tstsp1

The rules in a rules collection do not have a processing order; they are simply a pattern matching filter to trigger the action of a Rules Collection.

### NSG

The rules in an NSG start at 1000 and increment by 100 up to 4000. The priorities of 3900 (AllowProbeFromAzureloadbalancerToXyz) and 4000 (DenyAll) are reserved.

## Logic

Always check to see if a rule is required at all. For example, an Azure Firewall rule to allow outbound access for Windows Update should not be required - the rules in the parent firewall policy should enable Windows Update.  

If a rule seems like it will be common across all networks in the VDC instance, then it should be applied in the Azure Firewall rules collection group for VDC instance in the child firewall policy.

If a rule seems like it will be common across all networks in all VDC instances, then it should be applied in the globalrules rules collection group in the parent firewall policy.

Azure Firewall should normally never see traffic inside of a subnet.

If a Workload A resource on 10.100.20.5 in Subnet A is going to communicate by HTTPS to a Workload A private endpoint on 10.100.20.68 in Subnet B, then:

* The Azure Firewall should not have a rule because it will not see the traffic
* The NSG for the subnet should allow TCP 443 from 10.100.19.4 to the application security group of the private endpoint NIC.

If an on-premises resource on 192.168.1.1 is going to communicate by HTTPS to a private endpoint on 10.100.20.4 in a workload, then:

* The Azure Firewall should allow TCP 443 from 192.168.1.1 to 10.100.20.4
* The NSG for the subnet should allow TCP 443 from 192.168.1.1 to the application security group of the private endpoint NIC.

If a Workload A resource on 10.100.19.4 is going to communicate by HTTPS to a Workload B private endpoint on 10.100.20.4, then:

* The Azure Firewall should allow TCP 443 from 10.100.19.4 to 10.100.20.4
* The NSG for the subnet should allow TCP 443 from 10.100.19.4 to the application security group of the private endpoint NIC.
