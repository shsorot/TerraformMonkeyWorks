variable "name" {
  type        = string
  description = "(Required) The Name which should be used for this Connection, which must be unique within the Virtual Hub. Changing this forces a new resource to be created."
}

variable "virtual_hub" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    tag                 = optional(string)
  })
  description = "(Required) The ID of the Virtual Hub within which this connection should be created. Changing this forces a new resource to be created."
}

variable "virtual_hubs" {
  type = map(object({
    id = string
  }))
  default = {}
}

variable "remote_virtual_network" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    subscription_id     = optional(string)
    tag                 = optional(string)
  })
  description = "(Required) The ID of the Virtual Network which the Virtual Hub should be connected to. Changing this forces a new resource to be created."
}

variable "remote_virtual_networks" {
  type = map(object({
    id = string
  }))
  default = {}
}

variable "internet_security_enabled" {
  type        = bool
  description = "(Optional) Should Internet Security be enabled to secure internet traffic? Changing this forces a new resource to be created. Defaults to false."
  default     = false
}

variable "routing" {
  type = object({
    associated_route_table = object({
      id   = optional(string)
      name = optional(string)
      tag  = optional(string)
    })
    propagated_route_table = object({
      labels = optional(string)
      route_table = list(object({
        id   = optional(string)
        name = optional(string)
        tag  = optional(string)
      }))
    })
    static_vnet_route = object({
      name                = optional(string)
      address_prefixes    = optional(list(string))
      next_hop_ip_address = optional(string)
    })
  })
}

variable "route_tables" {
  type = map(object({
    id = string
  }))
  default = {}
}