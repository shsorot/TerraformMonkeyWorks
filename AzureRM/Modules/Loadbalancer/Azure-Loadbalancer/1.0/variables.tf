variable "location" {
  description = "(Optional) The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
  type        = string
  default     = null
}

# variable "resource_group_name" {
#   description = "(Required) The name of the resource group where the load balancer resources will be imported."
#   type        = string
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

variable "name" {
  type        = string
  description = "(Required) Specifies the name of the Load Balancer."
}

variable "sku" {
  type        = string
  description = "(Optional) The SKU of the Azure Load Balancer. Accepted values are Basic and Standard. Defaults to Basic."
  default     = "Basic"
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}

variable "inherit_tags" {
  type    = bool
  default = false
}

variable "frontend_ip_configuration" {
  description = "(Optional) One or multiple frontend_ip_configuration blocks as documented below."
  type = list(object({
    name = string # Required) Specifies the name of the frontend ip configuration.
    subnet = object({
      id                   = optional(string)
      name                 = optional(string)
      virtual_network_name = optional(string)
      resource_group_name  = optional(string)
      tag                  = optional(string)
      virtual_network_tag  = optional(string)
    })

    private_ip_address            = optional(any)    # (Optional) Private IP Address to assign to the Load Balancer. The last one and first four IPs in any range are reserved and cannot be manually assigned.
    private_ip_address_allocation = optional(string) # (Optional) The allocation method for the Private IP Address used by this Load Balancer. Possible values as Dynamic and Static.
    private_ip_address_version    = optional(string) # The version of IP that the Private IP Address is. Possible values are IPv4 or IPv6

    public_ip_address = optional(object({
      id                  = optional(string)
      name                = optional(string)
      resource_group_name = optional(string)
      tag                 = optional(string)
    }))

    public_ip_prefix = optional(object({
      id                  = optional(string)
      name                = optional(string)
      resource_group_name = optional(string)
      tag                 = optional(string)
    }))

    # availability_zone = optional(string) # (Optional) Refer to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#availability_zone 
    zones               = optional(list(string)) #(Optional) Refer to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb#availability_zone 
  }))
  default = []
}



variable "virtual_networks" {
  description = "(Optional) Output object from Module Azure-VirtualNetwork, to be used with 'virtual_network_tag' and 'virtual_network_tag'"
  type = map(object({
    id   = string # Resource ID of the virtual Network
    name = string # Name of the Virtual Network
    subnet = map(object({
      id = string
    }))
  }))
  default = {}
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


variable "public_ip_prefixes" {
  description = "(Optional) Output of Module Azure-PublicIPPRefix, used to lookup resource ID when var.public_ip_prefix_tag is specified."
  type = map(object({
    id        = string           # Resource ID of the public ip prefix object
    ip_prefix = optional(string) # CIDR prefix count of prefix object.
  }))
  default = {}
}