variable "backend_address_pool" {
  type = object({
    id                        = optional(string)
    backend_address_pool_name = optional(string)
    loadbalancer_name         = optional(string)
    resource_group_name       = optional(string)
    tag                       = optional(string)
  })
  description = "(Required) The ID of the Backend Address Pool. Changing this forces a new Backend Address Pool Address to be created."
}

variable "ip_address" {
  type        = string
  description = "(Required) The Static IP Address which should be allocated to this Backend Address Pool."
}

variable "name" {
  type        = string
  description = "(Required) The name which should be used for this Backend Address Pool Address. Changing this forces a new Backend Address Pool Address to be created."
}

variable "virtual_network" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    tag                 = optional(string)
  })
  description = "(Required) The ID of the Virtual Network within which the Backend Address Pool should exist."
}


variable "virtual_networks" {
  description = "(Optional) Output object from Module Azure-VirtualNetwork, to be used with 'virtual_network_tag' and 'virtual_network_tag'"
  type = map(object({
    id   = string # Resource ID of the virtual Network
    name = string # Name of the Virtual Network
    subnet = map(object({
      id = string
    }))
  }))
  default = {}
}

variable "backend_address_pools" {
  type = map(object({
    id = optional(string)
  }))
  default = {}
}

