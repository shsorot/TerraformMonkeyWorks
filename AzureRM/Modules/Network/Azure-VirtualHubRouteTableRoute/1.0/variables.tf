variable "name" {
  type        = string
  description = "(Required) The name which should be used for this route. Changing this forces a new resource to be created."
}

variable "route_table" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    virtual_hub_name    = optional(string)
    resource_group_name = optional(string)
    tag                 = optional(string)
  })
}
variable "route_tables" {
  type = map(object({
    id = string
  }))
  default = {}
}

variable "destinations" {
  type        = list(string)
  description = "(Required) A list of destination addresses for this route."
}

variable "destinations_type" {
  type        = string
  description = "(Required) The type of destinations. Possible values are CIDR, ResourceId and Service. Defaults to CIDR"
  default     = "CIDR"
}

variable "next_hop" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    virtual_hub_name    = optional(string)
    tag                 = optional(string)
  })
  description = "(Required) The next hop's resource ID ( azurerm_virtual_hub_connection )"
}

variable "virtual_hub_connections" {
  type = map(object({
    id = string
  }))
  default = {}
}

variable "next_hop_type" {
  type        = string
  description = " (Optional) The type of next hop. Currently the only possible value is ResourceId. Defaults to ResourceId."
  default     = "ResourceId"
}