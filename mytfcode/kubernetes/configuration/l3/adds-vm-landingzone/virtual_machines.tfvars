# Virtual machines
virtual_machines = {

  # Configuration to deploy a bastion host linux virtual machine
  adds_dc1 = {
    resource_group_key = "adds"
    provision_vm_agent = true

    os_type = "windows"

    # when boot_diagnostics_storage_account_key is empty string "", boot diagnostics will be put on azure managed storage
    # when boot_diagnostics_storage_account_key is a non-empty string, it needs to point to the key of a user managed storage defined in diagnostic_storage_accounts
    # if boot_diagnostics_storage_account_key is not defined, but global_settings.resource_defaults.virtual_machines.use_azmanaged_storage_for_boot_diagnostics is true, boot diagnostics will be put on azure managed storage


    # the auto-generated ssh key in keyvault secret. Secret name being {VM name}-ssh-public and {VM name}-ssh-private
    keyvault_key = "adds_keyvault"

    # Define the number of networking cards to attach the virtual machine
    networking_interfaces = {
      nic0 = {
        # Value of the keys from networking.tfvars
        vnet_key                 = "adds_region1_vnet"
        subnet_key              = "frontend"
        name                    = "p-we1dc-adds01-nic0"
        enable_ip_forwarding    = false
        internal_dns_name_label = "p-we1dc-adds01"

        # you can setup up to 5 profiles
        # diagnostic_profiles = {
        #   operations = {
        #     definition_key   = "nic"
        #     destination_type = "log_analytics"
        #     destination_key  = "central_logs"
        #   }
        # }

      }
    }

    virtual_machine_settings = {
      windows = {
        name = "p-we1dc-adds01"
        size = "Standard_D1_v2"
        #zone = "1"

        admin_username_key = "vmadmin-username"
        admin_password_key = "vmadmin-password"

        # Spot VM to save money
        priority        = "Spot"
        eviction_policy = "Deallocate"

        # Value of the nic keys to attach the VM. The first one in the list is the default nic
        network_interface_keys = ["nic0"]

        os_disk = {
          name                 = "p-we1dc-adds01-os-disk"
          caching              = "ReadWrite"
          storage_account_type = "Standard_LRS"
          managed_disk_type    = "StandardSSD_LRS"
          disk_size_gb         = "128"
          create_option        = "FromImage"
        }

        source_image_reference = {
          publisher = "MicrosoftWindowsServer"
          offer     = "WindowsServer"
          sku       = "2019-Datacenter"
          version   = "latest"
        }

      }
    }

#    virtual_machine_extensions = {
#      microsoft_azure_domainjoin = {
#        domain_name = "contoso.com"
#        ou_path     = ""
#        restart     = "true"
#        #specify the AKV location of the password to retrieve for domain join operation
#        keyvault_key = "example_vm_rg1"
#        domain_join_password_keyvault = {
#          #key_vault_id = ""
#          secret_name = "domain-join-password"
#          #lz_key = ""
#        }
#        domain_join_username_keyvault = {
#          keyvault_key = "example_vm_rg1"
#          #lz_key = ""
#          #key_vault_id = ""
#        }
#          secret_name = "domain-join-username"
#      }
#    }
  }
}