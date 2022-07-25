variable "name" {
  description = "Required) Specifies the name of the Bastion Host. Changing this forces a new resource to be created"
  type        = string
}
# variable "resource_group_name" {
#     description =   "Required) The name of the resource group in which to create the Bastion Host."
#     type        =   string
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
  description = "(Required) Specifies the supported Azure location where the resource exists.If Null, resource group location is used instead."
  type        = string
  default     = null
}

variable "ip_configuration_name" {
  type    = string
  default = "ip_configuration"
}


variable "subnet" {
  description = "(Required) Reference to a subnet in which this Bastion Host has been created."
  type = object({
    id                   = optional(string)
    name                 = optional(string)
    virtual_network_name = optional(string)
    resource_group_name  = optional(string)
    key                  = optional(string)
    virtual_network_key  = optional(string)
  })
}

variable "public_ip_address" {
  description = ""
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    key                 = optional(string)
  })
}


variable "virtual_networks" {
  description = "(Optional) Output object from Module Azure-VirtualNetwork, to be used with 'virtual_network_tag' and 'virtual_network_tag'"
  type = map(object({
    id   = string # Resource ID of the virtual Network
    name = string # Name of the Virtual Network
    subnet = map(object({
      id = optional(string)
    }))
  }))
  default = {}
}


variable "public_ip_addresses" {
  type = map(object({
    fqdn    = string
    id      = string
    address = string
  }))
  description = "(Required) Public IP address output from Azure-PublicIPAddress module. IP address must be of type static and standard."
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

