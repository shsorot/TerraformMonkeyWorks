variable "name" {
  description = "(Required) The name of the Virtual Hub. Changing this forces a new resource to be created."
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

variable "address_prefix" {
  type        = string
  description = "(Optional) The Address Prefix which should be used for this Virtual Hub. Changing this forces a new resource to be created. The address prefix subnet cannot be smaller than a /24. Azure recommends using a /23."
  default     = null
}

variable "sku" {
  type        = string
  description = "(Optional) The sku of the Virtual Hub. Possible values are Basic and Standard. Changing this forces a new resource to be created."
  default     = null
}

variable "route" {
  type = list(object({
    address_prefixes    = list(string) #  A list of Address Prefixes.
    next_hop_ip_address = string       # (Required) The IP Address that Packets should be forwarded to as the Next Hop.
  }))
  default = null
}

variable "virtual_wan" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    tag                 = optional(string)
  })
  description = "(Optional) The ID of a Virtual WAN within which the Virtual Hub should be created. Changing this forces a new resource to be created."
}

variable "virtual_wans" {
  type = map(object({
    id = optional(string)
  }))
  default = {}
}