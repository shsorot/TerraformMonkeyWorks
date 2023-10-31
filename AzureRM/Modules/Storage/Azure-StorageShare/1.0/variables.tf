variable "name" {
  type        = string
  description = "(Required) The name of the share. Must be unique within the storage account where the share is located."
}

variable "storage_account" {
  type        = object({
    name = optional(string)
    key  = optional(string)
  })
  description = "(Required) Specifies the storage account in which to create the share. Changing this forces a new resource to be created."
}

variable "access_tier" {
  type = string
  description = "(Optional) The access tier of the File Share. Possible values are Hot, Cool and TransactionOptimized, Premium."
  default = null
}

variable "acl"{
  type = list(object({
    id            = string #(Required) The ID which should be used for this Shared Identifier.
    access_policy = optional(object({
      permissions = optional(string) # (Required) The permissions which should be associated with this Shared Identifier. Possible value is combination of r (read), w (write), d (delete), and l (list).
      start       = optional(string) # (Optional) The time at which this Access Policy should be valid from, in ISO8601 format.
      expiry      = optional(string) # (Optional) The time at which this Access Policy should be valid until, in ISO8601 format.
    }))
  }))
  default = null
}

variable "enabled_protocol" {
  type = string
  description = "(Optional) The protocol used for the share. Possible values are SMB and NFS. The SMB indicates the share can be accessed by SMBv3.0, SMBv2.1 and REST. The NFS indicates the share can be accessed by NFSv4.1. Defaults to SMB. Changing this forces a new resource to be created."
  default = "SMB"
}

variable "quota" {
  type        = number
  description = <<EOT
  (Optional) The maximum size of the share, in gigabytes. 
  For Standard storage accounts, this must be greater than 0 and less than 5120 GB (5 TB). 
  For Premium FileStorage storage accounts, this must be greater than 100 GB and less than 102400 GB (100 TB). 
  Default is 5120.
  EOT
  default     = 5120
}

variable "metadata" {
  type        = map(string)
  description = "(Optional) A mapping of MetaData for this File Share."
  default     = {}
}

variable "storage_accounts"{
  type = map(object({
    id    = string
    name  = string
  }))
  description = "(Optional) Output of module Azure-StorageAccount"
}