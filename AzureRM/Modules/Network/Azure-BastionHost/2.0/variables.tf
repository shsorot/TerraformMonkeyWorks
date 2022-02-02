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
  description = "(Required) Specifies the supported Azure location where the resource exists.If Null, resource group location is used instead."
  type        = string
  default     = null
}

variable "ip_configuration_name" {
  type    = string
  default = "ip_configuration"
}


variable "subnet" {
  description = "(Required) Reference to a Virtual Network in which this Bastion Host subnet will be  created."
  type = object({
    virtual_network_name = string
    resource_group_name  = string
    address_prefixes     = list(string)
  })
}

variable "public_ip_address" {
  description = ""
  type = object({
    name                = string
    resource_group_name = optional(string)
  })
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
