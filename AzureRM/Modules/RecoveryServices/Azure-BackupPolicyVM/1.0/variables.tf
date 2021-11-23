variable "name" {
  type        = string
  description = "(Required) Specifies the name of the Backup Policy. Changing this forces a new resource to be created."
}

# variable "resource_group_name" {
#   type = string
#   description = "Required) The name of the resource group in which to create the policy. Changing this forces a new resource to be created."
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

variable "recovery_vault" {
  type = object({
    name = optional(string)
    tag  = optional(string)
  })
  description = "(Required) Specifies the name of the Recovery Services Vault to use. Changing this forces a new resource to be created."
}

variable "recovery_vaults" {
  type = map(object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
  }))
  default = {}
}

variable "instant_restore_retention_days" {
  type        = number
  description = "(Optional) Specifies the instant restore retention range in days."
  default     = null
}

variable "timezone" {
  type        = string
  description = "(Optional) Configures the policy daily retention as documented in the retention_daily block below. Required when backup frequency is Daily."
  default     = "UTC"
}


variable "backup" {
  type = object({
    frequency = string                 # either "Daily" or "Weekly"
    time      = string                 # 24h format (e.g. "01:00")
    weekdays  = optional(list(string)) # must be set to null for Daily frequency; ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"] for Weekly frequency
  })
  description = "(Required) Configures the Policy backup frequency, times & days as documented"
}

variable "retention_daily" {
  type = object({
    count = number # (Required) The number of daily backups to keep. Must be between 7 and 9999.
  })
  default = null
}

variable "retention_weekly" {
  type = object({ # must be set to null if not relevant
    count    = number
    weekdays = list(string) # ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
  })
  default = null
}

variable "retention_monthly" {
  type = object({           # must be set to null if not relevant
    count    = number       # (Required) The number of monthly backups to keep. Must be between 1 and 9999
    weekdays = list(string) # ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    weeks    = list(string) # ["First", "Second", "Third", "Fourth", "Last"]
  })
}

variable "retention_yearly" {
  type = object({
    count    = number       # Required) The number of yearly backups to keep. Must be between 1 and 9999
    weekdays = list(string) # ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    weeks    = list(string) # ["First", "Second", "Third", "Fourth", "Last"]
    months   = list(string) # [January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
  })
}


variable "tags" {
  type    = map(string)
  default = {}
}

variable "inherit_tags" {
  type    = bool
  default = false
}

