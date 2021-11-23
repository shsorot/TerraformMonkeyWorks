variable "name" {
  type        = string
  description = "(Required) The name which should be used for this Express Route Circuit Connection. Changing this forces a new Express Route Circuit Connection to be created."
}

variable "peering" {
  type = object({
    id                         = optional(string)
    name                       = optional(string)
    resource_group_name        = optional(string)
    express_route_circuit_name = optional(string)
    subscription_id            = optional(string)
    tag                        = optional(string)
  })
  description = " (Required) The ID of the Express Route Circuit Private Peering that this Express Route Circuit Connection connects with. Changing this forces a new Express Route Circuit Connection to be created."
}

variable "peer_peering" {
  type = object({
    id                         = optional(string)
    name                       = optional(string)
    resource_group_name        = optional(string)
    express_route_circuit_name = optional(string)
    subscription_id            = optional(string)
    tag                        = optional(string)
  })
  description = "(Required) The ID of the peered Express Route Circuit Private Peering. Changing this forces a new Express Route Circuit Connection to be created."
}

variable "express_route_circuit_peerings" {
  type = map(object({
    id = optional(string)
  }))
  default = {}
}

variable "address_prefix_ipv4" {
  type        = string
  description = "(Required) The IPv4 address space from which to allocate customer address for global reach. Changing this forces a new Express Route Circuit Connection to be created."
}

variable "address_prefix_ipv6" {
  type        = string
  description = "(Optional) The IPv6 address space from which to allocate customer addresses for global reach."
}

variable "authorization_key" {
  type        = string
  description = "(Optional) The authorization key which is associated with the Express Route Circuit Connection."
}