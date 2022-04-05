variable "name" {
  type        = string
  description = "(Required) The name of the NetApp Snapshot Policy. Changing this forces a new resource to be created."
}


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
  description = "(Required) The Azure Region where the Log Analytics Cluster should exist. Changing this forces a new Log Analytics Cluster to be created."
  default     = null
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "inherit_tags" {
  type    = bool
  default = false
}

variable "account" {
  type = object({
    name = optional(string) # Name of the NetApp Account 
    tag  = optional(string) # alternatively, the tag specifying the NetApp Account from the output of module Azure-NetAppAccount
  })
  description = "(Required) The name of the NetApp Account. Specify either the actual name or the Tag value that can be used to look up NetApp Account properties from output of module Azure-NetAppAccount."
}

variable "enabled"{
  type = bool
  description = "(Required) Defines that the NetApp Snapshot Policy is enabled or not."
  default = false
}

variable "hourly_schedule"{
  type = object({
    snapshots_to_keep = optional(number)  # (Required) How many hourly snapshots to keep, valid range is from 0 to 255.
    minute            = optional(number)  # (Required) The minute at which the hourly snapshot is taken. Valid range is from 0 to 59.
  })
  description = "(Optional) Defines the hourly schedule for the NetApp Snapshot Policy."
  default = {}
}

variable "daily_schedule"{
  type = object({
    snapshots_to_keep = optional(number)  # (Required) How many daily snapshots to keep, valid range is from 0 to 255.
    hour              = optional(number)  # (Required) The hour at which the daily snapshot is taken. Valid range is from 0 to 23.
    minute            = optional(number)  # (Required) The minute at which the daily snapshot is taken. Valid range is from 0 to 59.
  })
  description = "(Optional) Defines the daily schedule for the NetApp Snapshot Policy."
  default = {}
}

variable "weekly_schedule"{
  type = object({
    snapshots_to_keep = optional(number)        # (Required) How many weekly snapshots to keep, valid range is from 0 to 255.
    days_of_week      = optional(list(string))  # (Required) The day of the week at which the weekly snapshot is taken. Valid values are Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday.
    hour              = optional(number)        # (Required) The hour at which the weekly snapshot is taken. Valid range is from 0 to 23.
    minute            = optional(number)        # (Required) The minute at which the weekly snapshot is taken. Valid range is from 0 to 59.
  })
  description = "(Optional) Defines the weekly schedule for the NetApp Snapshot policy."
  default = {}
}

variable "monthly_schedule"{
  type = object({
    snapshots_to_keep = optional(number)        # (Required) How many weekly snapshots to keep, valid range is from 0 to 255.
    days_of_month     = optional(list(number))  # (Required) The day/s of the month at which the monthly snapshot is taken. Valid values are dates in numerical value.
    hour              = optional(number)        # (Required) The hour at which the monthly snapshot is taken. Valid range is from 0 to 23.
    minute            = optional(number)        # (Required) The minute at which the monthly snapshot is taken. Valid range is from 0 to 59.
  })
  description = "(Optional) Defines the weekly schedule for the NetApp Snapshot policy."
  default = {}
}

variable "netapp_accounts" {
  type = map(object({
    id   = string # Resource ID of the NetApp account
    name = string # Name of the NetApp Account 
  }))
  description = "(Optional) Output of Module Azure-NetAppAccount. Used to lookup NetApp Account properties using Tags"
  default     = {}
}