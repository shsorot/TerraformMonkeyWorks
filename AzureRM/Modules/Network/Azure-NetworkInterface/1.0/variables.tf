# variable "resource_group_name" {
#   description = "(Required)The name of the resource group in which the resources will be created."
#   type        = string
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
  description = "(Optional) The location in which the resources will be created."
  type        = string
  default     = ""
}

variable "name" {
  description = "(Required) Name of the VM NiC."
  type        = string
}

variable "tags" {
  type    = map(string)
  description = " (Optional) A mapping of tags to assign to the resource."
  default = {}
}

variable "inherit_tags" {
  type        = bool
  description = "(Optionla) Inherit tags from resource group."
  default     = false
}

variable "dns_servers" {
  type        = list(string)
  description = "(Optional) A list of IP Addresses defining the DNS Servers which should be used for this Network Interface."
  default     = []
}

variable "enable_ip_forwarding" {
  type        = bool
  description = "(Optional) Should IP Forwarding be enabled? Defaults to false"
  default     = false
}

variable "enable_accelerated_networking" {
  type        = bool
  description = "(Optional) Should Accelerated Networking be enabled? Defaults to false. Supported by limited subnet of VM Sku's."
  default     = false
}

variable "internal_dns_name_label" {
  type        = string
  description = "(Optional) The (relative) DNS Name used for internal communications between Virtual Machines in the same Virtual Network."
  default     = null
}

variable "ip_configuration" {
  type = list(object({
    name = string # Required, Name of the IP configuration.If Empty, key name is used.
    subnet = object({
      id                   = optional(string)
      name                 = optional(string)
      virtual_network_name = optional(string)
      resource_group_name  = optional(string)
      key                  = optional(string)
      virtual_network_key  = optional(string)
    })
    private_ip_address         = optional(string) # Private IP Address. If left null, dynamic allocation is used.
    private_ip_address_version = optional(string) # (Optional) The IP Version to use. Possible values are IPv4 or IPv6. Defaults to IPv4
    primary                    = optional(bool)

    public_ip_address = optional(object({
      id                  = optional(string)
      name                = optional(string)
      resource_group_name = optional(string)
      key                 = optional(string)
    }))
  }))
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


variable "application_security_groups" {
  type = map(object({
    id = string
  }))
  default     = {}
  description = "(Optional) Output of module Azure-ApplicationSecurityGroup."
}