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
    name = optional(string)
    tag  = optional(string)
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
  description = "(Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Tags"
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
  type    = bool
  default = false
}

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
    tag                 = optional(string)
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

variable "disk_size_gb" {
  type        = number
  description = "(Optional, Required for a new managed disk) Specifies the size of the managed disk to create in gigabytes. If create_option is Copy or FromImage, then the value must be equal to or greater than the source's size. The size can only be increased."
  default     = 32
}

variable "disk_encryption_key" {
  type = object({
    secret_url      = string #   (Required) The URL to the Key Vault Secret used as the Disk Encryption Key. This can be found as id on the azurerm_key_vault_secret resource.
    source_vault_id = string #    (Required) The URL of the Key Vault. This can be found as vault_uri on the azurerm_key_vault resource.
  })
  description = "(Optional) A disk_encryption_key block for encryption_settings block"
  default     = null
}

variable "key_encryption_key" {
  type = object({
    key_url         = string #   (Required) The URL to the Key Vault Key used as the Key Encryption Key. This can be found as id on the azurerm_key_vault_key resource.
    source_vault_id = string #   (Required) The ID of the source Key Vault.
  })
  default = null
}

variable "image_reference_id" {
  type        = string
  description = "(Optional) ID of an existing platform/marketplace disk image to copy when create_option is FromImage"
  default     = null
}


variable "os_type" {
  type        = string
  description = "(Optional) Specify a value when the source of an Import or Copy operation targets a source that contains an operating system. Valid values are Linux or Windows."
  default     = null
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


