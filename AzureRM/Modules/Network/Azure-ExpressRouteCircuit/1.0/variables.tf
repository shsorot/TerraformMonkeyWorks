variable "name" {
  description = "(Required) The name of the ExpressRoute circuit. Changing this forces a new resource to be created."
  type        = string
}

# variable "resource_group_name" {
#     description = "(Required) The name of the resource group in which to create the Application Security Group."
#     type = string
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
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "inherit_tags" {
  type    = bool
  default = false
}


variable "sku" {
  type = object({
    tier   = string #(Required) The service tier. Possible values are Basic, Local, Standard or Premium.
    family = string #(Required) The billing mode for bandwidth. Possible values are MeteredData or UnlimitedData.
  })
}

variable "service_provider_name" {
  type        = string
  description = "(Optional) The name of the ExpressRoute Service Provider. Changing this forces a new resource to be created."
  default     = null
}

variable "peering_location" {
  type        = string
  description = "(Optional) The name of the peering location and not the Azure resource location. Changing this forces a new resource to be created."
  default     = null
}

variable "bandwidth_in_mbps" {
  type        = number
  description = "(Optional) The bandwidth in Mbps of the circuit being created on the Service Provider."
}

#The service_provider_name, the peering_location and the bandwidth_in_mbps should be set together
#and they conflict with express_route_port_id and bandwidth_in_gbps.

variable "allow_classic_operations" {
  type        = bool
  description = "(Optional) Allow the circuit to interact with classic (RDFE) resources. Defaults to false."
  default     = false
}

variable "express_route_port" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    tag                 = optional(string)
  })
  description = "(Optional) The ID of the Express Route Port this Express Route Circuit is based on."
  default     = null
}

variable "express_route_ports" {
  type = map(object({
    id = optional(string)
  }))
  default = {}
}

variable "bandwidth_in_gbps" {
  type        = number
  description = "(Optional) The bandwidth in Gbps of the circuit being created on the Express Route Port."
  default     = null
}

#The express_route_port_id and the bandwidth_in_gbps should be set together 
#and they conflict with service_provider_name, peering_location and bandwidth_in_mbps.