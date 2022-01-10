variable "name" {
  type        = string
  description = "(Required) The name of the share. Must be unique within the storage account where the share is located."
}

variable "storage_account_name" {
  type        = string
  description = "(Required) Specifies the storage account in which to create the share. Changing this forces a new resource to be created."
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

variable "acl" { # Key value is used for ACL ID
  type = map(object({
    access_policy = object({
      permissions = string           #     (Required) The permissions which should be associated with this Shared Identifier. Possible value is combination of r (read), w (write), d (delete), and l (list).
      start       = optional(string) #   (Optional) The time at which this Access Policy should be valid from, in ISO8601 format.
      expiry      = optional(string) #    (Optional) The time at which this Access Policy should be valid until, in ISO8601 format.
    })
  }))
  default = null
}

