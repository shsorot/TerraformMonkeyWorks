variable "nat_gateway" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    key                 = optional(string)
  })
  description = "(Required) The ID of the Nat Gateway. Changing this forces a new resource to be created."
}

variable "nat_gateways" {
  type = map(object({
    id = optional(string)
  }))
  default = {}
}

variable "public_ip_prefix" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    key                 = optional(string)
  })
  description = " (Required) The ID of the Public IP which this Nat Gateway which should be connected to. Changing this forces a new resource to be created."
}

variable "public_ip_prefixes" {
  type = map(object({
    id = optional(string)
  }))
  default = {}
}

