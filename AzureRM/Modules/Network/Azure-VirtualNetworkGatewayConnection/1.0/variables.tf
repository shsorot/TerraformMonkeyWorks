variable "name" {
  type        = string
  description = "(Required) The name of the connection. Changing the name forces a new resource to be created."
}


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
  type        = string
  description = "(Optional) The location of the resource. If not provided, the location of the resource group will be used."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}

variable "inherit_tags" {
  type        = bool
  description = "(Required) Boolean value to denote if if should inherit tags from parent resource group."
  default     = false
}

variable "type" {
  type        = string
  description = "(Required) The type of connection. Valid options are IPsec (Site-to-Site), ExpressRoute (ExpressRoute), and Vnet2Vnet (VNet-to-VNet). Each connection type requires different mandatory arguments (refer to the examples above). Changing the connection type will force a new connection to be created."
}

variable "virtual_network_gateway" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    tag                 = optional(string)
  })
  description = "(Required) The ID of the Virtual Network Gateway in which the connection will be created. Changing the gateway forces a new resource to be created."
}

variable "authorization_key" {
  type        = string
  description = " (Optional) The authorization key associated with the Express Route Circuit. This field is required only if the type is an ExpressRoute connection."
  default     = null
}


variable "dpd_timeout_seconds" {
  type        = number
  description = "(Optional) The dead peer detection timeout of this connection in seconds. Changing this forces a new resource to be created."
  default     = null
}

variable "express_route_circuit" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    tag                 = optional(string)
  })
  description = "(Optional) The ID of the Express Route Circuit when creating an ExpressRoute connection (i.e. when type is ExpressRoute). The Express Route Circuit can be in the same or in a different subscription."
  default     = null
}

variable "peer_virtual_network_gateway" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    tag                 = optional(string)
  })
  description = "(Optional) The ID of the peer virtual network gateway when creating a VNet-to-VNet connection (i.e. when type is Vnet2Vnet). The peer Virtual Network Gateway can be in the same or in a different subscription."
  default     = null
}

variable "local_azure_ip_address_enabled" {
  type        = bool
  description = "(Optional) Use private local Azure IP for the connection. Changing this forces a new resource to be created."
  default     = false
}

variable "local_network_gateway" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    tag                 = optional(string)
  })
  description = "(Optional) The ID of the local network gateway when creating Site-to-Site connection (i.e. when type is IPsec)."
  default     = null
}

variable "routing_weight" {
  type        = number
  description = "(Optional) The routing weight. Defaults to 10."
  default     = 10
}

variable "shared_key" {
  type        = string
  description = "(Optional) The shared IPSec key. A key could be provided if a Site-to-Site, VNet-to-VNet or ExpressRoute connection is created."
  default     = null
}

variable "connection_protocol" {
  type        = string
  description = "(Optional) The IKE protocol version to use. Possible values are IKEv1 and IKEv2. Defaults to IKEv2. Changing this value will force a resource to be created. -> Note: Only valid for IPSec connections on virtual network gateways with SKU VpnGw1, VpnGw2, VpnGw3, VpnGw1AZ, VpnGw2AZ or VpnGw3AZ."
  default     = "IKev2"
}

variable "enable_bgp" {
  type        = bool
  description = "(Optional) If true, BGP (Border Gateway Protocol) is enabled for this connection. Defaults to false."
  default     = false
}

variable "express_route_gateway_bypass" {
  type        = bool
  description = "(Optional) If true, data packets will bypass ExpressRoute Gateway for data forwarding This is only valid for ExpressRoute connections."
  default     = false
}

variable "use_policy_based_traffic_selectors" {
  type        = bool
  description = "(Optional) If true, policy-based traffic selectors are enabled for this connection. Enabling policy-based traffic selectors requires an ipsec_policy block. Defaults to false."
  default     = false
}

variable "ipsec_policy" {
  type = object({
    dh_group         = string #(Required) The DH group used in IKE phase 1 for initial SA. Valid options are DHGroup1, DHGroup14, DHGroup2, DHGroup2048, DHGroup24, ECP256, ECP384, or None.
    ike_encryption   = string #(Required) The IKE encryption algorithm. Valid options are AES128, AES192, AES256, DES, DES3, GCMAES128, or GCMAES256.
    ike_integrity    = string #(Required) The IKE integrity algorithm. Valid options are GCMAES128, GCMAES256, MD5, SHA1, SHA256, or SHA384.
    ipsec_encryption = string # (Required) The IPSec encryption algorithm. Valid options are AES128, AES192, AES256, DES, DES3, GCMAES128, GCMAES192, GCMAES256, or None.
    ipsec_integrity  = string # (Required) The IPSec integrity algorithm. Valid options are GCMAES128, GCMAES192, GCMAES256, MD5, SHA1, or SHA256.
    pfs_group        = string #(Required) The DH group used in IKE phase 2 for new child SA. Valid options are ECP256, ECP384, PFS1, PFS14, PFS2, PFS2048, PFS24, PFSMM, or None.
    sa_datasize      = number #(Optional) The IPSec SA payload size in KB. Must be at least 1024 KB. Defaults to 102400000 KB.
    sa_lifetime      = number #(Optional) The IPSec SA lifetime in seconds. Must be at least 300 seconds. Defaults to 27000 seconds.
  })
  description = "(Optional) A ipsec_policy block which is documented below. Only a single policy can be defined for a connection. For details on custom policies refer to the relevant section in the Azure documentation."
  default     = null
}

variable "traffic_selector_policy" {
  type = object({
    local_address_cidrs  = list(string)
    remote_address_cidrs = list(string)
  })
  description = "(Optional)A traffic_selector_policy which allows to specify traffic selector policy proposal to be used in a virtual network gateway connection. Only one block can be defined for a connection. For details about traffic selectors refer to the relevant section in the Azure documentation."
  default     = null
}

variable "local_network_gateways" {
  type = map(object({
    id = optional(string)
  }))
  default = {}
}

variable "express_route_circuits" {
  type = map(object({
    id = optional(string)
  }))
  default = {}
}

variable "virtual_network_gateways" {
  type = map(object({
    id = optional(string)
  }))
  default = {}
}
