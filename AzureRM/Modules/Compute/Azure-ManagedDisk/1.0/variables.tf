variable "name" {
  type        = string
  description = "(Required) Specifies the name of the Managed Disk. Changing this forces a new resource to be created."
}

# variable "resource_group_name" {
#   type        = string
#   description = "(Required) The name of the Resource Group where the Managed Disk should exist."
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
  description = "(Required) Specified the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
}

variable "inherit_tags" {
  type        = bool
  default     = false
  description = "If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'."
}

# Deprecated in provider version > 3.xx.x
# variable "zones" {
#   type        = list(number)
#   description = "(Optional) A collection containing the availability zone to allocate the Managed Disk in."
# }

variable "zone" {
  type        = number
  description = "(Optional) A number containing the availability zone to allocate the Managed Disk in."
  default     = null
}


variable "storage_account_type" {
  type        = string
  description = "(Required) The type of storage to use for the managed disk. Possible values are Standard_LRS, Premium_LRS, StandardSSD_LRS or UltraSSD_LRS."
  default     = "Standard_LRS"
}

variable "create_option" {
  type        = string
  description = <<EOT
    (Required) The method to use when creating the managed disk. Changing this forces a new resource to be created. Possible values include:
        Import - Import a VHD file in to the managed disk (VHD specified with source_uri).
        Empty - Create an empty managed disk.
        Copy - Copy an existing managed disk or snapshot (specified with source_resource_id).
        FromImage - Copy a Platform Image (specified with image_reference_id)
        Restore - Set by Azure Backup or Site Recovery on a restored disk (specified with source_resource_id).
        EOT
  default     = "Empty"
}


variable "disk_encryption_set" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    key                 = optional(string)
  })
  description = "(Optional) The ID of a Disk Encryption Set which should be used to encrypt this Managed Disk."
  default     = null
}

variable "disk_encryption_sets" {
  type = map(object({
    id = string
  }))
  description = "(Optional) Output of module Azure-DiskEncryptionSet, used to perform lookup of ID using tag."
  default     = {}
}

variable "disk_iops_read_write" {
  type        = number
  description = "(Optional) The number of IOPS allowed for this disk; only settable for UltraSSD disks. One operation can transfer between 4k and 256k bytes."
  default     = null
}

variable "disk_mbps_read_write" {
  type        = number
  description = "(Optional) The bandwidth allowed for this disk; only settable for UltraSSD disks. MBps means millions of bytes per second."
  default     = null
}


variable "disk_iops_read_only" {
  type        = number
  description = " (Optional) The number of IOPS allowed across all VMs mounting the shared disk as read-only; only settable for UltraSSD disks with shared disk enabled. One operation can transfer between 4k and 256k bytes."
  default     = null
}

variable "disk_mbps_read_only" {
  type        = number
  description = "(Optional) The bandwidth allowed across all VMs mounting the shared disk as read-only; only settable for UltraSSD disks with shared disk enabled. MBps means millions of bytes per second."
  default     = null
}


variable "disk_size_gb" {
  type        = number
  description = "(Optional, Required for a new managed disk) Specifies the size of the managed disk to create in gigabytes. If create_option is Copy or FromImage, then the value must be equal to or greater than the source's size. The size can only be increased."
  default     = 32
}

variable "edge_zone" {
  type        = string
  description = " (Optional) Specifies the Edge Zone within the Azure Region where this Managed Disk should exist. Changing this forces a new Managed Disk to be created."
  default     = null
}

# Added in provider > 3.xx.x
variable "encryption_settings" {
  type = object({
    enabled = bool
    disk_encryption_key = object({
      secret_url      = string #   (Required) The URL to the Key Vault Secret used as the Disk Encryption Key. This can be found as id on the azurerm_key_vault_secret resource.
      source_vault_id = string #    (Required) The URL of the Key Vault. This can be found as vault_uri on the azurerm_key_vault resource.
    })
    key_encryption_key = object({
      secret_url      = string #   (Required) The URL to the Key Vault Secret used as the Disk Encryption Key. This can be found as id on the azurerm_key_vault_secret resource.
      source_vault_id = string #    (Required) The URL of the Key Vault. This can be found as vault_uri on the azurerm_key_vault resource.
    })
  })
  default = null
}

variable "hyper_v_generation" {
  type        = string
  description = "(Optional) The HyperV Generation of the Disk when the source of an Import or Copy operation targets a source that contains an operating system. Possible values are V1 and V2. Changing this forces a new resource to be created."
  default     = null
}

variable "gallery_image_reference_id" {
  type        = string
  description = "(Optional) ID of a Gallery Image Version to copy when create_option is FromImage. This field cannot be specified if image_reference_id is specified."
  default     = null
}

variable "image_reference_id" {
  type        = string
  description = "(Optional) ID of an existing platform/marketplace disk image to copy when create_option is FromImage"
  default     = null
}

variable "logical_sector_size" {
  type        = number
  description = "(Optional) Logical Sector Size. Possible values are: 512 and 4096. Defaults to 4096. Changing this forces a new resource to be created."
  default     = 4096
}

variable "max_shares" {
  type        = number
  description = "(Optional) The maximum number of VMs that can attach to the disk at the same time. Value greater than one indicates a disk that can be mounted on multiple VMs at the same time."
  default     = null
}

variable "public_network_access_enabled" {
  type        = bool
  description = "(Optional) Whether it is allowed to access the disk via public network. Defaults to true."
  default     = true
}

variable "os_type" {
  type        = string
  description = "(Optional) Specify a value when the source of an Import or Copy operation targets a source that contains an operating system. Valid values are Linux or Windows."
  default     = null
}

variable "on_demand_bursting_enabled" {
  type        = bool
  description = "(Optional) Specifies if On-Demand Bursting is enabled for the Managed Disk. Defaults to false"
  default     = false
}

variable "source_resource_id" {
  type        = string
  description = "(Optional) The ID of an existing Managed Disk to copy create_option is Copy or the recovery point to restore when create_option is Restore"
  default     = null
}

variable "source_uri" {
  type        = string
  description = "(Optional) URI to a valid VHD file to be used when create_option is Import."
  default     = null
}

variable "storage_account_id" {
  type        = string
  description = "(Optional) The ID of the Storage Account where the source_uri is located. Required when create_option is set to Import. Changing this forces a new resource to be created."
  default     = null
}

variable "trusted_launch_enabled" {
  type        = bool
  description = " (Optional) Specifies if Trusted Launch is enabled for the Managed Disk. Defaults to false."
  default     = false
}

variable "tier" {
  type        = string
  description = "The disk performance tier to use. Possible values are documented here(https://docs.microsoft.com/en-us/azure/virtual-machines/disks-change-performance). This feature is currently supported only for premium SSDs."
  default     = null
}

variable "network_access_policy" {
  type        = string
  description = "Policy for accessing the disk via network. Allowed values are AllowAll, AllowPrivate, and DenyAll."
  default     = "AllowAll"
}

variable "disk_access_id" {
  type        = string
  description = "The ID of the disk access resource for using private endpoints on disks."
  default     = null
}


