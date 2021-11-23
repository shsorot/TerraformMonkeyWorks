variable "network_interface" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    tag                 = optional(string)
  })
}

variable "network_interfaces" {
  type = map(object({
    id = optional(string)
  }))
  description = "(Optional) Output of module Azure-NetworkInterfaces."
  default     = {}
}

variable "ip_configuration_name" {
  type = string
}

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

variable "backend_address_pools" {
  type = map(object({
    id = optional(string)
  }))
  default = {}
}

