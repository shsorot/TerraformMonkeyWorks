variable "name" {
  type        = string
  description = "(Required) The name of the DNS A Record."
}

# variable "resource_group_name" {
#     type = string 
#     description = "(Required) Specifies the resource group where the resource exists. Changing this forces a new resource to be created."
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

variable "zone_name" {
  type        = string
  description = "(Required) Specifies the Private DNS Zone where the resource exists. Changing this forces a new resource to be created."
}

variable "ttl" {
  type        = number
  description = "(Required) The Time To Live (TTL) of the DNS record in seconds."
}

variable "record" {
  type = list(object({
    priority = number
    weight   = number
    port     = number
    target   = string
  }))
  description = "(Required) The target of the CNAME."
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
}

variable "inherit_tags" {
  type    = bool
  default = false
}