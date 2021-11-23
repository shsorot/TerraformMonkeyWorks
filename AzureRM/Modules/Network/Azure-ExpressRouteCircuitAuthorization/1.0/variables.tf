variable "name" {
  type        = string
  description = "(Required) The name of the ExpressRoute circuit. Changing this forces a new resource to be created."
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


variable "express_route_circuit" {
  type = object({
    name = optional(string)
    tag  = optional(string)
  })
}

variable "express_route_circuits" {
  type = map(object({
    id   = optional(string)
    name = optional(string)
  }))
  default = {}
}