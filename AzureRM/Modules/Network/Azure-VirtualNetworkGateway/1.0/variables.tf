variable "name" {
  type        = string
  description = "(Required) The name of the Virtual Network Gateway. Changing the name forces a new resource to be created."
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


variable "location" {
  type        = string
  description = <<HELP
  (Optional) The location/region where the virtual network gateway is created. Changing this forces a new resource to be created. 
  If Null, location from resource group is used.
  HELP
  default     = null
}

variable "type" {
  type        = string
  description = "(Required) The type of the Virtual Network Gateway. Valid options are Vpn or ExpressRoute. Changing the type forces a new resource to be created."
}

variable "vpn_type" {
  type        = string
  description = "(Optional) The routing type of the Virtual Network Gateway. Valid options are RouteBased or PolicyBased. Defaults to RouteBased."
  default     = "RouteBased"
}

variable "enable_bgp" {
  type        = bool
  description = "(Optional) If true, BGP (Border Gateway Protocol) will be enabled for this Virtual Network Gateway. Defaults to false."
  default     = false
}

variable "active_active" {
  type        = bool
  description = "(Optional) If true, an active-active Virtual Network Gateway will be created. An active-active gateway requires a HighPerformance or an UltraPerformance sku. If false, an active-standby gateway will be created. Defaults to false."
  default     = false
}

variable "private_ip_address_enabled" {
  type        = bool
  description = "(Optional) Should private IP be enabled on this gateway for connections? Changing this forces a new resource to be created."
  default     = false
}

variable "default_local_network_gateway" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    tag                 = optional(string)
  })
  description = "(Optional) The ID of the local network gateway through which outbound Internet traffic from the virtual network in which the gateway is created will be routed (forced tunnelling). Refer to the Azure documentation on forced tunnelling. If not specified, forced tunnelling is disabled."
  default     = null
}

variable "local_network_gateways" {
  type = map(object({
    id = string
  }))
  default = null
}

# To build a UltraPerformance ExpressRoute Virtual Network gateway, the associated Public IP needs to be sku "Basic" not "Standard"
variable "sku" {
  type        = string
  description = "(Required) Configuration of the size and capacity of the virtual network gateway. Valid options are Basic, Standard, HighPerformance, UltraPerformance, ErGw1AZ, ErGw2AZ, ErGw3AZ, VpnGw1, VpnGw2, VpnGw3, VpnGw4,VpnGw5, VpnGw1AZ, VpnGw2AZ, VpnGw3AZ,VpnGw4AZ and VpnGw5AZ and depend on the type, vpn_type and generation arguments. A PolicyBased gateway only supports the Basic sku. Further, the UltraPerformance sku is only supported by an ExpressRoute gateway."
}
# Not all skus (e.g. ErGw1AZ) are available in all regions. If you see StatusCode=400 -- Original Error: Code="InvalidGatewaySkuSpecifiedForGatewayDeploymentType" please try another region.

variable "generation" {
  type        = string
  description = "(Optional) The Generation of the Virtual Network gateway. Possible values include Generation1, Generation2 or None."
}

variable "ip_configuration" {
  type = object({
    private_ip_address_allocation = optional(string) # (Optional) Defines how the private IP address of the gateways virtual interface is assigned. Valid options are Static or Dynamic. Defaults to Dynamic.
    subnet = object({                                # (Required) The ID of the gateway subnet of a virtual network in which the virtual network gateway will be created. It is mandatory that the associated subnet is named GatewaySubnet. Therefore, each virtual network can contain at most a single Virtual Network Gateway.
      id                   = optional(string)
      virtual_network_name = optional(string)
      resource_group_name  = optional(string)
      virtual_network_tag  = optional(string)
    })
    public_ip_address = object({ # (Required) The ID of the public ip address to associate with the Virtual Network Gateway.
      id                  = optional(string)
      name                = optional(string)
      resource_group_name = optional(string)
      tag                 = optional(string)
    })
  })
}

variable "virtual_networks" {
  type = map(object({
    id = optional(string)
    subnet = map(object({
      id = optional(string)
    }))
  }))
}


variable "public_ip_addresses" {
  type = map(object({
    fqdn    = optional(string)
    id      = string
    address = optional(string)
  }))
  description = "(Required) Public IP address output from Azure-PublicIPAddress module. IP address must be of type static and standard."
  default     = {}
}


variable "vpn_client_configuration" {
  type = object({
    address_space = string
    aad_tenant    = optional(string)
    aad_audience  = optional(string)
    aad_issuer    = optional(string)
    root_certificate = optional(list(object({
      name             = string
      public_cert_data = string
    })))
    revoked_certificate = optional(list(object({
      name       = string
      thumbprint = string
    })))
    radius_server_address = optional(string)
    radius_server_secret  = optional(string)
    vpn_client_protocols  = optional(string)
    vpn_auth_types        = optional(string)
  })
}

variable "bgp_settings" {
  type = list(object({
    asn = optional(string)                     # (Optional) The Autonomous System Number (ASN) to use as part of the BGP.
    peering_addresses = list(object({          # (Optional) A list of peering_addresses as defined below. Only one peering_addresses block can be specified except when active_active of this Virtual Network Gateway is true.
      ip_configuration_name = optional(string) # (Optional) The name of the IP configuration of this Virtual Network Gateway. In case there are multiple ip_configuration blocks defined, this property is required to specify.
      apipa_addresses       = optional(string) # (Optional) A list of Azure custom APIPA addresses assigned to the BGP peer of the Virtual Network Gateway.
    }))
    peer_weight = optional(string) # (Optional) The weight added to routes which have been learned through BGP peering. Valid values can be between 0 and 100.
  }))
  default = null
}

variable "custom_route" {
  type = object({
    address_prefixes = list(string) # (Optional) A list of address blocks reserved for this virtual network in CIDR notation.
  })
  default = null
}



