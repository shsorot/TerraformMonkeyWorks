variable "tags" {
  type    = map(string)
  default = {}
}

variable "inherit_tags" {
  type    = bool
  default = false
}

# variable "resource_group_name" {
#   type = string
# }

variable "resource_group" {
  type = object({
    name = optional(string)
    tag  = optional(string)
  })
  description = "(Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup."
}

variable "resource_groups" {
  type = map(object({
    id       = optional(string)
    location = optional(string)
    tags     = optional(map(string))
    name     = optional(string)
  }))
  description = "(Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Tags"
  default     = {}
}

variable "location" {
  type    = string
  default = null
}

variable "name" {
  type = string
}

variable "disable_bgp_route_propagation" {
  type = bool
}

variable "route" {
  type = list(object({
    name                   = string
    address_prefix         = string # Destination CIDR range
    next_hop_type          = string # Type of the next hop. Can be one of "VirtualNetworkGateway", "VnetLocal", "Internet", "VirtualAppliance" and "None".
    next_hop_in_ip_address = optional(string) # IP address of the next hop. Only applicable if next_hop_type is set to "VirtualAppliance" (otherwise must be set to null).
  }))
  default     = []
  description = "(Optional) List of objects representing routes. Each object accepts the arguments. Set to [] to remove routes."
}

