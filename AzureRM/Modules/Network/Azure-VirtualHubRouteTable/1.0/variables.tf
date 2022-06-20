variable "name" {
  type        = string
  description = "(Required) The name which should be used for this Virtual Hub IP. Changing this forces a new resource to be created."
}

variable "virtual_hub" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    key                 = optional(string)
  })
  description = "(Required) The ID of the Virtual Hub within which this ip configuration should be created. Changing this forces a new resource to be created."
}


variable "virtual_hubs" {
  type = map(object({
    id = optional(string)
  }))
}

variable "labels" {
  type        = list(string)
  description = "(Optional) List of labels associated with this route table."
  default     = null
}

# <TODO> add a resource lookup for azurerm_virtual_hub_connection for next_hop sub property
variable "route" {
  type = object({
    name              = string       #(Required) The name which should be used for this route.
    destinations      = list(string) #(Required) The list of destinations for this route.
    destinations_type = string       #(Required) The type of destination for this route. Possible values are CIDR, ResourceId and Service
    next_hop          = string       # (Required) The next hop's resource id( virtual hub connection)
    next_hop_type     = string       # (Optional) The type of next hop. Currently the only possible value is ResourceId. Defaults to ResourceId.
  })
}