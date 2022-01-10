variable "subnet" {
  type = object({
    id                   = optional(string)
    name                 = optional(string)
    virtual_network_name = optional(string)
    resource_group_name  = optional(string)
    tag                  = optional(string)
    virtual_network_tag  = optional(string)
  })
}

variable "virtual_networks" {
  type = map(object({
    id = optional(string)
    subnet = map(object({
      id = optional(string)
    }))
  }))
  description = "(Optional)Output of module Azure-VirtualNetwork/2.0"
  default     = {}
}


variable "route_table" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    tag                 = optional(string)
  })
}


variable "route_tables" {
  type = map(object({
    id = optional(string)
  }))
  description = "(Optional)Output of module Azure-RouteTable."
  default     = {}
}

