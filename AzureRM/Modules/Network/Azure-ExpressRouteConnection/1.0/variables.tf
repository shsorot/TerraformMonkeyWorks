variable "name" {
  type        = string
  description = "(Required) The name which should be used for this Express Route Connection. Changing this forces a new resource to be created."
}

variable "express_route_circuit_peering" {
  type = object({
    id                         = optional(string)
    name                       = optional(string)
    resource_group_name        = optional(string)
    express_route_circuit_name = optional(string)
    tag                        = optional(string)
  })
  description = "(Required) The ID of the Express Route Circuit Peering that this Express Route Connection connects with. Changing this forces a new resource to be created."
}

variable "express_route_circuit_peerings" {
  type = map(object({
    id = optional(string)
  }))
  default = {}
}

variable "express_route_gateway" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    key                 = optional(string)
  })
  description = "(Required) The ID of the Express Route Gateway that this Express Route Connection connects with. Changing this forces a new resource to be created."
}

variable "express_route_gateways" {
  type = map(object({
    id = optional(string)
  }))
  default = {}
}

variable "authorization_key" {
  type        = string
  description = "(Optional) The authorization key to establish the Express Route Connection."
}

variable "enable_internet_security" {
  type        = bool
  description = "(Optional) Is Internet security enabled for this Express Route Connection?"
  default     = false
}

variable "routing" {
  type = object({
    associated_route_table = object({ # (Optional) The ID of the Virtual Hub Route Table associated with this Express Route Connection.
      id                  = optional(string)
      name                = optional(string)
      resource_group_name = optional(string)
      key                 = optional(string)
    })
    propagated_route_table = object({
      labels = optional(string)                # (Optional) The list of labels to logically group route tables.
      route_table_ids = optional(list(object({ # (Optional) A list of IDs of the Virtual Hub Route Table to propagate routes from Express Route Connection to the route table.
        id                  = optional(string)
        name                = optional(string)
        resource_group_name = optional(string)
        key                 = optional(string)
      })))
    })
  })
  default = null
}

variable "routing_weight" {
  type        = number
  description = "(Optional) The routing weight associated to the Express Route Connection. Possible value is between 0 and 32000. Defaults to 0."
  default     = 0
}

variable "virtual_hub_route_tables" {
  type = map(object({
    id = optional(string)
  }))
  default = {}
}