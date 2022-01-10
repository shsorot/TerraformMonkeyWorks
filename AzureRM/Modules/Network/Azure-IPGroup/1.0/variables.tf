variable "name" {
  description = "(Required) Name of the IP Group to be created"
}

variable "tags" {
  description = "(Required) Tags of the IP Group to be created"
  default     = {}
}

variable "inherit_tags" {
  type    = bool
  default = false
}

# variable "resource_group_name" {
#   description = "(Required) Resource Group of the IP Group to be created"
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
  description = "(Required) Location of the resource 'IP Group' to be created."
  default     = null
}

variable "cidrs" {
  description = "(Required) Vnet/subnet CIDRs of the IP Group to be created"
  type        = list(string)
  default     = null
}



