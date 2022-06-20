variable "name" {
  type        = string
  description = "(Required) The name of the virtual network peering. Changing this forces a new resource to be created.If Null, Vnet names are used to generate Peer names across source and destination."
  default     = null
}

variable "local_virtual_network" {
  type = object({
    name                = optional(string)
    resource_group_name = optional(string)
    subscription_id     = optional(string)
    key                 = optional(string)
  })
  description = "(Required) The name of the virtual network. Changing this forces a new resource to be created."
}

variable "remote_virtual_network" {
  type = object({
    name                = optional(string)
    resource_group_name = optional(string)
    subscription_id     = optional(string)
    key                 = optional(string)
  })
  description = "(Required) The full Azure resource ID of the remote virtual network. Changing this forces a new resource to be created."
  default     = null
}



variable "virtual_networks" {
  type = map(object({
    id = optional(string)
  }))
  description = "(Optional) Output of module Azure-VirtualNetwork"
}
variable "allow_virtual_network_access" {
  type        = bool
  description = "(Optional) Controls if the VMs in the remote virtual network can access VMs in the local virtual network. Defaults to true."
  default     = true
}

variable "allow_forwarded_traffic" {
  type        = bool
  description = "(Optional) Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to false."
  default     = false
}

variable "allow_gateway_transit" {
  type        = bool
  description = <<HELP
  (Optional) Controls gatewayLinks can be used in the REMOTE virtual network’s link to the local virtual network. 
  This cannot be set to 'true' when 'use_remote_gateways' is set to 'true'. "
  HELP
  default     = false
}

variable "use_remote_gateways" {
  type        = bool
  description = <<HELP
  (Optional) Controls if remote gateways can be used on the LOCAL virtual network. If the flag is set to true, and allow_gateway_transit on the remote peering is also true, virtual network will use gateways of remote virtual network for transit. Only one peering can have this flag set to true. This flag cannot be set if virtual network already has a gateway. Defaults to false."
  This cannot be set to 'true' when 'allow_gateway_transit' is set to 'true'. "
  HELP
  default     = false
}

