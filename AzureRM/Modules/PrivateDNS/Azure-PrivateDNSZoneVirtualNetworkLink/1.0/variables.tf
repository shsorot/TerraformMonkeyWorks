variable "name" {
  type        = string
  description = "(Required) The name of the Private DNS Zone Virtual Network Link. Changing this forces a new resource to be created."
}

variable "private_dns_zone" {
  type        = object({
    name = optional(string)
    key  = optional(string)
  })
  description = "(Required) The name of the Private DNS zone (without a terminating dot). Changing this forces a new resource to be created."
}


variable "private_dns_zones"{
  type = map(object({
    id    = optional(string)
    name  = optional(string)
  }))
  default = {} 
}
# variable "resource_group_name" {
#     type        =   string 
#     description =   "(Required) Specifies the resource group where the Private DNS Zone exists. Changing this forces a new resource to be created."
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

variable "virtual_network" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    key                 = optional(string)
  })
  description = "(Required) The ID of the Virtual Network that should be linked to the DNS Zone. Changing this forces a new resource to be created."
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

variable "registration_enabled" {
  type        = string
  description = "(Optional) Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled? Defaults to false."
  default     = false
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

