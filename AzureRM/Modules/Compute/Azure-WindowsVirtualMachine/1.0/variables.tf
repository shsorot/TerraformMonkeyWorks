variable "name" {
  type        = string
  description = "(Required) Name of the Virtual machine to be assigned in Azure. This must be unique in a resource group. Changing this forces creation of a new resource."
}

# variable "resource_group_name"{
#     type = string
#     description =   "(Required) Resource Group to place this resource into."
# }

variable "resource_group" {
  type = object({
    name = optional(string) # Name of the resource group
    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"
  })
  description = "(Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup."
}

variable "resource_groups" {
  type = map(object({
    id       = optional(string)
    location = optional(string)
    tags     = optional(map(string))
    name     = optional(string)
  }))
  description = <<EOF
   (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"
    id       = # ID of the resource group
    location = # Location of the resource group
    tags     = # List of Azure tags applied to resource group
    name     = # Name of the resource group
  EOF
  default     = {}
}

variable "location" {
  type        = string
  description = "(Required) The Azure location where the windows Virtual Machine should exist. Changing this forces a new resource to be created."
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags which should be assigned to this Virtual Machine."
  default     = {}
}

variable "inherit_tags" {
  type        = bool
  default     = false
  description = "If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'."
}

variable "zone" {
  type        = string
  description = "(Optional) The Zone in which this Virtual Machine should be created. Changing this forces a new resource to be created."
  default     = null
}

variable "admin_username" {
  type        = string
  description = "(Required) The username of the local administrator used for the Virtual Machine. Changing this forces a new resource to be created."
  default     = "azureadmin"
}

variable "admin_password" {
  type        = string
  description = "(Optional) The Password which should be used for the local-administrator on this Virtual Machine. Changing this forces a new resource to be created."
  sensitive   = true
  default     = null
}

variable "network_interface" {
  type = list(object({
    id                  = optional(string)
    resource_group_name = optional(string)
    name                = optional(string)
    key                 = optional(string)
  }))
  description = "(Required). A list of Network Interface ID's which should be attached to this Virtual Machine. The first Network Interface ID in this list will be the Primary Network Interface on the Virtual Machine."
  default     = null
}

variable "network_interfaces" {
  type = map(object({
    id = optional(string)
  }))
  description = "(Optional) Output of module Azure-NetworkInterfaces."
  default     = {}
}

variable "os_disk" {
  type = object({
    caching              = optional(string) #   (Required) The Type of Caching which should be used for the Internal OS Disk. Possible values are None, ReadOnly and ReadWrite.
    storage_account_type = optional(string) #   (Required) The Type of Storage Account which should back this the Internal OS Disk. Possible values are Standard_LRS, StandardSSD_LRS and Premium_LRS. Changing this forces a new resource to be created.
    diff_disk_settings = optional(object({
      option = string
    }))
    name                      = optional(string) #    (Optional) The name which should be used for the Internal OS Disk. Changing this forces a new resource to be created.
    disk_size_gb              = optional(string) #   (Optional) The Size of the Internal OS Disk in GB, if you wish to vary from the size used in the image this Virtual Machine is sourced from.
    write_accelerator_enabled = optional(bool)   #    (Optional) Should Write Accelerator be Enabled for this OS Disk? Defaults to false.requires that the storage_account_type is set to Premium_LRS and that caching is set to None
    disk_encryption_set = optional(object({
      id                  = optional(string)
      resource_group_name = optional(string)
      name                = optional(string)
      key                 = optional(string)
    })) #   (Optional) The ID of the Disk Encryption Set which should be used to Encrypt this OS Disk.
  })
  description = "(Required) The configuration for OS_Disk."
  default     = {}
}


variable "size" {
  type        = string
  description = "(Required) The SKU which should be used for this Virtual Machine, such as Standard_F2"
}


variable "disk_encryption_sets" {
  type = map(object({
    id = string
  }))
  description = "(Optional) Output of module Azure-DiskEncryptionSet, used for looking up ID of the same."
  default     = {}
}

variable "additional_capabilities" {
  type = object({
    ultra_ssd_enabled = bool
  })
  description = "(Optional) Should the capacity to enable Data Disks of the UltraSSD_LRS storage account type be supported on this Virtual Machine? Defaults to false"
  default     = null
}

variable "additional_unattend_content" {
  type = object({
    content = string #   (Required) The XML formatted content that is added to the unattend.xml file for the specified path and component. Changing this forces a new resource to be created.
    setting = string #   (Required) The name of the setting to which the content applies. Possible values are AutoLogon and FirstLogonCommands. Changing this forces a new resource to be created.
  })
  description = "(Optional) Custom settings to override Azure Unattend XML that is pushed at VM provision time."
  default     = null
}

variable "allow_extension_operations" {
  type        = bool
  description = "(Optional) Should Extension Operations be allowed on this Virtual Machine?"
  default     = true
}

variable "availability_set" {
  type = object({
    id                  = optional(string)
    resource_group_name = optional(string)
    name                = optional(string)
    key                 = optional(string)
  })
  description = "(Optional) Specifies the ID of the Availability Set in which the Virtual Machine should exist. Changing this forces a new resource to be created."
  default     = null
}


variable "availability_sets" {
  type = map(object({
    id   = optional(string)
    name = optional(string)
  }))
  description = "(Optional) Output of module Azure-AvailabilitySet"
  default     = {}
}

variable "boot_diagnostics" {
  type = object({
    storage_account_uri  = optional(string)
    storage_account_name = optional(string)
  })
  description = "(Optional) Name of the storage account to use for boot diagnostics."
  default     = null
}

variable "computer_name" {
  type        = string
  description = "(Optional) Specifies the Hostname which should be used for this Virtual Machine. If unspecified this defaults to the value for the name field. If the value of the name field is not a valid computer_name, then you must specify computer_name. Changing this forces a new resource to be created."
  default     = null
}

variable "custom_data" {
  type        = string
  description = "(Optional) The Base64-Encoded Custom Data which should be used for this Virtual Machine. Changing this forces a new resource to be created."
  default     = null
}

variable "dedicated_host" {
  type = object({
    id                        = optional(string)
    resource_group_name       = optional(string)
    dedicated_host_group_name = optional(string)
    name                      = optional(string)
    tag                       = optional(string)
  })
  description = "(Optional) The ID of a Dedicated Host where this machine should be run on."
  default     = null
}


variable "dedicated_hosts" {
  type = map(object({
    id = optional(string)
  }))
  description = "(Optional) Output of module Azure-DedicatedHost."
  default     = {}
}

variable "enable_automatic_updates" {
  type        = bool
  description = "(Optional) Specifies if Automatic Updates are Enabled for the Windows Virtual Machine. Changing this forces a new resource to be created."
  default     = null
}

variable "encryption_at_host_enabled" {
  type        = bool
  description = "(Optional) Should all of the disks (including the temp disk) attached to this Virtual Machine be encrypted by enabling Encryption at Host?"
  default     = false
}

variable "eviction_policy" {
  type        = string
  description = "(Optional) Specifies what should happen when the Virtual Machine is evicted for price reasons when using a Spot instance. At this time the only supported value is Deallocate. Changing this forces a new resource to be created."
  default     = null
}

variable "extensions_time_budget" {
  type        = string
  description = "(Optional) Specifies the duration allocated for all extensions to start. The time duration should be between 15 minutes and 120 minutes (inclusive) and should be specified in ISO 8601 format. Defaults to 90 minutes (PT1H30M)."
  default     = "PT1H30M"
}

variable "identity" {
  type = object({
    type = string
    identity = optional(list(object({
      id                  = optional(string)
      name                = optional(string)
      resource_group_name = optional(string)
      key                 = optional(string)
    })))
  })
  description = "(Required) The type of Managed Identity which should be assigned to the windows Virtual Machine. Possible values are SystemAssigned, UserAssigned"
  default     = null
}


variable "license_type" {
  type        = string
  description = "(Optional) Specifies the type of on-premise license (also known as Azure Hybrid Use Benefit) which should be used for this Virtual Machine. Possible values are None, Windows_Client and Windows_Server"
  default     = null
}


variable "max_bid_price" {
  type        = string
  description = "(Optional) The maximum price you're willing to pay for this Virtual Machine, in US Dollars; which must be greater than the current spot price. If this bid price falls below the current spot price the Virtual Machine will be evicted using the eviction_policy. Defaults to -1, which means that the Virtual Machine should not be evicted for price reasons."
  default     = null
}


variable "patch_mode" {
  type        = string
  description = "(Optional) Specifies the mode of in-guest patching to this Windows Virtual Machine. Possible values are Manual, AutomaticByOS and AutomaticByPlatform. Defaults to AutomaticByOS."
  default     = null
}


variable "plan" {
  type = object({
    name      = string #   (Required) Specifies the Name of the Marketplace Image this Virtual Machine should be created from. Changing this forces a new resource to be created.
    product   = string #   (Required) Specifies the Product of the Marketplace Image this Virtual Machine should be created from. Changing this forces a new resource to be created.
    publisher = string #   (Required) Specifies the Publisher of the Marketplace Image this Virtual Machine should be created from. Changing this forces a new resource to be created.
  })
  default = null
}


variable "platform_fault_domain" {
  type        = number
  description = "(Optional) Specifies the Platform Fault Domain in which this windows Virtual Machine should be created. Defaults to -1, which means this will be automatically assigned to a fault domain that best maintains balance across the available fault domains. Changing this forces a new windows Virtual Machine to be created."
  default     = null
}

variable "priority" {
  type        = string
  description = "(Optional) Specifies the priority of this Virtual Machine. Possible values are Regular and Spot. Defaults to Regular. Changing this forces a new resource to be created."
  default     = "Regular"
}

variable "provision_vm_agent" {
  type        = bool
  description = "(Optional) Should the Azure VM Agent be provisioned on this Virtual Machine? Defaults to true. Changing this forces a new resource to be created."
  default     = true
}

variable "proximity_placement_group" {
  type = object({
    id                  = optional(string)
    resource_group_name = optional(string)
    name                = optional(string)
    key                 = optional(string)
  })
  description = "(Optional) The ID of the Proximity Placement Group which the Virtual Machine should be assigned to. Changing this forces a new resource to be created."
  default     = null
}


variable "proximity_placement_groups" {
  type = map(object({
    proximity_placement_group_id = optional(string)
  }))
  default     = {}
  description = "(Optional) Output of module Azure-ProximityPlacementGroup for lookup of PPG ID."
}

variable "secret" {
  type = object({
    key_vault = object({
      id                  = optional(string)
      resource_group_name = optional(string)
      name                = optional(string)
      key                 = optional(string)
    }) #   (Required) The ID of the Key Vault from which all Secrets should be sourced.
    certificate = list(object({
      url   = string
      store = string
    })) #   The Secret URL of a Key Vault Certificate.
  })
  default = null
}


variable "key_vaults" {
  type = map(object({
    id  = string
    uri = optional(string)
  }))
  description = "(Optional) Output of module Azure-KeyVault, to be used to lookup Key vault ID using tags."
  default     = {}
}


variable "source_image_id" {
  type        = string
  description = "(Optional) The ID of the Image which this Virtual Machine should be created from. Changing this forces a new resource to be created."
  default     = null
}

variable "source_image_reference" {
  type = object({
    publisher = optional(string) #   (Optional) Specifies the publisher of the image used to create the virtual machines.
    offer     = optional(string) #   (Optional) Specifies the offer of the image used to create the virtual machines.
    sku       = optional(string) #   (Optional) Specifies the SKU of the image used to create the virtual machines.
    version   = optional(string) #   (Optional) Specifies the version of the image used to create the virtual machines.
  })
  default = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

variable "timezone" {
  type        = string
  description = "(Optional) Specifies the Time Zone which should be used by the Virtual Machine, the possible values are defined here :https://jackstromberg.com/2017/01/list-of-time-zones-consumed-by-azure/."
  default     = null
}

variable "virtual_machine_scale_set" {
  type = object({
    id                  = optional(string)
    resource_group_name = optional(string)
    name                = optional(string)
    key                 = optional(string)
  })
  description = "(Optional) Specifies the Orchestrated Virtual Machine Scale Set that this Virtual Machine should be created within. Changing this forces a new resource to be create"
  default     = null
}

variable "azurerm_orchestrated_virtual_machine_scale_sets" {
  type = map(object({
    id        = optional(string)
    unique_id = optional(string)
    identity = optional(object({
      principal_id = string
    }))
  }))
  default = {}
}

variable "winrm_listener" {
  type = list(object({
    protocol        = string #   (Required) Specifies Specifies the protocol of listener. Possible values are Http or Https
    certificate_url = string #   (Optional) The Secret URL of a Key Vault Certificate, which must be specified when protocol is set to Https.
  }))
  default = null
}


variable "user_assigned_identities" {
  type = map(object({
    id = optional(string)
  }))
  default = {}
}