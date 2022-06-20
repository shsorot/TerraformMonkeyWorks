variable "peering_type" {
  type        = string
  description = "(Required) The type of the ExpressRoute Circuit Peering. Acceptable values include AzurePrivatePeering, AzurePublicPeering and MicrosoftPeering. Changing this forces a new resource to be created."
}

variable "express_route_circuit" {
  type = object({
    name = optional(string)
    key  = optional(string)
  })
  description = "(Required) The name of the ExpressRoute Circuit in which to create the Peering."
}

variable "express_route_circuits" {
  type = map(object({
    id   = optional(string)
    name = optional(string)
  }))
}

variable "resource_group" {
  type = object({
    name = optional(string)
    key  = optional(string)
  })
  description = "(Required) The name of the resource group in which to create the Express Route Circuit Peering. Changing this forces a new resource to be created."
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

variable "primary_peer_address_prefix" {
  type        = string
  description = "(Required) A /30 subnet for the primary link."
}

variable "secondary_peer_address_prefix" {
  type        = string
  description = "(Required) A /30 subnet for the secondary link."
}

variable "vlan_id" {
  type        = string
  description = "(Required) A valid VLAN ID to establish this peering on."
}

variable "shared_key" {
  type        = string
  description = "(Optional) The shared key. Can be a maximum of 25 characters."
  default     = null
}

variable "peer_asn" {
  type        = string
  description = "(Optional) The Either a 16-bit or a 32-bit ASN. Can either be public or private."
  default     = null
}

variable "microsoft_peering_config" {
  type = object({
    advertised_public_prefixes = optional(list(string)) # (Required) A list of Advertised Public Prefixes.
    customer_asn               = optional(string)       # (Optional) The CustomerASN of the peering.
    routing_registry_name      = optional(string)       # (Optional) The Routing Registry against which the AS number and prefixes are registered. For example: ARIN, RIPE, AFRINIC etc.
  })
  default = null
}

variable "ipv6" {
  type = object({
    microsoft_peering = object({
      advertised_public_prefixes = list(string)     # (Required) A list of Advertised Public Prefixes.
      customer_asn               = optional(string) # (Optional) The CustomerASN of the peering.
      routing_registry_name      = optional(string) # (Optional) The Routing Registry against which the AS number and prefixes are registered. For example: ARIN, RIPE, AFRINIC etc.
    })
  })
  default = null
}

variable "route_filter" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    key                 = optional(string)
  })
  description = "(Optional) The ID of the Route Filter. Only available when peering_type is set to MicrosoftPeering."
  default     = null
}


variable "route_filters" {
  type = map(object({
    id = optional(string)
  }))
  default = {}
}