virtual_machines = {

  # Configuration to deploy a bastion host linux virtual machine
  bastion_host = {
    resource_group_key = "aks_jumpbox"
    provision_vm_agent = true

    os_type = "linux"

    # the auto-generated ssh key in keyvault secret. Secret name being {VM name}-ssh-public and {VM name}-ssh-private
    keyvault_key = "aks_jumpbox"

    # Define the number of networking cards to attach the virtual machine
    networking_interfaces = {
      nic0 = {
        # AKS rely on a remote network and need the details of the tfstate to connect (tfstate_key), assuming RBAC authorization.

        vnet_key                = "aks_region1_vnet"
        subnet_key              = "jumpbox_subnet"
        name                    = "p-we1k8s-jump-box01-nic0"
        enable_ip_forwarding    = false
        internal_dns_name_label = "p-we1k8s-jump-box01"

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
      linux = {
        name                            = "p-we1k8s-jump-box01-vm"
        size                            = "Standard_DS1_v2"

        admin_username                  = "adminuser"
        disable_password_authentication = true
        admin_ssh_keys = {
          # reference a public ssh key in a keyvault secret
          admin = {
            keyvault_key = "aks_jumpbox"
            secret_name  = "ssh-key"
          }
        }
        
        # custom_data                     = "scripts/cloud-init/install-rover-tools.config"
        # Spot VM to save money
        priority        = "Spot"
        eviction_policy = "Deallocate"

        # Value of the nic keys to attach the VM. The first one in the list is the default nic
        network_interface_keys = ["nic0"]

        os_disk = {
          name                 = "p-we1k8s-jump-box01-os-disk"
          caching              = "ReadWrite"
          storage_account_type = "Standard_LRS"
          managed_disk_type    = "StandardSSD_LRS"
          disk_size_gb         = "128"
          create_option        = "FromImage"
        }

        source_image_reference = {
          publisher = "Canonical"
          offer     = "UbuntuServer"
          sku       = "22_04-LTS"
          version   = "latest"
        }

        identity = {
          type                  = "UserAssigned"
          managed_identity_keys = ["aks_jumpbox"]
        }

      }
    }

  }

  winjump_host = {
    resource_group_key = "aks_jumpbox"
    provision_vm_agent = true

    os_type = "windows"

    # when boot_diagnostics_storage_account_key is empty string "", boot diagnostics will be put on azure managed storage
    # when boot_diagnostics_storage_account_key is a non-empty string, it needs to point to the key of a user managed storage defined in diagnostic_storage_accounts
    # if boot_diagnostics_storage_account_key is not defined, but global_settings.resource_defaults.virtual_machines.use_azmanaged_storage_for_boot_diagnostics is true, boot diagnostics will be put on azure managed storage


    # the auto-generated ssh key in keyvault secret. Secret name being {VM name}-ssh-public and {VM name}-ssh-private
    keyvault_key = "aks_jumpbox"

    # Define the number of networking cards to attach the virtual machine
    networking_interfaces = {
      nic0 = {
        # Value of the keys from networking.tfvars
        vnet_key                 = "aks_region1_vnet"
        subnet_key              = "jumpbox_subnet"
        name                    = "p-we1k8s-jump-win01-nic0"
        enable_ip_forwarding    = false
        internal_dns_name_label = "p-we1k8s-jump-win01"

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
        name = "p-we1k8s-jump-win01-vm"
        size = "Standard_D1_v2"
        #zone = "1"

        # admin_username                  = "adminuser"
        admin_username_key = "vmadmin-username"
        admin_password_key = "vmadmin-password"
        # admin_password_keys = {
        #   # reference a public ssh key in a keyvault secret
        #   admin = {
        #     keyvault_key = "aks_jumpbox"
        #     secret_name  = "vmadmin-password"
        #   }
        # }

        # Spot VM to save money
        priority        = "Spot"
        eviction_policy = "Deallocate"

        patch_mode = "AutomaticByOS"
        # Value of the nic keys to attach the VM. The first one in the list is the default nic
        network_interface_keys = ["nic0"]

        os_disk = {
          name                 = "p-we1k8s-jump-win01-os-disk"
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

        ## Applications
        # TLS


        # AZ Cli - 
        # $ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; Remove-Item .\AzureCLI.msi

      }
    }
  }
}