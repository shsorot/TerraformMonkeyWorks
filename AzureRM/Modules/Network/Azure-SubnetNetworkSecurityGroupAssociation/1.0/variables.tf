variable "network_security_group" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    tag                 = optional(string)
  })
  description = "(Required) The ID of the Network Security Group which should be associated with the Subnet. Changing this forces a new resource to be created."
}

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

variable "network_security_groups" {
  type = map(object({
    id = optional(string)
  }))
  default     = {}
  description = "(Optional) Output of module Azure-NetworkSecurityGroups/1.0"
}

