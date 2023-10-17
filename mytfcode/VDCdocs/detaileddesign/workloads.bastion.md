## Azure Bastion

Azure Bastion is a service that provides secure and seamless RDP/SSH connection to virtual machines without exposing RDP/SSH ports to the outside world.

The service is an alternative to setting up dedicated jump box servers with solutions like Remote Desktop Services or Azure Virtual Desktop.

Azure Bastion can:

* Use Azure Active Directory authentication: Provides a simple, structured and known process of granting and removing access to virtual machines.
* Completely remove use of public IP's of virtual machines: Increases security of virtual machines by separating it from internet access.
* Safely provide access to virtual machines from anywhere: Enables the possibility of accessing virtual machines without the requirement of being in a trusted network.

For the user to be able to connect by using Azure Bastion, the user require reader access to the Bastion host.

Azure Bastion hosts can be shared across virtual network peering and with careful routing, also be shared within a Virtual WAN.

The alternative deployment approach, will impact the complexity and the costs associated with running Bastion as the connection method, because a Bastion host must be deployed into every virtual network that requires access to virtual machines.

The bastion host requires a public IP address. The use of a public IP address is denied in the Virtual Data Centre, therefore an exclusion must be created, in Azure Policy, to allow it.

The bastion host(s) it must be isolated in a separate subnet called AzureBastionSubne, with a minimum AzureBastionSubnet size of /26 or larger (/25, /24, etc.) and the subnet cannot contain additional resources.

A dedicated network security group, called [VNet name]-AzureBastionSubnet-nsg, provide layer-4 security for the subnet.

The NSG should only allow in traffic that is required for Azure Bastion to function.
