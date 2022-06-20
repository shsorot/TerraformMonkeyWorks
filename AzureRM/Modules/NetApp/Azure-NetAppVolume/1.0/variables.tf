variable "name" {
  type        = string
  description = "(Required) The name of the NetApp Pool. Changing this forces a new resource to be created."
}


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
  description = "(Required) The Azure Region where the Log Analytics Cluster should exist. Changing this forces a new Log Analytics Cluster to be created."
  default     = null
}

variable "tags" {
  type    = map(string)
  description = " (Optional) A mapping of tags to assign to the resource."
  default = {}
}

variable "inherit_tags" {
  type        = bool
  default     = false
  description = "If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'."
}

variable "account" {
  type = object({
    name = optional(string) # Name of the NetApp Account 
    key  = optional(string) # alternatively, the tag specifying the NetApp Account from the output of module Azure-NetAppAccount
  })
  description = "(Required) The name of the NetApp Account. Specify either the actual name or the Tag value that can be used to look up NetApp Account properties from output of module Azure-NetAppAccount."
}

variable "netapp_accounts" {
  type = map(object({
    id   = string # Resource ID of the NetApp account
    name = string # Name of the NetApp Account 
  }))
  description = "(Optional) Output of Module Azure-NetAppAccount. Used to lookup NetApp Account properties using Tags"
  default     = {}
}

variable "pool" {
  type = object({
    name = optional(string) # Name of the NetApp Capacity pool located in the NetApp Account specified in variable "account"
    key  = optional(string) # alternatively, the tag specifying the NetApp Pool from the output of module Azure-NetAppPool
  })
  description = "(Required) The name of the NetApp Pool. Specify either the actual name or the Tag value that can be used to look up NetApp Account properties from output of module Azure-NetAppPool."
}

variable "netapp_pools" {
  type = map(object({
    id            = string # Resource ID of the NetApp Pool
    name          = string # Name of the NetApp Pool 
    service_level = string # Service level of the NetApp Pool
  }))
  description = "(Optional) Output of Module Azure-NetAppPool. Used to lookup NetApp Pool properties using Tags"
  default     = {}
}

variable "volume_path" {
  type        = string
  description = "(Required) A unique file path for the volume. Used when creating mount targets. Changing this forces a new resource to be created."
}

# Deprecated. Now service level is pulled from Capacity pool
# variable "service_level"{
#   type = string
#   description = " (Required) The target performance of the file system. Valid values include Premium, Standard, or Ultra. Must match the service level of pool"
#   default = "Premium"
# }

variable "security_style" {
  type        = string
  description = "(Optional) Volume security style, accepted values are Unix or Ntfs. If not provided, single-protocol volume is created defaulting to Unix if it is NFSv3 or NFSv4.1 volume, if CIFS, it will default to Ntfs. In a dual-protocol volume, if not provided, its value will be Ntfs."
  default     = null
}

variable "protocols" {
  type        = list(string)
  description = "(Optional) The target volume protocol expressed as a list. Supported single value include CIFS, NFSv3, or NFSv4.1. If argument is not defined it will default to NFSv3. Changing this forces a new resource to be created and data will be lost. Dual protocol scenario is supported for CIFS and NFSv3, for more information, please refer to Create a dual-protocol volume for Azure NetApp Files document."
  default     = ["NFSv4.1"]
}

variable "subnet" {
  description = "(Required) Reference to a subnet in which this volume will be placed."
  type = object({
    id                   = optional(string)
    name                 = optional(string)
    virtual_network_name = optional(string)
    resource_group_name  = optional(string)
    tag                  = optional(string)
    virtual_network_key  = optional(string)
  })
}

variable "virtual_networks" {
  description = "(Optional) Output object from Module Azure-VirtualNetwork, to be used with 'virtual_network_tag' and 'virtual_network_tag'"
  type = map(object({
    id   = string # Resource ID of the virtual Network
    name = string # Name of the Virtual Network
    subnet = map(object({
      id = optional(string)
    }))
  }))
  default = {}
}

variable "storage_quota_in_gb" {
  type        = number
  description = "(Required) The maximum Storage Quota allowed for a file system in Gigabytes."
}

variable "snapshot_directory_visible" {
  type        = bool
  description = "(Optional) Specifies whether the .snapshot (NFS clients) or ~snapshot (SMB clients) path of a volume is visible, default value is true."
  default     = true
}

# TODO : modify to accept object to allow data based lookup or Tag based lookup.
# TODO : fetch volume properties from the snapshot resource
# variable "create_from_snapshot_resource_id" {
#   type        = string
#   description = "(Optional) Creates volume from snapshot. Following properties must be the same as the original volume where the snapshot was taken from: protocols, subnet_id, location, service_level, resource_group_name, account_name and pool_name."
#   default     = null
# }
variable "create_from_snapshot_resource" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    account_name        = optional(string)
    pool_name           = optional(string)
    volume_name         = optional(string)
    key                 = optional(string)
  })
  description = "(Optional) Creates volume from snapshot. Following properties must be the same as the original volume where the snapshot was taken from: protocols, subnet_id, location, service_level, resource_group_name, account_name and pool_name."
  default     = null
}

variable "netapp_snapshots" {
  type = map(object({
    id = string
  }))
  description = "(Optional) Output of module Azure-NetAppSnapshot. Used to lookup NetApp Snapshot properties using Tags"
  default     = {}
}

variable "data_protection_replication" {
  type = object({
    endpoint_type             = optional(string) # (Optional) The endpoint type, default value is dst for destination.
    remote_volume_location    = optional(string) #  (Required) Location of the primary volume.
    remote_volume_resource_id = optional(string) #  (Required) Resource ID of the remote protection volume.
    replication_frequency     = optional(string) #  (Required) Replication frequency, supported values are '10minutes', 'hourly', 'daily', values are case sensitive.
  })
  default = null
}

# TODO : add remote subscription lookup capability 
variable "data_protection_snapshot_policy" {
  type = object({
    id   = optional(string) # Resource ID of the Snapshot policy
    name = optional(string) # Name of the Snapshot policy existing within the NetApp Account
    key  = optional(string) # Name of the Snapshot policy Tag available in the output of Azure-NetAppSnapshotPolicy
  })
  default = null
}

variable "snapshot_policies" {
  type = map(object({
    id = string # Resource ID of the Snapshot policy
  }))
  description = "(Optional) Output of Module Azure-NetAppSnapshotPolicy. Used to lookup Snapshot policy properties using Tags"
  default     = null
}

variable "export_policy_rule" {
  type = list(object({
    rule_index          = number                 # (Required) The index number of the rule.
    allowed_clients     = list(string)           # (Required) The list of clients allowed to access the volume.
    protocols_enabled   = optional(list(string)) # (Required) A list of allowed protocols. Valid values include CIFS, NFSv3, or NFSv4.1. Only one value is supported at this time. This replaces the previous arguments: cifs_enabled, nfsv3_enabled and nfsv4_enabled.
    unix_read_only      = optional(bool)         #  (Optional) Is the file system on unix read only?
    unix_read_write     = optional(bool)         #  (Optional) Is the file system on unix read write?
    root_access_enabled = optional(bool)         # (Optional) Is root access permitted to this volume?
  }))
  description = "(Required) Export policy block for the given volume."
}

variable "throughput_in_mibps" {
  type        = number
  description = "(Optional) Throughput of this volume in Mibps.This is required if the pool QOS is set to Manual"
  default     = null
}
