variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup."
}


variable "name" {
  type        = string
  description = "(Required) The name of the route. Changing this forces a new resource to be created."
}

variable "address_prefix" {
  type        = string
  description = "(Required) The destination CIDR to which the route applies, such as 10.1.0.0/16"
}

variable "next_hop_type" {
  type        = string
  description = "(Required) The type of Azure hop the packet should be sent to. Possible values are VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance and None"
}

variable "next_hop_in_ip_address" {
  type        = string
  description = " (Optional) Contains the IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance."
}

variable "route_table" {
  type = object({
    name = optional(string)
    tag  = optional(string)
  })
  description = "(Required) The name of the route table within which create the route. Changing this forces a new resource to be created."
}


variable "route_tables" {
  type = map(object({
    id   = optional(string)
    name = optional(string)
    tag  = optional(string)
  }))
}
