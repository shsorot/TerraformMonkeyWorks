variable "name" {
  type        = string
  description = "(Required) The name which should be used for this Log Analytics Cluster. Changing this forces a new Log Analytics Cluster to be created."
}

# variable "resource_group_name" {
#   type = string
#   description = "(Required) The name of the Resource Group where the Log Analytics Cluster should exist. Changing this forces a new Log Analytics Cluster to be created."
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
  description = "(Required) The Azure Region where the Log Analytics Cluster should exist. Changing this forces a new Log Analytics Cluster to be created."
  default     = null
}

variable "identity" {
  type = object({
    type = string
  })
  description = "(Required) A identity block as defined below. Changing this forces a new Log Analytics Cluster to be created."
  default = {
    type = "SystemAssigned"
  }
}

variable "size_gb" {
  type        = number
  description = "(Optional) The capacity of the Log Analytics Cluster specified in GB/day. Defaults to 1000."
  default     = 1000
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "inherit_tags" {
  type    = bool
  default = false
}

