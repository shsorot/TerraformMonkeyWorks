variable "name" {
  type        = string
  description = "(Required) The name of the local network gateway. Changing this forces a new resource to be created."
}

# variable "resource_group_name" {
#     type = string
#     description = " (Required) The name of the resource group in which to create the local network gateway."
# }

variable "resource_group" {
  type = object({
    name = optional(string) # Name of the resource group
    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"
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
  description = <<EOF
   (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"
    id       = # ID of the resource group
    location = # Location of the resource group
    tags     = # List of Azure tags applied to resource group
    name     = # Name of the resource group
  EOF
  default     = {}
}

variable "location" {
  type        = string
  description = "(Required) The location/region where the local network gateway is created. Changing this forces a new resource to be created."
  default     = null
}

variable "address_space" {
  type        = list(string)
  description = "(Optional) The list of string CIDRs representing the address spaces the gateway exposes."
  default     = null
}

variable "bgp_settings" {
  type = list(object({
    asn                 = string           # (Required) The BGP speaker's ASN.
    bgp_peering_address = string           # (Required) The BGP peering address and BGP identifier of this BGP speaker.
    peer_weight         = optional(string) # (Optional) The weight added to routes learned from this BGP speaker.
  }))
  description = "(Optional) A bgp_settings block as defined  containing the Local Network Gateway's BGP speaker settings."
  default     = null
}

variable "gateway_address" {
  type        = string
  description = "(Optional) The gateway IP address to connect with."
  default     = null
}

variable "gateway_fqdn" {
  type        = string
  description = " (Optional) The gateway FQDN to connect with."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}

variable "inherit_tags" {
  type        = bool
  default     = false
  description = "If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'."
}

