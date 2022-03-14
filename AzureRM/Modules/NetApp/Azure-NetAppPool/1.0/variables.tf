variable "name" {
  type        = string
  description = "(Required) The name of the NetApp Pool. Changing this forces a new resource to be created."
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

variable "service_level" {
  type        = string
  description = "(Required) The service level of the file system. Valid values include Premium, Standard, or Ultra. Changing this forces a new resource to be created."
  default     = "Standard"
}

variable "size_in_tb" {
  type        = number
  description = "(Required) Provisioned size of the pool in TB. Value must be between 4 and 500."
  default     = 4
}

variable "qos_type" {
  type        = string
  description = "(Optional) QoS Type of the pool. Valid values include Auto or Manual. Cannot be changed back to Auto once changed."
  default     = "Auto"
}


variable "netapp_accounts" {
  type = map(object({
    id   = string # Resource ID of the NetApp account
    name = string # Name of the NetApp Account 
  }))
  description = "(Optional) Output of Module Azure-NetAppAccount. Used to lookup NetApp Account properties using Tags"
  default     = {}
}