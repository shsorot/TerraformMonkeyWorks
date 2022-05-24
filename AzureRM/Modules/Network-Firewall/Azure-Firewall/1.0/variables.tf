variable "name" {
  description = "(Required) Specifies the name of the Firewall. Changing this forces a new resource to be created."
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


variable "sku_name" {
  type        = string
  description = "(Optional) Sku name of the Firewall. Possible values are AZFW_Hub and AZFW_VNet. Changing this forces a new resource to be created."
  default     = null
}

variable "sku_tier" {
  type        = string
  description = "(Optional) Sku tier of the Firewall. Possible values are Premium and Standard. Changing this forces a new resource to be created."
  default     = null
}

variable "firewall_policy" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    tag                 = optional(string)
  })
  description = "(Optional) The ID of the Firewall Policy applied to this Firewall."
  default     = null
}

variable "firewall_policies" {
  type = map(object({
    id = optional(string)
  }))
  description = "(Optional) Output of module Azure-FirewallPolicy"
  default     = {}
}

variable "ip_configuration" {
  type = object({
    name = optional(string) # (Required) Specifies the name of the IP Configuration.
    subnet = object({       # (Required) Specifies the subnet of the IP Configuration.Must be /26 and named "AzureFirewallSubnet"
      id                   = optional(string)
      virtual_network_name = optional(string)
      resource_group_name  = optional(string)
      virtual_network_tag  = optional(string)
    })
    public_ip_address = object({
      id                  = optional(string)
      name                = optional(string)
      resource_group_name = optional(string)
      tag                 = optional(string)
    })
  })
}

variable "management_ip_configuration" {
  type = object({
    name = optional(string) # (Required) Specifies the name of the IP Configuration.
    subnet = object({       # (Required) The Management Subnet used for the Firewall must have the name AzureFirewallManagementSubnet and the subnet mask must be at least a /26.
      id                   = optional(string)
      virtual_network_name = optional(string)
      resource_group_name  = optional(string)
      virtual_network_tag  = optional(string)
    })
    public_ip_address = object({
      id                  = optional(string)
      name                = optional(string)
      resource_group_name = optional(string)
      tag                 = optional(string)
    })
  })
  default = null
}

variable "virtual_networks" {
  type = map(object({
    id = optional(string)
    subnet = map(object({
      id = optional(string)
    }))
  }))
  default = {}
}

variable "public_ip_addresses" {
  type = map(object({
    id = optional(string)
  }))
  default = {}
}


variable "dns_servers" {
  type        = list(string)
  description = "(Optional) A list of DNS servers that the Azure Firewall will direct DNS traffic to the for name resolution."
  default     = null
}

variable "private_ip_ranges" {
  type        = list(string)
  description = "(Optional) A list of SNAT private CIDR IP ranges, or the special string IANAPrivateRanges, which indicates Azure Firewall does not SNAT when the destination IP address is a private range per IANA RFC 1918."
  default     = null
}

variable "threat_intel_mode" {
  type        = string
  description = "(Optional) The operation mode for threat intelligence-based filtering. Possible values are: Off, Alert,Deny and ''(empty string). Defaults to Alert"
  default     = null
}


variable "virtual_hub" {
  type = object({
    public_ip_count = optional(number) # (Optional) Specifies the number of public IPs to assign to the Firewall. Defaults to 1.
    virtual_hub = object({             # (Required) Specifies the ID of the Virtual Hub where the Firewall resides in.
      id                  = optional(string)
      name                = optional(string)
      resource_group_name = optional(string)
      tag                 = optional(string)
    })
  })
  default = null
}

variable "virtual_hubs" {
  type = map(object({
    id = optional(string)
  }))
  description = "(Optional)Output of module Azure-VirtualHub"
  default     = null
}

variable "zones" {
  type        = list(number)
  description = "(Optional) A list of availability zones where the Firewall will be created. Defaults to null."
  default     = null
}